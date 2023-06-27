import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'box.dart';
class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  TextEditingController editingController = TextEditingController();
  Box? box;
  List list = [];
  int selectedIndex = -1;
  Future openBox()async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }
  Future<bool> getAllData()async{
    await openBox();
    String url = 'https://jsonplaceholder.typicode.com/posts';
    try{
      var response =await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      await putData(data);

    }catch(SocketException){
      print('you dont have internet');
    }
    var myMap = box?.toMap().values.toList();
    if(myMap!.isEmpty){
      list.add('empty');
    }else{
      list = myMap;
    }
    return Future.value(true);
  }
  Future putData(datas) async{
    await box?.clear();
    for(var d in datas){
      box?.add(d);
    }
  }
  editData(String newText , index){
    setState(() {
      box?.getAt(index);
    });
  }
   addData(String add){
    if(add.isNotEmpty){
      setState(() {
        box?.add(Boxtem(title: add));
      });
    }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: getAllData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
                if(list.contains('empty')){
                  return Text('no data');
                }else{
                  return Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: list.length,
                          itemBuilder: (context,index)=>
                      Card(
                        child:ListTile(
                          title: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(child: Text(list[index]['title'],)),
                              IconButton(onPressed: () {
                                setState(() {
                                  showBottomScreen();
                                });
                              },icon: Icon(Icons.edit,color: Colors.indigo,),),
                              IconButton(onPressed: (){
                                setState(() {
                                  box?.deleteAt(index);
                                });
                                },
                                  icon: Icon(Icons.delete,color: Colors.red,))
                            ],
                          ),
                        ),
                      )
                      ))
                    ],
                  );
                }
              }else{
                return CircularProgressIndicator();
              }
            },),
        ),
      ),
    );
  }
  showBottomScreen(){
    return showModalBottomSheet(context: context, builder: (_)=>
    Center(
      child: Column(
        children: [
          TextField(
            controller: editingController,
            decoration: InputDecoration(
              hintText: ''
            ),
          ),
          ElevatedButton(
              onPressed: (){
            String title = editingController.text.trim();
            if(title.isNotEmpty){
              setState(() {
                editingController.text = '';
              });
            }
          }, child: Text('Update'))
        ],
      ),
    )
    );
  }
}

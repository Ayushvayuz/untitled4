import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled4/Dio+Hive_Database/Provider/ApiCall.dart';

class ViewPage extends StatefulWidget {
   ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  ApiCall controller = ApiCall();
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Provider.of<ApiCall>(context, listen: false);
    controller.getAllData();
    controller.box;
    controller.openBox();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApiCall>();
    return Scaffold(
      appBar: AppBar(
        title: Text('ApiCall'),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: controller.getAllData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (controller.list.contains('empty')) {
                  return Text('no data');
                } else {
                  return Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: controller.list.length,
                              itemBuilder: (context, index) => Card(
                                    child: ListTile(
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            controller.list[index]['title'],
                                          )),
                                          IconButton(
                                            onPressed: () {
                                                showBottomScreen(index,controller.list[index]['title']);
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: (){
                                                provider.deleteBox(index);
                                                print(index);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ),
                                  )))
                    ],
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  showBottomScreen(int index , String title) {
    final pController = TextEditingController(text: title);
    return showModalBottomSheet(
        context: context,
        builder: (_) => Center(
              child: Column(
                children: [
                  TextField(
                    controller: pController,
                    decoration: InputDecoration(hintText: '',
                    border: OutlineInputBorder()
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){

                        controller.updateUser(index, title);
                        Navigator.pop(context);
                      }, child: Text('Update'))
                ],
              ),
            ));
  }
}

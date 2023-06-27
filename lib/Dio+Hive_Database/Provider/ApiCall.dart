import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
class ApiCall with ChangeNotifier{
  Box? box;
  List list = [];
  int selectedIndex = -1;
  Future openBox()async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
    notifyListeners();
  }
  Future<bool> getAllData()async{
    await openBox();
    String url = 'https://jsonplaceholder.typicode.com/posts';
    try{
      var response =await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      await putData(data);

    }catch(SocketException){
      print('No internet');
    }
    var myMap = box?.toMap().values.toList();
    if(myMap!.isEmpty){
      list.add('empty');
    }else{
      list = myMap;
    }
    return Future.value(true);
    notifyListeners();
  }
  Future putData(datas) async{
    await box?.clear();
    for(var d in datas){
      box?.add(d);
    }
    notifyListeners();
  }
  Future deleteBox(int index )async{
    await box?.deleteAt(index);
    notifyListeners();
  }
 updateUser(int index , String title)async{
     var update =box!.putAt(index, title) ;
    putData(title);
    print(update);
}
}
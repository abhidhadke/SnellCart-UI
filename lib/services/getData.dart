import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class getApi{

  late String name;
  late String profession;
  late int id;
  late String number;
  late List apiData;
  String api = 'https://638f2ee34ddca317d7f0c59e.mockapi.io/snellcart';


  Future<dynamic> getData() async {
    try{
      var Url = Uri.parse(api);
      var urlRes = await http.get(Url);
      apiData = jsonDecode(urlRes.body);
      //debugPrint('$urlRes');
    }
    catch(e){
      debugPrint('$e');
      getData();
    }
  }

}
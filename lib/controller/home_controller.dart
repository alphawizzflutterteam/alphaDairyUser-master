// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/home_info.dart';
import 'package:milkman/model/notification_info.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/screen/onbording_screen.dart';

class HomePageController extends GetxController implements GetxService {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNotificationData();
  }
  HomeInfo? homeInfo;
  bool isLoading = false;

  List<String> bannerList = [];
  bool? isSelected = true;


  String isback = "1";

  HomePageController() {
    getHomeDataApi();
  }

updateSelectvalue(value){
  isSelected=value;
  update();
}

  getHomeDataApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat.toString(),
        "longs": long.toString(),
      };
      Uri uri = Uri.parse(Config.path + Config.homeDataApi);
      print(uri);
      print(map);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        getNotificationData();
        var result = jsonDecode(response.body);
        debugPrint(result.toString());
        bannerList = [];
        for (var element in result["HomeData"]["Banlist"]) {
          bannerList.add(Config.imageUrl + element["img"]);
        }
        currency = result["HomeData"]["currency"];
        wallat1 = result["HomeData"]["wallet"];
        homeInfo = HomeInfo.fromJson(result);
        update();
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  NotificationInfo? notificationInfo;

 Future<void> getNotificationData() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      print("notification isisis  ${map} ${Uri}");
      Uri uri = Uri.parse(Config.path + Config.notification);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("notification ${response.body}");
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        notificationInfo = NotificationInfo.fromJson(result);
        updateSelectvalue(notificationInfo?.notificationData.first.isRead=="0"?false:true);
        print("notification inewwwwwsisis  ${notificationInfo?.notificationData.first.isRead} ${Uri}");


      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'dart:convert';

import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../entity/location_model.dart';
import '../entity/order_model.dart';
import '../entity/orderItem_model.dart';
import '../entity/restaurant_model.dart';
import '../entity/food_model.dart';
import '../screens/locationpicker_screen.dart';
import 'package:http/http.dart' as http;

import '../services/websocket_service.dart';
import '../ultilities/Constant.dart';

class OrderProcessingController extends GetxController {
  RxBool hasOrder = false.obs;
  RxBool isDelivering = false.obs;

  RxDouble lngStart = 108.23588990000007.obs;
  RxDouble latStart = 16.082184875000053.obs;
  RxDouble lngEnd = 108.212765.obs;
  RxDouble latEnd = 16.0559417.obs;

  RxString orderStatus = 'Pending'.obs;
  RxDouble orderStatusValue = 0.0.obs;


  RxString storeName = ''.obs;
  RxString storeAddress = ''.obs;
  RxString storeImageUrl = '/image/upload/v1733846519/restaurant.png'.obs;


  RxString driverName = ''.obs;
  RxString driverPhone = ''.obs;
  RxString driverImageUrl = '/image/upload/v1733846519/driver.png'.obs;


  void updateOrderStatus(String status) {
    orderStatus.value = status;
    switch (status) {
      case 'Preparing':
        orderStatusValue.value = 0.2;
        break;
      case 'Delivering':
        orderStatusValue.value = 0.7;
        break;
      case 'Delivered':
        orderStatusValue.value = 1.0;
        break;
      default:
        orderStatusValue.value = 0.0;
    }
  }


  void updateStoreInfo(String name, String address, String imageUrl) {
    storeName.value = name;
    storeAddress.value = address;
    storeImageUrl.value = imageUrl;
  }


  void updateDriverInfo(String name, String phone, String imageUrl) {
    driverName.value = name;
    driverPhone.value = phone;
    driverImageUrl.value = imageUrl;
  }


  void resetData(){
    isDelivering.value = false;
    hasOrder.value = false;
    orderStatus.value = 'Pending';
    orderStatusValue.value = 0.0;

    storeName.value = '';
    storeAddress.value = '';
    storeImageUrl.value = '/image/upload/v1733846519/restaurant.png';

    driverName.value = '';
    driverPhone.value = '';
    driverImageUrl.value = '/image/upload/v1733846519/driver.png';
  }
}

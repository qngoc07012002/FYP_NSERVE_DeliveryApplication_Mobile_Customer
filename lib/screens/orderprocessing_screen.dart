import 'dart:convert';
import 'package:deliveryapplication_mobile_customer/controller/orderprocessing_controller.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../ultilities/Constant.dart';

class OrderProcessingPage extends StatefulWidget {
  const OrderProcessingPage({super.key});

  @override
  State<OrderProcessingPage> createState() => _OrderProcessingPageState();
}

class _OrderProcessingPageState extends State<OrderProcessingPage> {
  String API_KEY = "PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4";
  OrderProcessingController orderProcessingController = Get.find();
  late MapboxMap mapboxMap;

  PolylinePoints polylinePoints = PolylinePoints();
  String duration = "";
  String distance = "";
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
    // Thêm mã khởi tạo Mapbox ở đây nếu cần
  }
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  await _fetchData();
  }


  Future<void> _fetchData() async {
    print(orderProcessingController.latStart.value);
    print(orderProcessingController.lngStart.value);
    print(orderProcessingController.latEnd.value);
    print(orderProcessingController.lngEnd.value);

    if (orderProcessingController.latStart.value != null &&
        orderProcessingController.lngStart.value != null &&
        orderProcessingController.latEnd.value != null &&
        orderProcessingController.lngEnd.value != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=${orderProcessingController.latStart.value},${orderProcessingController.lngStart.value}&destination=${orderProcessingController.latEnd.value},${orderProcessingController.lngEnd.value}&vehicle=bike&api_key=PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4Z64I1d');

      mapboxMap?.setBounds(CameraBoundsOptions(
        bounds: CoordinateBounds(
          southwest: Point(
              coordinates: Position(
                108.23588990000007 + 0.01,
                16.082184875000053  + 0.01,
              )
          ).toJson(),
          northeast: Point(
              coordinates: Position(
                108.212765 - 0.01,
                16.0559417  - 0.01,
              )
          ).toJson(),
          infiniteBounds: false,
        ),
      ));


      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];
      duration = jsonResponse['routes'][0]['legs'][0]['duration']['text'];
      distance = jsonResponse['routes'][0]['legs'][0]['distance']['text'];
      List<PointLatLng> result = polylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
      result.map((point) => [point.longitude, point.latitude]).toList();

      String geojson = '''{
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {
            "name": "Crema to Council Crest"
          },
          "geometry": {
            "type": "LineString",
            "coordinates": $coordinates
          }
        }
      ]
    }''';

      await mapboxMap?.style
          .addSource(GeoJsonSource(id: "line", data: geojson));
      var lineLayerJson = """{
     "type":"line",
     "id":"line_layer",
     "source":"line",
     "paint":{
     "line-join":"round",
     "line-cap":"round",
     "line-color":"rgb(57, 197, 200)",
     "line-width":3.0
     }
     }""";

      await mapboxMap?.style.addPersistentStyleLayer(lineLayerJson, null);
    }
    setState(() {
      isHidden = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions:
              ResourceOptions(accessToken: "pk.eyJ1IjoicW5nb2MwNzAxMjAwMiIsImEiOiJjbTE0MDkwbWkxZ3IwMnZxMjB2ejBkaGZnIn0.cuJH5sW_W10ZWlQpIb67dw"),
              cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(108.23588990000007, 16.082184875000053))
                      .toJson(),
                  zoom: 15.0),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),),
            Positioned(
              top: 40, // Khoảng cách từ trên
              left: 16, // Khoảng cách từ trái
              child: GestureDetector(
                onTap: () {
                  Get.offAll(HomePage());
                },
                child: Container(
                  width: 48, // Độ rộng nút
                  height: 48, // Độ cao nút
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền trắng
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2), // Đổ bóng nhẹ
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF39c5c8), // Màu icon xanh
                    size: 24,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() => Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh tiến trình trạng thái đơn hàng
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preparing',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: orderProcessingController.orderStatus.value == 'Preparing'
                                  ? const Color(0xFF39c5c8)
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            'Delivering',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: orderProcessingController.orderStatus.value == 'Delivering'
                                  ? const Color(0xFF39c5c8)
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            'Delivered',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: orderProcessingController.orderStatus.value == 'Delivered'
                                  ? const Color(0xFF39c5c8)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: orderProcessingController.orderStatusValue.value,
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFF39c5c8),
                        minHeight: 4,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Thông tin cửa hàng
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(Constant.BACKEND_URL + orderProcessingController.storeImageUrl.value),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: orderProcessingController.storeName.value.isEmpty
                            ? Row(
                          children: [
                            CircularProgressIndicator(
                              color: const Color(0xFF39c5c8),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Waiting for restaurant acceptance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderProcessingController.storeName.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Address: ${orderProcessingController.storeAddress.value}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Divider(thickness: 1, color: Colors.grey[300]),

                  // Thông tin tài xế
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage:  NetworkImage(Constant.BACKEND_URL + orderProcessingController.driverImageUrl.value),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: orderProcessingController.driverName.value.isEmpty
                            ? Row(
                          children: [
                            CircularProgressIndicator(
                              color: const Color(0xFF39c5c8),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Finding Driver',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderProcessingController.driverName.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Phone Number: ${orderProcessingController.driverPhone.value}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF39c5c8),
                  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Get.offAll(HomePage());
                  //   },
                  //   child: const Text(
                  //     'Complete Order',
                  //     style: TextStyle(color: Colors.white, fontSize: 18.0),
                  //   ),
                  // ),
                ],
              ),
            )),
          ),


        ],
      ),
    );
  }
}

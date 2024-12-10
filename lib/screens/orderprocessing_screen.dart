import 'dart:async';
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
import 'package:flutter/services.dart';
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
  CircleAnnotationManager? _circleAnnotationManagerStart;
  PointAnnotationManager? pointAnnotationManager;
  PointAnnotationManager? restaurantPoint;
  PointAnnotationManager? userPoint;
  Timer? driverLocationTimer;

  @override
  void initState() {
    super.initState();

  }
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =await mapboxMap.annotations.createPointAnnotationManager();
    restaurantPoint = await mapboxMap.annotations.createPointAnnotationManager();
    userPoint = await mapboxMap.annotations.createPointAnnotationManager();
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
                orderProcessingController.lngStart.value + 0.01,
                orderProcessingController.latStart.value  + 0.01,
              )
          ).toJson(),
          northeast: Point(
              coordinates: Position(
                orderProcessingController.lngEnd.value - 0.01,
                orderProcessingController.latEnd.value  - 0.01,
              )
          ).toJson(),
          infiniteBounds: true,
        ),
          maxZoom: 13,
          minZoom: 0,
          maxPitch: 10,
          minPitch: 0
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


     // if (orderProcessingController.isDelivering.value){
     //   try {
     //     await mapboxMap?.style?.removeStyleLayer("line_layer");
     //     print("remove line_layer successfully");
     //   } catch (e) {
     //     print("Layer 'line_layer' not found, ignoring: $e");
     //   }
     //   try {
     //     await mapboxMap?.style?.removeStyleLayer("line");
     //     print("remove source line successfully");
     //   } catch (e) {
     //     print("Source 'line' not found, ignoring: $e");
     //   }
     // }

      await mapboxMap?.style.addSource(GeoJsonSource(id: "line", data: geojson));



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

      if (orderProcessingController.orderStatus == "Pending") {
        // Load the image from assets
        ByteData bytes = await rootBundle.load('assets/icons/restaurant_icon.png');
        Uint8List imageData = bytes.buffer.asUint8List();

        // Create a PointAnnotationOptions
        PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
                  orderProcessingController.lngStart.value,
                  orderProcessingController.latStart.value,
                )).toJson(),
            image: imageData,
            iconSize: 0.3
        );

        restaurantPoint?.create(pointAnnotationOptions);

        // Load the image from assets
        bytes = await rootBundle.load('assets/icons/customerLocation_icon.png');
        imageData = bytes.buffer.asUint8List();

        // Create a PointAnnotationOptions
        pointAnnotationOptions = PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
                  orderProcessingController.lngEnd.value,
                  orderProcessingController.latEnd.value,
                )).toJson(),
            image: imageData,
            iconSize: 0.2
        );

        userPoint?.create(pointAnnotationOptions);
      }
    }


    setState(() {
      isHidden = false;
    });
  }


  Future<void> _fetchDriverLocation() async {
      // print("FETCH DRIVER LOCATION");
      //
      // _circleAnnotationManagerStart?.deleteAll();
      // _circleAnnotationManagerStart?.create(CircleAnnotationOptions(
      //   geometry: Point(
      //       coordinates: Position(
      //         orderProcessingController.lngStart.value,
      //         orderProcessingController.latStart.value,
      //       )).toJson(),
      //   circleColor: Colors.blue.value,
      //   circleRadius: 5,
      // ),);
      await mapboxMap?.style.removeStyleLayer("line_layer");
      await mapboxMap?.style.removeStyleSource("line");
      _fetchData();
      pointAnnotationManager?.deleteAll();

          // Load the image from assets
      final ByteData bytes = await rootBundle.load('assets/icons/nserve_icon.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      // Create a PointAnnotationOptions
      PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
          geometry: Point(
              coordinates: Position(
                orderProcessingController.lngStart.value,
                orderProcessingController.latStart.value,
              )).toJson(),
          image: imageData,
          iconSize: 0.2
      );

      pointAnnotationManager?.create(pointAnnotationOptions);

      mapboxMap.setCamera(CameraOptions(
          center: Point(coordinates: Position(orderProcessingController.lngStart.value, orderProcessingController.latStart.value))
              .toJson(),
          zoom: 15.0),);

      // mapboxMap?.annotations
      //     .createCircleAnnotationManager()
      //     .then((value) async {
      //     _circleAnnotationManagerStart = value;
      // });




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
                  center: Point(coordinates: Position(108.2231526, 16.0678931))
                      .toJson(),
                  zoom: 15.0),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),),
            Positioned(
              top: 40,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Get.offAll(HomePage());
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF39c5c8),
                    size: 24,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              print("1");
              //_fetchData();


              if (orderProcessingController.orderStatus.value == 'Delivering'){
                print("delivering");
                restaurantPoint?.deleteAll();
                driverLocationTimer?.cancel();
                driverLocationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
                  await _fetchDriverLocation();
                });
              }

              if (orderProcessingController.orderStatus.value == "Delivered"){
                driverLocationTimer?.cancel();
              }

              return Container(
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


                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(Constant.IMG_URL + orderProcessingController.storeImageUrl.value),
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
                          backgroundImage:  NetworkImage(Constant.IMG_URL + orderProcessingController.driverImageUrl.value),
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
              );
            }),
          ),


        ],
      ),
    );
  }
}

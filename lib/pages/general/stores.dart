import 'dart:convert';
import 'dart:math';

import 'package:get/utils.dart';
import 'package:meqamax/classes/connection.dart';
import 'package:meqamax/themes/theme.dart';
import 'package:meqamax/widgets/appbar.dart';
import 'package:meqamax/widgets/behaviour.dart';
import 'package:meqamax/widgets/container.dart';
import 'package:meqamax/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List data = [];
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? currentLocation;
  Location location = Location();

  get() async {
    if (await checkConnectivity()) {
      var url = Uri.parse('${App.domain}/api/page.php?action=get&id=3&lang=${Get.locale?.languageCode}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (mounted) {
          setState(() {
            loading = false;
            if (result['status'] == 'success') {
              data = result['result']['stores'];
            }
          });
        }
      } else {
        setState(() {
          loading = false;
          serverError = true;
        });
      }
    } else {
      setState(() {
        loading = false;
        connectError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _addMarkers();
      _getCurrentLocation();
    });
  }

  void _addMarkers() {
    if (data.isNotEmpty) {
      for (var store in data) {
        markers.add(
          Marker(
            markerId: MarkerId(store['s_name']),
            position: LatLng(double.parse(store['s_lat']), double.parse(store['s_lng'])),
            infoWindow: InfoWindow(title: store['s_name'], snippet: store['s_address']),
          ),
        );
      }

      double minLat = markers.first.position.latitude;
      double maxLat = markers.first.position.latitude;
      double minLong = markers.first.position.longitude;
      double maxLong = markers.first.position.longitude;

      for (Marker marker in markers) {
        double lat = marker.position.latitude;
        double long = marker.position.longitude;

        minLat = min(minLat, lat);
        maxLat = max(maxLat, lat);
        minLong = min(minLong, long);
        maxLong = max(maxLong, long);
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLong),
        northeast: LatLng(maxLat, maxLong),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
    }
  }

  void _getCurrentLocation() async {
    var currentLocation = await location.getLocation();
    if (mounted) {
      setState(() {
        this.currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: 'Mağazalarımız'.tr),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: null,
        child: (data.isEmpty)
            ? MsIndicator()
            : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(40.37767, 49.89201),
                        zoom: 10,
                      ),
                      markers: markers,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                    ),
                  ),
                  ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SizedBox(
                      height: 220.0,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(15.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              mapController?.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  markers.elementAt(index).position,
                                  15.0,
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 2 / 5,
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryBg,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index]['s_name'],
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    data[index]['s_address'],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryColor,
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Text(
                                        'Xəritədə bax'.tr,
                                        style: TextStyle(color: Theme.of(context).colorScheme.oppotext, fontSize: 11.0, height: 1.3),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 15.0);
                        },
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

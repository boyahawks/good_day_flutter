// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_day/screen/motoris/Detail_kedai.dart';
import 'package:good_day/screen/motoris/Laporan.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Kunjungan extends StatefulWidget {
  @override
  State<Kunjungan> createState() => _KunjunganinState();

  var kedai;
  Kunjungan(this.kedai);
}

class _KunjunganinState extends State<Kunjungan> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _KunjunganinState createState() => _KunjunganinState();

  GoogleMapController? mapController;
  // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  double _originLatitude = 26.48424, _originLongitude = 50.04551;
  double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDqFzoYLjBuFd9LLz4Colr8vOBU8kQNW48";

  // GoogleMapController mapController;

  // BitmapDescriptor? iconMotoris;

  // var initialCameraPosition;
  // var latKedai;
  // var langKedai;
  // var latMotoris;
  // var langMotoris;
  // Marker? origin;
  // Marker? destination;

  @override
  void initState() {
    // getDetailKedai();
    // getPosisition();
    // getIcons();
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    super.initState();
  }

  @override
  void dispose() {
    // googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/gambar/background-mobile.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: logo(),
              ),
              Expanded(
                flex: 65,
                child: viewKunjungan(),
              ),
              Expanded(
                flex: 15,
                child: gambarSaset(),
              )
            ],
          ),
        )
      ],
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getPosisition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      // latMotoris = position.latitude;
      // langMotoris = position.longitude;
      // print(latMotoris);
      // print(langMotoris);
      // initialCameraPosition =
      //     CameraPosition(target: LatLng(latMotoris, langMotoris), zoom: 12);
      // getAcuracy = position.accuracy;
      // getLatitude = position.latitude;
      // getLongitude = position.longitude;
      // kotaPengguna = place.subAdministrativeArea;
      // provinsiPengguna = place.administrativeArea;
      // lokasiPengguna = '$kotaPengguna , $provinsiPengguna';
    });
    // await initialCameraPosition(CameraUpdate.newCameraPosition(
    //     CameraPosition(target: LatLng(latMotoris, langMotoris), zoom: 15)));
  }

  getDetailKedai() async {
    print(widget.kedai);
    try {
      var formData = dio.FormData.fromMap({'id_kedai': widget.kedai});
      var response = await dio.Dio().post(
        Api.detailKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          // latKedai = int.parse(data[0]['lat']);
          // langKedai = int.parse(data[0]['lang']);
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
    }
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.2), "assets/gambar/icon1.png");
    setState(() {
      // ignore: unnecessary_this
      // this.iconMotoris = icon;
    });
  }

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget viewMaps() {
    return SizedBox(
      height: 440,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          // GoogleMap(
          //   myLocationButtonEnabled: false,
          //   zoomControlsEnabled: true,
          //   initialCameraPosition: initialCameraPosition,
          //   onMapCreated: (controller) => googleMapController = controller,
          //   markers: {
          //     if (origin != null) origin!,
          //     if (destination != null) destination!
          //   },
          //   onLongPress: addMarker,
          // ),
          // FloatingActionButton(
          //   backgroundColor: Colors.white,
          //   foregroundColor: Colors.black,
          //   onPressed: () {
          //     setState(() {
          //       getPosisition();
          //       googleMapController!.animateCamera(
          //           CameraUpdate.newCameraPosition(initialCameraPosition));
          //     });
          //   },
          //   child: const Icon(Icons.center_focus_strong),
          // )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  Widget buttonLaporan() {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            print("ke halaman laporan");
            var idKedai = widget.kedai;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Laporan(idKedai)),
            );
          });
        },
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Laporan",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // void addMarker(LatLng pos) {
  //   if (origin == null || (origin != null && destination != null)) {
  //     setState(() {
  //       origin = Marker(
  //           markerId: const MarkerId('origin'),
  //           infoWindow: InfoWindow(
  //               title: 'Motoris',
  //               onTap: () {
  //                 SizedBox(
  //                   width: 80,
  //                   height: 80,
  //                   child: Text("Motoris Uye"),
  //                 );
  //               }),
  //           icon: iconMotoris!,
  //           position: pos);
  //       destination = null;
  //     });
  //   } else {
  //     setState(() {
  //       origin = Marker(
  //           markerId: const MarkerId('destination'),
  //           infoWindow: InfoWindow(
  //               title: 'Kedai',
  //               onTap: () {
  //                 SizedBox(
  //                   width: 80,
  //                   height: 80,
  //                   child: Text("Kedai Uye"),
  //                 );
  //               }),
  //           icon: iconMotoris!,
  //           position: pos);
  //     });
  //   }
  // }

  Widget viewKunjungan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded(
        //   flex: 90,
        //   child: viewMaps(),
        // ),
        Expanded(
          flex: 90,
          child: redirectMaps(),
        ),
        Expanded(
          flex: 10,
          child: buttonLaporan(),
        ),
      ],
    );
  }

  Widget redirectMaps() {
    return Center(
      child: Container(
        width: 200,
      ),
    );
  }

  Widget logo() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
      ),
    );
  }

  Widget gambarSaset() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_saset_web.png"),
      ),
    );
  }
}

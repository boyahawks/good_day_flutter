// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/motoris/Kedai.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class Rayon extends StatefulWidget {
  @override
  State<Rayon> createState() => _RayoninState();

  var value;
  Rayon(this.value);
}

class _RayoninState extends State<Rayon> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _RayoninState createState() => _RayoninState();

  var allRayon = [];

  @override
  void initState() {
    getAllRayon();
    super.initState();
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
          child: allRayon.isEmpty
              ? Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 300),
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      flex: 20,
                      child: logo(),
                    ),
                    Expanded(
                      flex: 65,
                      child: viewRayon(),
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
  getAllRayon() async {
    try {
      var formData = dio.FormData.fromMap({
        'id_cluster': widget.value,
      });
      var response = await dio.Dio().post(
        Api.allRayon,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          allRayon = data;
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

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET
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

  Widget viewRayon() {
    return SizedBox(
        height: 400,
        child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(allRayon.length, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    var idCluster = allRayon[index]['id_cluster'];
                    var idRayon = allRayon[index]['id_rayon'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Kedai(idCluster, idRayon)),
                    );
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 50, top: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          allRayon[index]['nama_rayon'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              );
            }))
        // GridView.builder(
        //     shrinkWrap: true,
        //     physics: ScrollPhysics(),
        //     itemCount: allRayon.length,
        //     scrollDirection:
        //         allRayon.length - 1 > 7 ? Axis.horizontal : Axis.vertical,
        //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: allRayon.length - 1 > 7 ? 100 : 200,
        //         childAspectRatio: allRayon.length - 1 > 7 ? 1 / 2 : 5 / 2,
        //         crossAxisSpacing: 10,
        //         mainAxisSpacing: 20),
        //     itemBuilder: (context, index) {
        //       return Container(
        //         margin: const EdgeInsets.only(left: 20, right: 20),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             InkWell(
        //               onTap: () {
        //                 setState(() {
        //                   var idCluster = allRayon[index]['id_cluster'];
        //                   var idRayon = allRayon[index]['id_rayon'];
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => Kedai(idCluster, idRayon)),
        //                   );
        //                 });
        //               },
        //               child: Container(
        //                 alignment: Alignment.center,
        //                 decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.only(
        //                       topLeft: Radius.circular(15),
        //                       topRight: Radius.circular(15),
        //                       bottomLeft: Radius.circular(15),
        //                       bottomRight: Radius.circular(15)),
        //                 ),
        //                 child: Container(
        //                   margin: const EdgeInsets.all(10),
        //                   child: Text(
        //                     allRayon[index]['nama_rayon'],
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       );
        //     }),
        );
  }
}

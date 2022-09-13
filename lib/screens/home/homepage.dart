import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textile/constants/app_constants.dart';
import 'package:textile/models/home_page_model.dart';
import 'package:textile/screens/Gallary/gallary_category.dart';
import 'package:textile/screens/home/Orders.dart';
import 'package:textile/screens/notes.dart';
import 'package:textile/screens/payment_detail_page/All_firms.dart';
import 'package:textile/screens/widgets/webview.dart';
import 'package:textile/utils/palette.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

import 'AllCustomersOrders.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.mobile}) : super(key: key);
  final String? mobile;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




  final List<HomePageModel> _CardData = <HomePageModel>[];

  Future<bool> _onBackPress() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Do you want to exit the application'),
              actions: [
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    kSharedPreferences.clear();
                    Navigator.pop(context, true);
                    FocusScope.of(context).unfocus();
                  },
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context, false);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ));
  }

  Future<List<HomePageModel>> _fetchHomePageData() async {
    final response = await http.get(Uri.parse("https://www.textileutsav.com/machine/api/get-home-cards"));
    _CardData.clear();
    try {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          jsonData['data'].forEach((v) {
            _CardData.add(HomePageModel.fromJson(v));
          });
        }
      }
    } on SocketException {
      Fluttertoast.showToast(msg: 'No Internet Connection');
    }
    return _CardData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomePageModel>>(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: _onBackPress,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
              ),
              drawer: const DrawerWidget(),
              body: kUserdata?.type == "finance" ?  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 10,
                  shadowColor: Palette.primaryColor.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const AllFirms()));
                    },title: const Text('Payment'),),
                ),
              ) : GridView.builder(
                  itemCount: _CardData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 3
                          : 2,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.w,
                      childAspectRatio: (2 / 1.3)),
                  itemBuilder: (context, index) {
                    var item = _CardData[index];
                    return Card(
                        shadowColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.w),
                          onTap: () {
                            if(kUserdata?.type == 'worker' || kUserdata?.type == 'dispatcher')
                              {
                                if(item.value == 'payment')
                                {
                                  Fluttertoast.showToast(msg: 'You Are Not Allowed');
                                  return;
                                }
                              }
                            if(item.type == 'web')
                              {
                                Navigator.push(context, CupertinoPageRoute(builder: (_) => MoreWebview(title: item.title, url: item.value!)));
                              }
                            else if(item.type == 'custom'){
                              if(item.value == 'payment')
                                {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const AllFirms()));
                                }
                              if(item.value == 'order' )
                                {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const Orders()));
                                }
                              if(item.value == 'all_notes')
                                {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const NotesPage()));
                                }
                              if(item.value == 'all_designs')
                                {
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const GalleryCategoryPage()));
                                }
                              if(item.value == 'customer_order')
                              {
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => const AllCustomers()));
                              }
                              if(item.value == 'changepassword')
                              {
                                Fluttertoast.showToast(msg: 'Update shortly');
                              }
                            }
                            },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: FadeInImage.assetNetwork(
                                    height: 100,
                                    width: 100,
                                    placeholder: 'assets/images/adminicon.png',
                                    image: item.image != null ?  'https://www.textileutsav.com/machine/${item.image}' : 'https://www.textileutsav.com/machine/assets/cards/images/20220617153121.png',
                              ),
                              ),
                              Text(item.title.toString()),
                            ],
                          ),
                        ));
                  }),
            ),
          );
        } else {
          return const Center(
            child: AppProgressIndicator(color: Colors.red,),
          );
        }
      },
      future: _fetchHomePageData(),
    );
  }

  /*Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();hh
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Utils.showToast('Press again to exit');
      return Future.value(false);
    }
    Navigate.close();
    return Future.value(false);
  }*/
}

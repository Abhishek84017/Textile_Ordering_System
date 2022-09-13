import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textile/config/router/router.dart';
import 'package:textile/models/customers_model.dart';
import 'package:textile/models/models.dart';
import 'package:textile/screens/order_detail_page/customer_order_detail_page.dart';
import 'package:textile/screens/widgets/circular_progress_indicator.dart';
import 'package:textile/screens/widgets/drawer.dart';
import 'package:textile/utils/palette.dart';
import 'package:textile/utils/services/rest_api.dart';
import 'package:textile/utils/extensions/string_extension.dart';
import 'package:http/http.dart' as http;
import '../widgets/input.dart';


class AllCustomers extends StatefulWidget {
  const AllCustomers({Key? key}) : super(key: key);

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {

  List<CustomersModel> customerData = <CustomersModel>[];
  List<CustomersModel> searchCustomerData = <CustomersModel>[];

  final TextEditingController _controller = TextEditingController();

  Future<List<CustomersModel>> _fetchAllCustomerData() async {
    final response = await http.get(Uri.parse("https://www.textileutsav.com/machine/api/get-all-customers"));
    try {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          jsonData.forEach((v) {
            customerData.add(CustomersModel.fromJson(v));
          });
        }
        setState((){});
      }
    } on SocketException {
      Fluttertoast.showToast(msg: 'No Internet Connection');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    searchCustomerData = customerData;
    return customerData;
  }





  void filterFunction(String code)
  {
    print(code);
    setState((){
      searchCustomerData = customerData.where((element) => element.name!.toLowerCase().contains(code.toLowerCase())).toList();
    });
  }


  @override
  void initState()
  {
    _fetchAllCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.notifications_none_outlined),
          )
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Input(
            controller: _controller,
            hintText: 'Enter Customer Code',
            onChange:(value) => filterFunction(_controller.text),
          ),
          Expanded(
            child:
               ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    separatorBuilder: (_, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final customer = searchCustomerData[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        elevation: 10,
                        shadowColor: Palette.primaryColor.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          onTap: () => Navigate.to(AllCustomersOrderList(customerId: customer.id!,)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          title: Text("${customer.name}".toStudlyCase(), style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${customer.companyName}",
                            style: TextStyle(
                              color: Palette.primaryColor.shade300,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: searchCustomerData.length,
                  )
          ),
        ],
      ),
    );
  }
}


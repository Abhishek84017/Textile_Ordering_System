import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:textile/config/router/router.dart';
import 'package:textile/models/customersorderslist_model.dart';
import 'package:textile/models/models.dart';
import 'package:textile/screens/widgets/circular_progress_indicator.dart';
import 'package:textile/screens/widgets/drawer.dart';
import 'package:textile/utils/palette.dart';
import 'package:textile/utils/services/rest_api.dart';
import 'package:textile/utils/extensions/string_extension.dart';

import 'order_detail_page.dart';


class AllCustomersOrderList extends StatefulWidget {

  final int customerId;
  const AllCustomersOrderList({Key? key,required this.customerId}) : super(key: key);

  @override
  State<AllCustomersOrderList> createState() => _AllCustomersOrderListState();
}

class _AllCustomersOrderListState extends State<AllCustomersOrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Orders"),
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
      body: FutureBuilder<Data<List<CustomersOrdersListModel>>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppProgressIndicator(color: Palette.primaryColor);
          }
          if (snapshot.hasData &&
              snapshot.data!.statusCode == 200 &&
              snapshot.data!.data!.isNotEmpty) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              separatorBuilder: (_, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final customerOrderList = snapshot.data!.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  elevation: 10,
                  shadowColor: Palette.primaryColor.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order No.: ${customerOrderList.orderNumber}",
                          style: TextStyle(
                            color: Palette.primaryColor.shade700,
                          ),
                        ),
                        Text("${customerOrderList.status}".toStudlyCase(), style: TextStyle(fontSize: 12.sp, color: customerOrderList.status == 'pending' ? Colors.yellow : customerOrderList.status == 'running' ? Colors.orange : customerOrderList.status == 'hold' ? Colors.red : customerOrderList.status == 'completed' ? Colors.green : Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Last updated: ${DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.tryParse("${customerOrderList.modified}") ?? DateTime.now())}",
                      style: TextStyle(
                        color: Palette.primaryColor.shade300,
                      ),
                    ),
                    onTap: (){
                      var orderM = new OrderModel();
                      orderM.id = customerOrderList.id;
                      Navigate.to(OrderDetailPage(order:orderM));
                    },
                  ),
                );
              },
              itemCount: snapshot.data!.data!.length,
            );
          } else {
            return const Center(
              child: Text("Data not found"),
            );
          }
        },
        future: Services.getAllCustomersOrderList(widget.customerId),
      ),
    );
  }
}


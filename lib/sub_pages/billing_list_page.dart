import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/pending_bill_page.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/no_internet.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'approved_bill_page.dart';

class BillingList extends StatefulWidget {
  @override
  _BillingListState createState() => _BillingListState();
}

class _BillingListState extends State<BillingList>
    with SingleTickerProviderStateMixin {

  TabController _controller;
  int _counter=0;

  _customInit(PublicProvider pProvider)async{
    setState(()=>_counter++);
    showLoadingDialog('অপেক্ষা করুন...');
    await pProvider.checkConnectivity();
    await pProvider.getBillingInfo().then((value){
        closeLoadingDialog();
    },onError: (error){
      closeLoadingDialog();
      showErrorMgs(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(_counter==0) _customInit(pProvider);
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('বিলের তথ্য'),
        bottom: new TabBar(controller: _controller, tabs: [
          Tab(text: "অনুমোদিত"),
          Tab(text: "বিচারাধীন"),
        ]),
      ),
      body:pProvider.internetConnected==true? TabBarView(
        controller: _controller,
        children: <Widget>[
          ApprovedBill(),
          PendingBill(),
        ],
      ):NoInternet(),
    );
  }
}

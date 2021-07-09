import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/billing_info_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ApprovedBill extends StatefulWidget {
  @override
  _ApprovedBillState createState() => _ApprovedBillState();
}

class _ApprovedBillState extends State<ApprovedBill> {
  @override
  Widget build(BuildContext context) {
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: AnimationLimiter(
        child: RefreshIndicator(
          backgroundColor: CustomColors.whiteColor,
          onRefresh: () async {await pProvider.getBillingInfo();},
          child: ListView.builder(
            itemCount: pProvider.approvedBillList.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                        horizontalOffset: 400,
                        child: FadeInAnimation(
                          child: BillingInfoTile(index: index,billingInfoList: pProvider.approvedBillList),
                        ))),
          ),
        ),
      ),
    );
  }
}

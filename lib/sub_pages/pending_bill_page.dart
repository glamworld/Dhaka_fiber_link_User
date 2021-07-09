import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/billing_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class PendingBill extends StatefulWidget {
  @override
  _PendingBillState createState() => _PendingBillState();
}

class _PendingBillState extends State<PendingBill> {
  @override
  Widget build(BuildContext context) {
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: AnimationLimiter(
        child: RefreshIndicator(
          backgroundColor: CustomColors.whiteColor,
          onRefresh: () async {await pProvider.getBillingInfo();},
          child: ListView.builder(
            itemCount: pProvider.pendingBillList.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                        horizontalOffset: 400,
                        child: FadeInAnimation(
                          child: BillingInfoTile(index: index,billingInfoList: pProvider.pendingBillList),
                        ))),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/app_bar.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/contact_us_tile.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/instruction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  @override
  Widget build(BuildContext context) {
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context, "যোগাযোগ করুন"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Instruction builder
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10, top: 10),
              child: InstructionTile(pProvider.aboutUs??''),
            ),

            ContactCardTile('assets/icon/phone.png','গ্রাহক সেবা', pProvider.customerCare??''),
            ContactCardTile('assets/icon/address.png', 'অফিসের ঠিকানা', pProvider.address??''),
          ],
        ),
      ),
    );
  }

}


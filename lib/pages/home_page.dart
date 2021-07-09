import 'package:carousel_slider/carousel_slider.dart';
import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/design.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/variables.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/billing_list_page.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/contact_us_page.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/our_services_page.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/pay_bill_page.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/problem_page.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/profile_page.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/app_bar.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/home_grid_tile.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/no_internet.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/routing_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _counter=0;

  _customInit(PublicProvider pProvider)async{
    setState(()=>_counter++);
    await pProvider.checkConnectivity();
    //await pProvider.getBillingInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(_counter==0) _customInit(pProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: PublicAppBar(context, Variables.appTitle)),
      body: pProvider.internetConnected? _bodyUI(size,pProvider):NoInternet(),
    );
  }

  Widget _bodyUI(Size size,PublicProvider pProvider) {

    return Column(
      children: [
        ///Image Slider
        Container(
          height: size.width * .5,
          width: size.width,
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: Variables.imageSliders,
          ),
        ),

        ///Marque Container
        Container(
          height: size.width * .1,
          alignment: Alignment.center,
          child: MarqueeWidget(
            text:
                "২৪ ঘন্টা সার্ভিস পেতে ০১৮৮১০৩৮০০১ নাম্বারে কল করুন । ${Variables.appLongTitle} এর সাথে থাকার জন্য ধন্যবাদ ।",
            textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: size.width * .05),
            scrollAxis: Axis.horizontal,
          ),
        ),

        ///GridView
        Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: Variables.homeMenuText.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: FadeInAnimation(
                          child: InkWell(
                              borderRadius: Design.borderRadius,
                              splashColor: Theme.of(context).primaryColor,
                              onTap: () async{
                                if (index == 0)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: ProfilePage()));
                                if (index == 1)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: BillingList()));
                                if (index == 2)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: PayBill()));
                                if (index == 3)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: ProblemPage()));
                                if (index == 4)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: OurServices()));
                                if (index == 5)
                                  Navigator.push(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: ContactUs()));
                                if (index == 6){
                                  SharedPreferences pref =await SharedPreferences.getInstance();
                                  pref.clear();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      AnimationPageRoute(
                                          navigateTo: LoginPage()),
                                          (route) => false);
                                }
                              },
                              child: HomeMenuTile(index: index)),
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }
}

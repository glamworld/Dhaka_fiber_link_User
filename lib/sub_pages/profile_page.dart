import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/design.dart';
import 'package:dhaka_fiber_link_user_panel/sub_pages/update_user_info.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/no_internet.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/notifications.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/routing_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // File _image;
  int _counter=0;


  _customInit(PublicProvider pProvider)async{
    showLoadingDialog('অপেক্ষা করুন...');
    await pProvider.getUser().then((value){
      closeLoadingDialog();
    },onError: (e){
      closeLoadingDialog();
      showInfo(e.toString());
    });
  }
  _initializeData(PublicProvider pProvider){
    setState(()=> _counter++);
    pProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(pProvider.userList.isEmpty) _customInit(pProvider);
    if(_counter==0) _initializeData(pProvider);

    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width*.6),
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle:true,
          elevation: 0,

          title: Text('প্রোফাইল'),
          flexibleSpace: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: CustomColors.gradientColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: size.width*.3,
                  width: size.width*.3,
                  decoration: BoxDecoration(
                    color: CustomColors.greyWhite,
                    borderRadius: BorderRadius.all(Radius.circular(size.width*.7)),
                    image: DecorationImage(
                      image:  AssetImage('assets/profile_user.png'),
                      fit: BoxFit.cover
                    ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 3,
                        )
                      ]
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(pProvider.userList.isEmpty?'লোড হচ্ছে...':pProvider.userList[0].name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Design.titleStyle(size),),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),

      ///Body...
      body: pProvider.internetConnected? AnimationLimiter(
        child: RefreshIndicator(
          backgroundColor: CustomColors.whiteColor,
          onRefresh: ()async{await pProvider.getUser();},
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context,index)=> AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 400,
                child: FadeInAnimation(
                  child: CardBuilder(index: index,pProvider: pProvider),
                ),
              )
          ),
          ),
        ),
      ):NoInternet(),

      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, AnimationPageRoute(navigateTo: UpdateUserInfo())),
        backgroundColor: CustomColors.whiteColor,
        child: Icon(Icons.update_rounded,color: CustomColors.appThemeColor),
        tooltip: 'Update your information',
        splashColor: CustomColors.greyWhite,
      ),
    );
  }

  // Future<void> _getImageFromGallery()async{
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery,maxWidth: 300,maxHeight: 300);
  //   if(pickedFile!=null){
  //     setState(()=> _image = File(pickedFile.path));
  //   }else {
  //     showInfo('কোন ছবি নির্বাচন করা হয়নি');
  //   }
  // }
  
}

// ignore: must_be_immutable
class CardBuilder extends StatelessWidget {
  PublicProvider pProvider;
  int index;
  CardBuilder({this.index,this.pProvider});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width*.32,
      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      decoration: BoxDecoration(
        borderRadius: Design.borderRadius,
        image: DecorationImage(
          image: AssetImage('assets/gradient_image.jpg'),
          fit: BoxFit.cover
        ),
          boxShadow: [Design.cardShadow]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Image section
          Container(
            alignment: Alignment.center,
            width: size.width*.24,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white,width: 5),
              borderRadius: Design.borderRadius,
              image: DecorationImage(
                image: AssetImage(index==0?'assets/icon/id_white.png'
                    :index==1?'assets/icon/phone.png'
                    :index==2?'assets/icon/dish.png'
                    :'assets/icon/address.png'),
                fit: BoxFit.contain
              )
            ),
          ),
          Container(
            width: size.width*.63,
            //color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(index==0?'আইডি'
                    :index==1? 'মোবাইল নাম্বার'
                    :index==2? 'প্যাকেজ'
                    :'বড়ির ঠিকানা',
                  maxLines: 1,
                  style: Design.titleStyle(size),),
                SizedBox(height: size.width*.02),

                index==0?
                Text(pProvider.userList.isEmpty?'লোড হচ্ছে...':'${pProvider.userList[0].id}',
                  maxLines: 4,
                  style: Design.subTitleStyle(size),
                )
                    :index==1?
                Text(pProvider.userList.isEmpty?'লোড হচ্ছে...':pProvider.userList[0].phone,
                  maxLines: 4,
                  style: Design.subTitleStyle(size),
                )
                    :index==2?
                Text(pProvider.userList.isEmpty?'লোড হচ্ছে...':pProvider.userList[0].package,
                  maxLines: 4,
                  style: Design.subTitleStyle(size),
                )
                    :Text(pProvider.userList.isEmpty?'লোড হচ্ছে...':pProvider.userList[0].address,
                  maxLines: 4,
                  style: Design.subTitleStyle(size),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}


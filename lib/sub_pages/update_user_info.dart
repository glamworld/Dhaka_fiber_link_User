import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/design.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/variables.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/app_bar.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/buttons.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/no_internet.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserInfo extends StatefulWidget {
  @override
  _UpdateUserInfoState createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  int _counter=0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  _customInit(PublicProvider pProvider)async{
    setState(()=>_counter++);
    pProvider.checkConnectivity();
    _nameController.text = pProvider.userList[0].name??'';
    _addressController.text =pProvider.userList[0].address??'';
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

  Widget _bodyUI(Size size,PublicProvider pProvider){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10, top: 20),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: Design.formDecoration(size).copyWith(
                labelText: 'আপনার নাম'),
          ),
          SizedBox(height: size.width*.04),
          TextField(
            controller: _addressController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            maxLines: 2,
            decoration: Design.formDecoration(size).copyWith(
                labelText: 'বাড়ির ঠিকানা'),
          ),
          SizedBox(height: size.width*.04),

          InkWell(
            onTap: ()async{
              await pProvider.checkConnectivity().then((value){
                if(pProvider.internetConnected==true)_checkValidity(pProvider);
              },onError: (error)=> showErrorMgs(error.toString()));
            },
            child: smallGradientButton(context, 'পরিবর্তন করুন'),
            borderRadius: Design.buttonRadius,
            splashColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  _checkValidity(PublicProvider pProvider)async{
    if(_nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty){
      Map<String, String> dataMap = {
        'name': _nameController.text,
        'address': _addressController.text,
      };
      showLoadingDialog('অপেক্ষা করুন...');
      await pProvider.updateUser(dataMap).then((value)async{
        if(value==true){
          await pProvider.getUser();
          closeLoadingDialog();
          showSuccessMgs('তথ্য পরিবর্তন সফল হয়েছে');
          Navigator.pop(context);
        }else{
          closeLoadingDialog();
          showErrorMgs('তথ্য পরিবর্তন অসফল হয়েছে!');
        }
      },onError: (error){
        closeLoadingDialog();
        showErrorMgs(error.toString());
      });
    }else showInfo('তথ্য প্রদান করুন');
  }
}

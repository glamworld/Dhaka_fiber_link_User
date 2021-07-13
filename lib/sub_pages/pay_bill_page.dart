import 'package:dhaka_fiber_link_user_panel/providers/public_provider.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/colors.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/design.dart';
import 'package:dhaka_fiber_link_user_panel/public_variables/variables.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/app_bar.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/buttons.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/instruction_tile.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/no_internet.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayBill extends StatefulWidget {
  @override
  _PayBillState createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {
  DateTime _date;
  String _deductKey;
  String _payBy;
  List<String> _deductList = ['Vat','AIT','Others'];
  List<String> _payList = ['BKash','Rocket','Nagad'];
  TextEditingController _dateController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _transIdController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _payByController = TextEditingController();
  TextEditingController _deductController = TextEditingController();

  int _counter=0;

  _customInit(PublicProvider pProvider)async{
    setState(()=>_counter++);
    pProvider.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    final PublicProvider pProvider = Provider.of<PublicProvider>(context);
    if(_counter==0) _customInit(pProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: PublicAppBar(context, "বিল পরিশোধ করুন"),
      ),
      body: pProvider.internetConnected==true? _bodyUI(pProvider):NoInternet(),
    );
  }

  Widget _bodyUI(PublicProvider pProvider) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///Instruction builder
            InstructionTile(Variables.paymentInstruction),
            SizedBox(height: size.width * .04),

            ///Note builder
            Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: Design.borderRadius,
                  gradient: CustomColors.whiteGradientColor,
                  boxShadow: [Design.cardShadow]),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      //text: 'Hello ',
                      style: Design.warningSubTitleStyle(size)
                          .copyWith(fontSize: size.width * .035),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'বিঃ দ্রঃ: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:Variables.paymentNote),
                      ],
                    ),
                  )),
            ),
            SizedBox(height: size.width * .04),

            ///Form Section
            Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: Design.borderRadius,
                  gradient: CustomColors.whiteGradientColor,
                  boxShadow: [Design.cardShadow]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///Date picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.bottomLeft,
                            width: size.width * .1,
                            child: InkWell(
                              onTap: ()=> _pickDate(),
                              borderRadius: Design.buttonRadius,
                              splashColor: Theme.of(context).primaryColor,
                              child: Icon(Icons.calendar_today_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: size.width * .075),
                            ),
                        ),
                        Container(
                          width: size.width * .78,
                          child: _textField('তারিখ', size),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * .04),

                    Container(
                      height: 45,
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          isExpanded: true,
                          value:_payBy,
                          hint: Text('বিল পরিশোধের মাধ্যম নির্বাচন করুন',style: TextStyle(
                            //color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: size.height*.022,)),
                          items:_payList.map((category){
                            return DropdownMenuItem(
                              child: Text(category, style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: size.height * .022,fontFamily: 'OpenSans'
                              ),
                              ),
                              value: category,
                            );
                          }).toList(),
                          onChanged: (newVal){
                            setState(() {
                              _payBy = newVal as String;
                              _payByController.text=_payBy;
                            });
                          },

                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                    Divider(height: 0,thickness: 1,color: CustomColors.liteGrey2),
                    SizedBox(height: size.width * .03),
                    Container(
                      height: 45,
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: size.height*.01),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isDense: true,
                          isExpanded: true,
                          value:_deductKey,
                          hint: Text('বিল পরিশোধের ধরন নির্বাচন করুন',style: TextStyle(
                            //color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: size.height*.022,)),
                          items:_deductList.map((category){
                            return DropdownMenuItem(
                              child: Text(category, style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: size.height * .022,fontFamily: 'OpenSans'
                              ),
                              ),
                              value: category,
                            );
                          }).toList(),
                          onChanged: (newVal){
                            setState(() {
                              _deductKey = newVal as String;
                              _deductController.text=_deductKey;
                            });
                          },

                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                    Divider(height: 0,thickness: 1,color: CustomColors.liteGrey2),
                    SizedBox(height: size.width * .03),

                    _textField('মোবাইল নাম্বার (ইংরেজি)', size),

                    _textField('ট্রানজেকশন আইডি (ইংরেজি)', size),
                    _textField('বিলের পরিমান (ইংরেজি)', size),
                    SizedBox(height: size.width * .04),

                    InkWell(
                      onTap: ()async{
                        await pProvider.checkConnectivity().then((value){
                          if(pProvider.internetConnected==true) _formValidation(pProvider);
                          else showErrorMgs('কোনও ইন্টারনেট সংযোগ নেই');
                        },onError: (error)=>showErrorMgs(error.toString()));
                      },
                      child: smallGradientButton(context, 'নিশ্চিত করুন'),
                      borderRadius: Design.buttonRadius,
                      splashColor: Theme.of(context).primaryColor,
                    ),
                    //SizedBox(height: size.width*.04),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _formValidation(PublicProvider pProvider){
    if(_monthController.text.isNotEmpty && _yearController.text.isNotEmpty){
        if (_phoneController.text.isNotEmpty && _payByController.text.isNotEmpty && _deductController.text.isNotEmpty && _transIdController.text.isNotEmpty && _amountController.text.isNotEmpty) {
          if(_phoneController.text.length==11){
            showLoadingDialog('অপেক্ষা করুন...');
            pProvider.submitBill(_monthController.text,_yearController.text,_phoneController.text,_transIdController.text,_amountController.text,_payByController.text,_deductController.text).then((success){
              if(success==true){
                closeLoadingDialog();
                showSuccessMgs('বিল প্রদান সম্পন্ন হয়েছে');
                _phoneController.clear();
                _transIdController.clear();
                _amountController.clear();
                _payByController.clear();
                _deductController.clear();
              }else{
                closeLoadingDialog();
                showErrorMgs('বিল প্রদান অসম্পন্ন হয়েছে!');
              }
            },onError: (error){
              closeLoadingDialog();
              showErrorMgs(error.toString());
            });
          }else
            showInfo(
                'মোবাইল নাম্বার অবশ্যই ১১ সংখ্যার হতে হবে');
        } else
          showInfo(
              'সকল তথ্য নিশ্চিত করুন');
    }else
      showInfo(
          'বিলের মাস নিশ্চিত করুন');
  }

  void _pickDate(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2050),
    ).then((date)=>
      setState((){
        _date=date;
        _monthController.text='${_date.month}';
        _yearController.text='${_date.year}';
        _dateController.text='${_date.day}/${_date.month}/${_date.year}';
      }));
  }

  TextFormField _textField(String hint, Size size) => TextFormField(
    maxLength: hint == 'মোবাইল নাম্বার (ইংরেজি)' ?11:null,
    readOnly: hint == 'তারিখ' ?true:false,
        onTap: ()=> hint=='তারিখ'?_pickDate():null,
        controller:
        hint == 'তারিখ' ? _dateController
                : hint == 'মোবাইল নাম্বার (ইংরেজি)' ? _phoneController
                : hint == 'বিলের পরিমান (ইংরেজি)' ? _amountController
                : _transIdController,
        keyboardType: hint == 'মোবাইল নাম্বার (ইংরেজি)'
            ? TextInputType.phone
            : hint == 'বিলের পরিমান (ইংরেজি)'
            ? TextInputType.number
            : TextInputType.text,
        decoration: Design.formDecoration(size).copyWith(labelText: hint),
      );
}

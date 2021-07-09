import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dhaka_fiber_link_user_panel/model/billing_info_model.dart';
import 'package:dhaka_fiber_link_user_panel/model/problem_model.dart';
import 'package:dhaka_fiber_link_user_panel/model/user_model.dart';
import 'package:dhaka_fiber_link_user_panel/widgets/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicProvider extends ChangeNotifier{

  UserModel _userModel = UserModel();
  bool _internetConnected=true;
  List<UserModel> _userList = [];
  List<ProblemModel> _problemList = [];
  List<BillingInfoModel> _approvedBillList = [];
  List<BillingInfoModel> _pendingBillList = [];
  String _address,_customerCare,_aboutUs,_services;


  get userModel=> _userModel;
  get userList=> _userList;
  get problemList=> _problemList;
  get internetConnected=> _internetConnected;
  get approvedBillList=> _approvedBillList;
  get pendingBillList=> _pendingBillList;

  get address=> _address;
  get customerCare=> _customerCare;
  get aboutUs=> _aboutUs;
  get services=> _services;

  set userModel(UserModel val){
    val= UserModel();
    _userModel = val;
    notifyListeners();
  }

  Future<void> checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());

    if (result == ConnectivityResult.none) {
      _internetConnected = false;
      notifyListeners();
    } else if (result == ConnectivityResult.mobile) {
      _internetConnected = true;
      notifyListeners();
    } else if (result == ConnectivityResult.wifi) {
      _internetConnected = true;
      notifyListeners();
    }
  }

  Future<String> getPrefID()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get('id');
  }

  Future<bool> getUser()async{
    try{
      final String id = await getPrefID();
      await FirebaseFirestore.instance.collection('Customers').where('phone', isEqualTo: id).get().then((snapshot){
        _userList.clear();
        snapshot.docChanges.forEach((element) {
          UserModel customerModel = UserModel(
              id: element.doc['id'],
              name: element.doc['name'],
              address: element.doc['address'],
              phone: element.doc['phone'],
              password: element.doc['password'],
              billAmount: element.doc['billAmount'],
              activity: element.doc['activity'],
              deductKey: element.doc['deductKey'],
              package: element.doc['package'],
              lastEntryMonth: element.doc['lastEntryMonth'],
              lastEntryYear: element.doc['lastEntryYear'],
              monthYear: element.doc['monthYear']
          );
          _userList.add(customerModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> updateUser(Map<String, String> dataMap)async{
    try{
      final int id = _userList[0].id;
      await FirebaseFirestore.instance.collection('Customers').doc('$id').update(dataMap);
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> recoverUserPassword(String id, String password)async{
    try{
      await FirebaseFirestore.instance.collection('Customers').doc(id).update({
        'password':password,
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> submitProblem(String problem)async{
    String date = DateFormat("dd-MM-yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    try{
      String id = await getPrefID();
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      if(userList.isEmpty) getUser();
      await FirebaseFirestore.instance.collection('UserProblems').doc('${userList[0].phone}').set({
        'id':'$id$timeStamp',
        'name':userList[0].name,
        'phone': userList[0].phone,
        'issueDate': date,
        'address':userList[0].address,
        'problem': problem,
        'status': 'pending',
        'timeStamp': timeStamp.toString(),
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getAllProblems()async{
    try{
       String id = await getPrefID();
      await FirebaseFirestore.instance.collection('UserProblems').where('phone', isEqualTo: id).orderBy('timeStamp',descending: true).get().then((snapshot){
        _problemList.clear();
        snapshot.docChanges.forEach((element) {
          ProblemModel problemModel = ProblemModel(
            id: element.doc['id'],
            name: element.doc['name'],
            phone: element.doc['phone'],
            issueDate: element.doc['issueDate'],
            address: element.doc['address'],
            problem: element.doc['problem'],
            timeStamp: element.doc['timeStamp'],
            status: element.doc['status'],
          );
          _problemList.add(problemModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> submitBill(String billingMonth,String billingYear, String billingNumber, String transactionId,String amount,String payBy)async{
    try{
      String payDate = DateFormat("yyyy-MM-dd").format(
          DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch));
      if(userList.isEmpty) getUser();
      int id = _userList[0].id;
      int timeStamp = DateTime.now().millisecondsSinceEpoch;

      await FirebaseFirestore.instance.collection('UserBillingInfo').doc('$timeStamp').set({
        'id': '$timeStamp',
        'name': _userList[0].name,
        'userPhone': _userList[0].phone,
        'userID': '$id',
        'payBy': payBy,
        'billingMonth': billingMonth,
        'billingYear': billingYear,
        'billingNumber': billingNumber,
        'transactionId': transactionId,
        'state':'pending',
        'amount': amount,
        'timeStamp': timeStamp,
        'payDate': payDate,
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getBillingInfo()async{
    try{
      String id = await getPrefID();
      await FirebaseFirestore.instance.collection('UserBillingInfo').where('userPhone', isEqualTo: id).orderBy('timeStamp',descending: true).get().then((snapshot){
        _pendingBillList.clear();
        _approvedBillList.clear();
        snapshot.docChanges.forEach((element) {
          if(element.doc['state']=='pending'){
            BillingInfoModel pendingBillingInfo = BillingInfoModel(
              id: element.doc['id'],
              name: element.doc['name'],
              userPhone: element.doc['userPhone'],
              userID: element.doc['userID'],
              payBy: element.doc['payBy'],
              billingMonth: element.doc['billingMonth'],
              billingYear: element.doc['billingYear'],
              billingNumber: element.doc['billingNumber'],
              transactionId: element.doc['transactionId'],
              amount: element.doc['amount'],
              state: element.doc['state'],
              //timeStamp: element.doc['timeStamp'],
              payDate: element.doc['payDate'],
            );
            _pendingBillList.add(pendingBillingInfo);
          }else if(element.doc['state']=='approved'){
            BillingInfoModel approvedBillingInfo = BillingInfoModel(
              id: element.doc['id'],
              name: element.doc['name'],
              userPhone: element.doc['userPhone'],
              userID: element.doc['userID'],
              payBy: element.doc['payBy'],
              billingMonth: element.doc['billingMonth'],
              billingYear: element.doc['billingYear'],
              billingNumber: element.doc['billingNumber'],
              transactionId: element.doc['transactionId'],
              amount: element.doc['amount'],
              state: element.doc['state'],
              //timeStamp: element.doc['timeStamp'],
              payDate: element.doc['payDate'],
            );
            _approvedBillList.add(approvedBillingInfo);
          }
        });
      });
      notifyListeners();
      return Future.value(true);

    }catch(error){
      return Future.value(false);
    }
  }

  // Future<bool> getDetails()async{
  //   try{
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('OfficeDetails').get();
  //     final List<QueryDocumentSnapshot> addressSnapshot = snapshot.docs;
  //     if(addressSnapshot.isNotEmpty) {
  //       _address = addressSnapshot[0].get('address');
  //       _customerCare = addressSnapshot[0].get('customerCare');
  //       _aboutUs = addressSnapshot[0].get('aboutUs');
  //       _services = addressSnapshot[0].get('ourService');
  //     }
  //     notifyListeners();
  //     return Future.value(true);
  //   }catch(error){
  //     return Future.value(false);
  //   }
  // }
}
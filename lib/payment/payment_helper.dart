import 'dart:convert';
import 'package:bkash/bkash.dart';

void onButtonTap(String selected, context,int totalPrice,String name) async {
  switch (selected) {
    case 'bkash':
      bkashPayment(context,totalPrice,name);
      break;

    // case 'uddoktapay':
    //   uddoktapay();
    //   break;
    //
    // case 'sslcommerz':
    //   sslcommerz();
    //   break;
    //
    // case 'shurjopay':
    //   shurjoPay();
    //   break;
    //
    // case 'razorpay':
    //   razorPay();
    //   break;

    default:
      print('No gateway selected');
  }
}

//double totalPrice = 1.00;

/// bKash
bkashPayment(context,int totalPrice,String name) async {
  final bkash = Bkash(
   // bkashCredentials: BkashCredentials(username: username, password: password, appKey: appKey, appSecret: appSecret),
    logResponse: true,
  );

  try {
    final response = await bkash.pay(
      context: context,
      amount: totalPrice.toDouble(),
      merchantInvoiceNumber: '$name',
      payerReference: 'Aucsy00$name'
    );

    print(response.trxId);
    print(response.paymentId);
  } on BkashFailure catch (e) {
    print(e.message);
  }
}


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volt_arena/consts/universal_variables.dart';

class ConstantKey {
  static const String PAYSTACK_KEY =
      "pk_live_03f672cc9fa110d9b3ae1a7a562b1ae43413eb7e";
}

class MakePayment {
  MakePayment({this.ctx, this.price, this.email});

  BuildContext? ctx;

  int? price;

  String? email;

  PaystackPlugin paystack = PaystackPlugin();

  //Reference

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  //GetUi
  PaymentCard _getCardUI() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  Future initializePlugin() async {
    await paystack.initialize(publicKey: ConstantKey.PAYSTACK_KEY);
  }

  //Method Charging card
  Future chargeCardAndMakePayment() async {
    print("here: chargeCardAndMakePayment");
    initializePlugin().then((_) async {
      Charge charge = Charge()
        ..amount = price! * 100
        ..email = email
        ..currency = "USD"
        ..reference = _getReference()
        ..card = _getCardUI();

      CheckoutResponse response = await paystack.checkout(
        ctx!,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: false,
        logo: Image.asset(
          logo,
          height: 24,
        ),
      );

      print("Response $response");

      if (response.status == true) {
        Fluttertoast.showToast(msg: "Transaction successful");
        print("Transaction successful");
      } else {
        print("Transaction failed");

        Fluttertoast.showToast(msg: "Transaction failed");
      }
      // return response.status;
    });
  }
}

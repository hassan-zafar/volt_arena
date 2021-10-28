import 'package:volt_arena/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/servicesScreen.dart';

class CartEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 120),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/emptycart.png'),
            ),
          ),
        ),
        Text(
          'Your bookings are Empty',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Looks Like You didn\'t \n add anything to your Bookings yet',
          textAlign: TextAlign.center,
          style: TextStyle(
              color:ColorsConsts.subTitle,
              // fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ServicesScreen.routeName);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.yellow),
            ),
            color: Colors.yellow,
            child: Text(
              'Shop now'.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                  // fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:volt_arena/consts/my_icons.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:volt_arena/utilities/custom_images.dart';
import 'package:volt_arena/utilities/utilities.dart';
import 'package:volt_arena/widget/tools/empty_image_widget.dart';

import 'cart_empty.dart';
import 'cart_full.dart';

class MyBookingsScreen extends StatefulWidget {
  //To be known 1) the amount must be an integer 2) the amount must not be double 3) the minimum amount should be less than 0.5 $
  static const routeName = '/CartScreen';

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  GlobalMethods globalMethods = GlobalMethods();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Cart (${cartProvider.getCartItems.length})'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear cart!',
                        'Your cart will be cleared!',
                        () => cartProvider.clearCart(),
                        context);
                    // cartProvider.clearCart();
                  },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
              child: cartProvider.getCartItems.isEmpty
                  ? EmptyImageWidget(
                      assetImage: CustomImages.emptyCart,
                      title: 'No Booking found',
                      subtitle:
                          '''Looks like you don't\nadd anything in your booking yet''',
                    )
                  : ListView.builder(
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return ChangeNotifierProvider.value(
                          value:
                              cartProvider.getCartItems.values.toList()[index],
                          child: CartFull(
                            productId:
                                cartProvider.getCartItems.keys.toList()[index],
                          ),
                        );
                      },
                    ),
            ),
          );
  }

  Widget checkoutSection(BuildContext ctx, double subtotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    var uuid = Uuid();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            /// mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(30),
              //       gradient: LinearGradient(colors: [
              //         ColorsConsts.gradiendLStart,
              //         ColorsConsts.gradiendLEnd,
              //       ], stops: [
              //         0.0,
              //         0.7
              //       ]),
              //     ),
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //         borderRadius: BorderRadius.circular(30),
              //         onTap: () async {
              //           double amountInCents = subtotal * 1000;
              //           int intengerAmount = (amountInCents / 10).ceil();

              //           // await payWithCard(amount: intengerAmount);
              //           if (response.success == true) {
              //             User user = _auth.currentUser!;
              //             final _uid = user.uid;
              //             cartProvider.getCartItems
              //                 .forEach((key, orderValue) async {
              //               final orderId = uuid.v4();
              //               try {
              //                 await FirebaseFirestore.instance
              //                     .collection('order')
              //                     .doc(orderId)
              //                     .set({
              //                   'orderId': orderId,
              //                   'userId': _uid,
              //                   'productId': orderValue.productId,
              //                   'title': orderValue.title,
              //                   'price':
              //                       orderValue.price! * orderValue.quantity!,
              //                   'imageUrl': orderValue.imageUrl,
              //                   'quantity': orderValue.quantity,
              //                   'orderDate': Timestamp.now(),
              //                 });
              //               } catch (err) {
              //                 print('error occured $err');
              //               }
              //             });
              //           } else {
              //             globalMethods.authErrorHandle(
              //                 'Please enter your true information', context);
              //           }
              //           globalMethods.authErrorHandle(
              //               'Please enter your true information', context);
              //         },
              //         splashColor: Theme.of(ctx).splashColor,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             'Checkout',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 color: Theme.of(ctx).textSelectionColor,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // GooglePayButton(
              //   paymentConfigurationAsset: 'gpay.json',
              //   paymentItems: _paymentItems,
              //   width: 200,
              //   height: 50,
              //   style: GooglePayButtonStyle.black,
              //   type: GooglePayButtonType.pay,
              //   margin: const EdgeInsets.only(top: 15.0),
              //   onPaymentResult: (data) {
              //     print(data);
              //     double amountInCents = subtotal * 1000;
              //     int intengerAmount = (amountInCents / 10).ceil();

              //     // await payWithCard(amount: intengerAmount);

              //     User user = _auth.currentUser!;
              //     final _uid = user.uid;
              //     cartProvider.getCartItems.forEach((key, orderValue) async {
              //       final orderId = uuid.v4();
              //       try {
              //         await FirebaseFirestore.instance
              //             .collection('order')
              //             .doc(orderId)
              //             .set({
              //           'orderId': orderId,
              //           'userId': _uid,
              //           'productId': orderValue.productId,
              //           'title': orderValue.title,
              //           'price': orderValue.price! * orderValue.quantity!,
              //           'imageUrl': orderValue.imageUrl,
              //           'quantity': orderValue.quantity,
              //           'orderDate': Timestamp.now(),
              //         });
              //       } catch (err) {
              //         print('error occured $err');
              //       }
              //     });
              //   },
              //   loadingIndicator: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // ),

              Spacer(),
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₦ ${subtotal.toStringAsFixed(3)}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}

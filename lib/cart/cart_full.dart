import 'package:volt_arena/consts/colors.dart';
import 'package:volt_arena/inner_screens/service_details.dart';
import 'package:volt_arena/models/cart_attr.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartFull extends StatefulWidget {
  final String? productId;

  const CartFull({this.productId});

  // final String id;
  // final String productId;
  // final double price;
  // final int quatity;
  // final String title;
  // final String imageUrl;

  // const CartFull(
  //     {@required this.id,
  //     @required this.productId,
  //     @required this.price,
  //     @required this.quatity,
  //     @required this.title,
  //     @required this.imageUrl});
  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final cartAttr = Provider.of<CartAttr>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartAttr.price! * cartAttr.quantity!;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
          arguments: widget.productId),
      child: Container(
        height: 135,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(cartAttr.imageUrl!),
                    fit: BoxFit.contain),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            cartAttr.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            // splashColor: ,
                            onTap: () {
                              globalMethods.showDialogg(
                                  'Remove item!',
                                  'Product will be removed from the cart!',
                                  () => cartProvider
                                      .removeItem(widget.productId!),
                                  context);
                              //
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Price:'),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${cartAttr.price}\$',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Sub Total:'),
                        SizedBox(
                          width: 5,
                        ),
                        FittedBox(
                          child: Text(
                            '${subTotal.toStringAsFixed(2)} \$',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '  ',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            // splashColor: ,
                            onTap: cartAttr.quantity! < 2
                                ? null
                                : () {
                                    cartProvider.reduceItemByOne(
                                      widget.productId!,
                                    );
                                  },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.remove,
                                  color: cartAttr.quantity! < 2
                                      ? Colors.grey
                                      : Colors.red,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.yellow,

                            // gradient: LinearGradient(colors: [
                            //   ColorsConsts.gradiendLStart,
                            //   ColorsConsts.gradiendLEnd,
                            // ], stops: [
                            //   0.0,
                            //   0.7
                            // ]),
                          ),
                          child: Text(
                            cartAttr.quantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            // splashColor: ,
                            onTap: () {
                              cartProvider.addProductToCart(
                                  widget.productId!,
                                  cartAttr.price!,
                                  cartAttr.title!,
                                  cartAttr.imageUrl!);
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

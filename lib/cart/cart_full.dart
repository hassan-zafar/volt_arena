import 'package:volt_arena/inner_screens/service_details.dart';
import 'package:volt_arena/models/cart_attr.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/utilities/utilities.dart';

class CartFull extends StatefulWidget {
  final String? productId;
  const CartFull({this.productId});
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
      onTap: () => Navigator.pushNamed(
        context,
        ServiceDetailsScreen.routeName,
        arguments: widget.productId,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Utilities.borderRadius),
        child: Container(
          height: 135,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(Utilities.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                height: double.infinity,
                child: Image.network(
                  cartAttr.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Utilities.padding,
                    horizontal: Utilities.padding / 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Price:'),
                          SizedBox(width: 5),
                          Text(
                            '${cartAttr.price}₦',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        height: 28,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 30,
                        ),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(Utilities.borderRadius),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: cartAttr.quantity! < 2
                                    ? () => cartProvider
                                        .removeItem(widget.productId!)
                                    : () => cartProvider.reduceItemByOne(
                                          widget.productId!,
                                        ),
                                child: Icon(Icons.remove),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                cartAttr.quantity.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.horizontal(
                                  right:
                                      Radius.circular(Utilities.borderRadius),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => cartProvider.addProductToCart(
                                  widget.productId!,
                                  cartAttr.price!,
                                  cartAttr.title!,
                                  cartAttr.imageUrl!,
                                ),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Sub Total:'),
                          SizedBox(
                            width: 5,
                          ),
                          FittedBox(
                            child: Text(
                              '${subTotal.toStringAsFixed(2)} ₦',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       '  ',
                      //       style:
                      //           TextStyle(color: Theme.of(context).accentColor),
                      //     ),
                      //     Spacer(),
                      //     Material(
                      //       color: Colors.transparent,
                      //       child: InkWell(
                      //         borderRadius: BorderRadius.circular(4.0),
                      //         // splashColor: ,
                      //         onTap: cartAttr.quantity! < 2
                      //             ? null
                      //             : () {
                      //                 cartProvider.reduceItemByOne(
                      //                   widget.productId!,
                      //                 );
                      //               },
                      //         child: Container(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(5.0),
                      //             child: Icon(
                      //               Icons.remove,
                      //               color: cartAttr.quantity! < 2
                      //                   ? Colors.grey
                      //                   : Colors.red,
                      //               size: 22,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: MediaQuery.of(context).size.width * 0.12,
                      //       padding: const EdgeInsets.all(8.0),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20),
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //       child: Text(
                      //         cartAttr.quantity.toString(),
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(color: Colors.black),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       borderRadius: BorderRadius.circular(4.0),
                      //       // splashColor: ,
                      //       onTap: () {
                      //         cartProvider.addProductToCart(
                      //             widget.productId!,
                      //             cartAttr.price!,
                      //             cartAttr.title!,
                      //             cartAttr.imageUrl!);
                      //       },
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(5.0),
                      //         child: Icon(
                      //           Icons.add,
                      //           color: Colors.green,
                      //           size: 22,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/inner_screens/service_details.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/provider/favs_provider.dart';
import 'package:volt_arena/provider/products.dart';
import '../../../../models/product.dart';
import '../../../../utilities/custom_images.dart';
import '../../../../utilities/utilities.dart';

class ServiceCardWidget extends StatelessWidget {
  const ServiceCardWidget({required this.product, Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);

    final prodAttr = productsData.findById(product.productId!);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<ServiceDetailsScreen>(
            builder: (BuildContext context) => ServiceDetailsScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 2 / 1,
                child: (product.imageUrl != null || product.imageUrl!.isEmpty)
                    ? Image.asset(CustomImages.icon, fit: BoxFit.cover)
                    : Image.network(product.imageUrl!),
              ),
              Badge(
                alignment: Alignment.center,
                toAnimate: true,
                shape: BadgeShape.square,
                badgeColor: Colors.pink,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                badgeContent: const Text(
                  'New',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(Utilities.padding / 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.9)
                      ],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              product.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '\$${product.price}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          favsProvider.addAndRemoveFromFav(
                              product.productId!,
                              double.parse(prodAttr.price!),
                              prodAttr.title!,
                              prodAttr.imageUrl!);
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cartProvider.addProductToCart(
                              product.productId!,
                              double.parse(prodAttr.price!),
                              prodAttr.title!,
                              prodAttr.imageUrl!);
                        },
                        icon: const Icon(Icons.add_shopping_cart_outlined),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
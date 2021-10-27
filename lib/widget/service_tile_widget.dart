import 'package:flutter/material.dart';
import 'package:volt_arena/inner_screens/service_details.dart';
import '../../../../models/product.dart';
import '../../../../utilities/custom_images.dart';
import '../../../../utilities/utilities.dart';

class ServicesTileWidget extends StatelessWidget {
  const ServicesTileWidget({required Product product, Key? key})
      : _product = product,
        super(key: key);

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Utilities.padding,
        vertical: Utilities.padding / 3,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Utilities.padding),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<ServiceDetailsScreen>(
              builder: (BuildContext context) => ServiceDetailsScreen(),
            ),
          );
        },
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(Utilities.padding),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Utilities.padding),
                  bottomLeft: Radius.circular(Utilities.padding),
                ),
                child: SizedBox(
                  width: 80,
                  height: double.infinity,
                  child: Image.network(
                    _product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) =>
                        Image.asset(CustomImages.icon, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _product.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${_product.price!}',
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
                splashRadius: 20,
                onPressed: () {
                  
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: const Icon(Icons.add_shopping_cart_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

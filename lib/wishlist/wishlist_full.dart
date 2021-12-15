import 'package:cached_network_image/cached_network_image.dart';
import 'package:volt_arena/consts/colors.dart';
import 'package:volt_arena/models/favs_attr.dart';
import 'package:volt_arena/provider/favs_provider.dart';
import 'package:volt_arena/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/utilities/utilities.dart';

class WishlistFull extends StatefulWidget {
  final String productId;

  const WishlistFull({required this.productId});
  @override
  _WishlistFullState createState() => _WishlistFullState();
}

class _WishlistFullState extends State<WishlistFull> {
  @override
  Widget build(BuildContext context) {
    final favsAttr = Provider.of<FavsAttr>(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
              child: Material(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(5.0),
                elevation: 3.0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child:  CachedNetworkImage(
                 imageUrl: 
                            favsAttr.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                favsAttr.title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₦ ${favsAttr.price}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        positionedRemove(widget.productId),
      ],
    );
  }

  Widget positionedRemove(String productId) {
    final favsProvider = Provider.of<FavsProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        height: 20,
        width: 20,
        child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: EdgeInsets.all(0.0),
            color: ColorsConsts.favColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => {
                  globalMethods.showDialogg(
                      'Remove wish!',
                      'This product will be removed from your wishlist!',
                      () => favsProvider.removeItem(productId),
                      context),
                }),
      ),
    );
  }
}

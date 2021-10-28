import 'package:flutter/material.dart';
import 'package:volt_arena/utilities/custom_images.dart';
import 'package:volt_arena/widget/tools/empty_image_widget.dart';

class CartEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0),
      body: EmptyImageWidget(
        assetImage: CustomImages.emptyCart,
        title: 'No Booking found',
        subtitle: '''Looks like you don't\nadd anything in your booking yet''',
      ),
    );
  }
}

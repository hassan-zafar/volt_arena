import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:volt_arena/consts/colors.dart';
import 'package:volt_arena/services/global_method.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

enum IndGrp { Individual, Group, Either }

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _productCategory = '';
  var _productBrand = '';
  var _productDescription = '';
  String? _gameTime = "20";
  var _pellets = '';

  final TextEditingController _categoryController = TextEditingController();
  TextEditingController _gameTimeController = TextEditingController();
  String? _categoryValue;
  String? _brandValue;
  GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uuid = Uuid();
  final FixedExtentScrollController groupIndividual =
      FixedExtentScrollController(initialItem: 0);
  final FixedExtentScrollController groupmemberNumbers =
      FixedExtentScrollController(initialItem: 0);

  bool? _isIndividual = true;
  int? _groupMembers = 10;

  int? indGrpValue = 0;

  String? _indGroupType;
  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(_productTitle);
      print(_productPrice);
      print(_productCategory);
      print(_productBrand);
      print(_productDescription);
      print(_gameTime);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('productsImages')
              .child(_productTitle + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final productId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .set({
            'productId': productId,
            'productTitle': _productTitle,
            'price': _productPrice,
            'productImage': url,
            'productCategory': _indGroupType,
            'pallets': _pellets,
            "groupMembers": _isIndividual! ? 0 : _groupMembers,
            'productDescription': _productDescription,
            'gameTime': _gameTime,
            'userId': _uid,
            "isIndividual": _isIndividual,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gameTimeController = TextEditingController(text: _gameTime!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          height: kBottomNavigationBarHeight * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsConsts.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            child: InkWell(
              onTap: _trySubmit,
              splashColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _isLoading
                        ? Center(
                            child: Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator()))
                        : Text('Upload',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                  ),
                  GradientIcon(
                    Icons.upload,
                    20,
                    LinearGradient(
                      colors: <Color>[
                        Colors.green,
                        Colors.yellow,
                        Colors.deepOrange,
                        Colors.orange,
                        Colors.yellow.shade800
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    key: ValueKey('Title'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a Title';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Service Title',
                                    ),
                                    onSaved: (value) {
                                      _productTitle = value!;
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  key: ValueKey('Price \$'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Price is missed';
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Price \$',
                                    //  prefixIcon: Icon(Icons.mail),
                                    // suffixIcon: Text(
                                    //   '\n \n \$',
                                    //   textAlign: TextAlign.start,
                                    // ),
                                  ),
                                  //obscureText: true,
                                  onSaved: (value) {
                                    _productPrice = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          /* Image picker here ***********************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                //  flex: 2,
                                child: this._pickedImage == null
                                    ? Container(
                                        margin: EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        child: Container(
                                          height: 200,
                                          // width: 200,
                                          decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.only(
                                            //   topLeft: const Radius.circular(40.0),
                                            // ),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                          child: Image.file(
                                            this._pickedImage!,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageCamera,
                                      icon: Icon(Icons.camera),
                                      label: Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageGallery,
                                      icon: Icon(Icons.image),
                                      label: Text(
                                        'Gallery',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _removeImage,
                                      icon: Icon(
                                        Icons.remove_circle_rounded,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'Remove',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                              key: ValueKey('Description'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'service description is required';
                                }
                                return null;
                              },
                              //controller: this._controller,
                              maxLines: 10,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                //  counterText: charLength.toString(),
                                labelText: 'Description',
                                hintText: 'Service description',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _productDescription = value!;
                              },
                              onChanged: (text) {
                                // setState(() => charLength -= text.length);
                              }),
                          //    SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                //flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    controller: _gameTimeController,
                                    keyboardType: TextInputType.number,
                                    key: ValueKey('Game Time'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Game time is missing';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Game Time',
                                      suffix: Text("min"),
                                    ),
                                    onSaved: (value) {
                                      _gameTime = value!;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    key: ValueKey('Pellets'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Number of Pellets are missed';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Pellets',
                                    ),
                                    onSaved: (value) {
                                      _pellets = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text("Group / Individual / Either"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: groupIndividualPicker(
                                    controller: groupIndividual,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _isIndividual!
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text("Number of group members"),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: groupMembers(
                                              controller: groupmemberNumbers)),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container groupIndividualPicker({
    final controller,
  }) {
    return Container(
      // width: 200,
      height: 80,
      child: CupertinoPicker(
        selectionOverlay: null,
        // squeeze: 1.5,
        onSelectedItemChanged: (int value) {
          setState(() {
            if (value == 0) {
              this.indGrpValue = value;

              _isIndividual = true;
              _indGroupType = "individual";
            } else if (value == 1) {
              _isIndividual = false;
              _indGroupType = "group";
            } else {
              _isIndividual = false;
              _indGroupType = "either";
            }
          });
          print(_isIndividual);
        },
        itemExtent: 25,
        scrollController: controller,
        children: [
          Text("Individual"),
          Text("Group"),
          Text("Either"),
        ],
        useMagnifier: true, diameterRatio: 1,
        magnification: 1.1,
      ),
    );
  }

  Container groupMembers({
    final controller,
  }) {
    return Container(
      // width: 200,
      height: 80,
      child: CupertinoPicker(
        selectionOverlay: null,
        // squeeze: 1.5,
        onSelectedItemChanged: (int value) {
          setState(() {
            if (value == 0) {
              _groupMembers = 10;
            } else if (value == 1) {
              _groupMembers = 20;
            } else if (value == 2) {
              _groupMembers = 50;
            }
          });
        },
        itemExtent: 25,
        scrollController: controller,
        children: [
          Text("10"),
          Text("20"),
          Text("50"),
        ],
        useMagnifier: true, diameterRatio: 1,
        magnification: 1.1,
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

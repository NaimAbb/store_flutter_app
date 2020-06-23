import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_flutter_app/localization/localization_constants.dart';
import 'package:store_flutter_app/models/category.dart';
import 'package:store_flutter_app/models/product.dart';
import 'package:store_flutter_app/providers/merchant.dart';
import 'package:store_flutter_app/widgets/button_common.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:store_flutter_app/widgets/error_dialog_widget.dart';
import 'package:store_flutter_app/widgets/success_dialog_widget.dart';
import 'dart:convert';

class NewProductScreen extends StatefulWidget {
  static const String routeName = '/new-product-screen';

  @override
  State<StatefulWidget> createState() {
    return _NewProductScreenState();
  }
}

class _NewProductScreenState extends State<NewProductScreen> {
  Merchant _merchant;
  bool _isFirst = true;
  File _imageProduct;

  String _categorySelected;

  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final _nameProductController = TextEditingController();
  final _priceProductController = TextEditingController();
  final _duscriptionProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameProductController.dispose();
    _priceProductController.dispose();
    _duscriptionProductController.dispose();
    _merchant.changeValueChooseImageToFalse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirst) {
      _merchant = Provider.of<Merchant>(context, listen: false);
      _merchant.getCategories();
    }
    _isFirst = false;
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            height: 70,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      File imageProduct = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      _imageProduct = imageProduct;
                      _merchant.changeValueChooseImage();
                    },
                    child: Column(
                      children: <Widget>[Icon(Icons.image), Text('Gallery')],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      File imageProduct = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      _imageProduct = imageProduct;
                      _merchant.changeValueChooseImage();
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Text('Camera')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _save() async {
    bool result = _formState.currentState.validate();
    if (!result) return;
    if (_imageProduct == null) {
      showDialog(
          context: context,
          builder: (_) =>
              ErrorDialogWidget(getTranslated(context, 'MustUploadImage')));
      return;
    }
//    String base64 = base64Encode(_imageProduct.readAsBytesSync());
//    print(base64);

    try {
      Category category = _merchant.categories
          .firstWhere((element) => element.name == _categorySelected);
      Product product = new Product(
          _nameProductController.text,
          double.parse(_priceProductController.text),
          category.id,
          _duscriptionProductController.text);
      // product.image = base64;

      await _merchant.addProduct(product, _imageProduct);
      await showDialog(
          context: context, builder: (_) => SuccessDialogWidget('Success'));
      Navigator.of(context).pop();
    }catch(error){
      print(error.toString());
    }

    //  DBHelper().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formState,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Selector<Merchant, bool>(
                selector: (_, value) => value.valueChooseImage,
                builder: (_, chooseImage, __) {
                  if (!chooseImage) {
                    return Container();
                  }
                  if (_imageProduct != null && chooseImage) {
                    return Image.file(
                      _imageProduct,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  }
                  return Container();
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseFillThisField');
                    }
                    return null;
                  },
                  controller: _nameProductController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'ProductName')),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseFillThisField');
                    }
                    return null;
                  },
                  controller: _priceProductController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'ProductPrice')),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<Merchant>(builder: (_, merchant, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return getTranslated(context, 'PleaseFillThisField');
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: getTranslated(context, 'ProductCategory'),
                      hintStyle: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    items: merchant.categories.map((e) {
                      return DropdownMenuItem(
                        child: Text(e.name),
                        value: e.name,
                      );
                    }).toList(),
                    onChanged: (val) {
                      _categorySelected = val;
                    },
                  ),
                );
              }),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: TextFormField(
//                decoration: InputDecoration(
//                    labelText: getTranslated(context, 'ProductCategory')),
//              ),
//            ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, 'PleaseFillThisField');
                    }
                    return null;
                  },
                  controller: _duscriptionProductController,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, 'Duscription')),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ButtonCommon(
                getTranslated(context, "PickImage"),
                onPress: () {
                  _pickImage();
                },
              ),
              SizedBox(
                height: 30,
              ),
              ButtonCommon(
                getTranslated(context, 'AddProduct'),
                onPress: () {
                  _save();
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

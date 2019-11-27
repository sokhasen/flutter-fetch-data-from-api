import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_app/data/models/product.dart';
import 'package:product_app/data/services/products.dart';

class Create extends StatefulWidget {
  Create({Key key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final nameTextEditingController = TextEditingController();
  final priceTextEditingController = TextEditingController();
  final descriptionTextEditingController = TextEditingController();
  final quantityTextEditingController = TextEditingController();
  String strImage;
  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      strImage = base64.encode(image.readAsBytesSync());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Product'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.grey.shade100,
                      width: double.infinity,
                      child: _image == null? Center(
                        child: Text('No Image'),
                      ):
                      Image.file(_image, fit: BoxFit.cover,)
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 5,
                                    child: TextField(
                                      controller: nameTextEditingController,
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: _getImage,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: priceTextEditingController,
                                decoration: InputDecoration(
                                  labelText: "Price",
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: quantityTextEditingController,
                                decoration: InputDecoration(
                                  labelText: "Quantity",
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                controller: descriptionTextEditingController,
                                decoration: InputDecoration(
                                  labelText: "Description",
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() async {
    final product = Product(
      null, 
      nameTextEditingController.text, 
      priceTextEditingController.text.isEmpty? '0.0': priceTextEditingController.text, 
      strImage ?? '', 
      quantityTextEditingController.text.isEmpty ? '0': quantityTextEditingController.text, 
      descriptionTextEditingController.text);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 1,),
            SizedBox(width: 40,),
            Expanded(
              child: Text('Saving...'),
            ),
          ],
        ),
      )
    );

    try {
      await Products().create(product);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Fail to insett!'),
        )
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameTextEditingController.dispose();
    priceTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    quantityTextEditingController.dispose();
  }
}

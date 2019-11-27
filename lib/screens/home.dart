import 'package:flutter/material.dart';
import 'package:product_app/constants/var.dart';
import 'package:product_app/core/errors/http_error.dart';
import 'package:product_app/data/services/products.dart';
import 'package:product_app/data/models/product.dart';

import 'screens.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(icon: Icon(Icons.add), onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => Create()
              ));
            },),
          )
        ],
      ),
      body: _buildFutureProduct(),
    );
  }

  _buildFutureProduct() {
    return FutureBuilder(
      future: _fetchProduct(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          );
        }
        if(snapshot.hasData) {
          return Container(
            child: _buildListProduct(snapshot.data),
          );
        } 
        if(snapshot.hasError) {
          return Center(
            child: Text('Network Error'),
          );
        }
      },
    );
  }

  _buildListProduct(List<Product> products) {
    return ListView.separated(
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: Container(
            width: 80,
            height: 120,
            color: Colors.grey.shade400,
            child: Hero(
              tag: products[index].id, 
              child: Image(
                image: NetworkImage(BASE_API_URL + products[index].image),
              ),
            ),
          ),
          title: Text(products[index].name ?? ''),
          subtitle: Text('\$${products[index].price}'),
          trailing: Text('${products[index].quantity}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
  Future<List<Product>> _fetchProduct()  async {
    try {
      return await Products().getList();
    } catch (e) {
      print(e);
      throw NetworkFailure();
    }
  }
}
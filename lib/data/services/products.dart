import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:product_app/constants/var.dart';
import 'package:product_app/core/errors/http_error.dart';
import '../models/product.dart';

class Products {
  final headers = {'Content-Type': 'application/json'};
  Future getList() async {
    try {
      var response = await http.get(BASE_API_URL + 'products', headers: headers);
      if(response.statusCode == HttpStatus.ok) {
        var data = json.decode(response.body);
        return Product.fromJsonList(data);
      }
      return [];
    }
    catch (e) {
      print(e);
      throw NetworkFailure();
    }
  }

  Future<Product> getOne(String productId) {
    
  }

  Future<Product> create(Product product) async {
    try {
      var response = await http.post(
        BASE_API_URL + 'products', 
        headers: headers, 
        body: json.encode(product.toJson())
      );
      if(response.statusCode == HttpStatus.created) {
        var data = json.decode(response.body);
        return Product.fromJson(data);
      }
      return null;
    }
    catch (e) {
      print(e);
      throw NetworkFailure();
    }
  }

  Future<Product> update(String productId, Product product) {
    
  }

  Future<Product> delete(String productId) {
    
  }
}
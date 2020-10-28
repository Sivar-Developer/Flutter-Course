import 'dart:convert';

import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:http/http.dart' as http;

import './../models/product.dart';

mixin ProductsModel on ConnectedProducts {
  
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if(_showFavorites) {
      return List.from(products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  Product get selectedProduct {
    return selectedProductIndex != null ? products[selectedProductIndex] : null;
  }

  bool get displayFavoriteOnly {
    return _showFavorites;
  }

  void addProduct(String title, String description, String image, double price) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': 'http://lorempixel.com/800/800/food',
      'price': price
    };
    http.post('https://flutter-products-7ddd6.firebaseio.com/products.json', body: json.encode(productData))
    .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product product = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id
      );
      products.add(product);
      notifyListeners();
    });
  }

  void updateProduct(String title, String description, String image, double price) {
    products[selectedProductIndex] = Product(
      title: title,
      description: description,
      image: image,
      price: price,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id
    );
    selProductIndex = null;
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      isFavorite: newFavoriteStatus,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id
    );
    products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectProduct(int productId) {
    selProductIndex = productId;
    if (productId != null) {
      notifyListeners();
    }
  }
}
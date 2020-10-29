import 'dart:convert';

import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:http/http.dart' as http;

import './../models/product.dart';

mixin ProductsModel on ConnectedProductsModel {
  
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
   return products.indexWhere((Product product) => product.id == selProductId);
  }

  String get selectedProductId {
    return selProductId;
  }

  Product get selectedProduct {
    return selectedProductId != null ? products.firstWhere((Product product) {
      return product.id == selProductId;
    }) : null;
  }

  bool get displayFavoriteOnly {
    return _showFavorites;
  }

  Future<Null> addProduct(String title, String description, String image, double price) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': 'https://placekitten.com/1000/1000',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id,
    };
    return http.post('https://flutter-products-7ddd6.firebaseio.com/products.json', body: json.encode(productData))
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
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> updateProduct(String title, String description, String image, double price) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'image': 'https://placekitten.com/1000/1000',
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    return http.put('https://flutter-products-7ddd6.firebaseio.com/products/${selectedProduct.id}.json', body: json.encode(updatedData))
      .then((http.Response response) {
        isLoading = false;
        final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id
        );
        products[selectedProductIndex] = updatedProduct;
        notifyListeners();
      });
  }

  Future<Null> deleteProduct() {
    isLoading = true;
    final deletedProductId = selectedProduct.id;
    final int selectedProductIndex = products.indexWhere((Product product) => product.id == selProductId);
    products.removeAt(selectedProductIndex);
    selProductId = null;
    notifyListeners();
    return http.delete('https://flutter-products-7ddd6.firebaseio.com/products/$deletedProductId.json')
    .then((http.Response response) {
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    isLoading  = true;
    notifyListeners();
    return http.get('https://flutter-products-7ddd6.firebaseio.com/products.json')
    .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if(productListData == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) { 
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId']
        );
        fetchedProductList.add(product);
      });
      products = fetchedProductList;
      isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      id: selectedProduct.id,
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

  void selectProduct(String productId) {
    selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }
}
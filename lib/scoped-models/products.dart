import 'dart:convert';

import 'package:flutter_course/models/location_data.dart';
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

  Future<bool> addProduct(String title, String description, String image, double price, LocationData locData) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id,
    };
    try {
      final http.Response response = await http.post('https://flutter-products-7ddd6.firebaseio.com/products.json?auth=${authenticatedUser.token}', body: json.encode(productData));
      if(response.statusCode != 200 && response.statusCode != 201) {
        isLoading = false;
        notifyListeners();
        return false;
      }

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
      return true;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error);
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, String image, double price) {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    return http.put('https://flutter-products-7ddd6.firebaseio.com/products/${selectedProduct.id}.json?auth=${authenticatedUser.token}', body: json.encode(updatedData))
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
        return true;
      })
      .catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    isLoading = true;
    final deletedProductId = selectedProduct.id;
    final int selectedProductIndex = products.indexWhere((Product product) => product.id == selProductId);
    products.removeAt(selectedProductIndex);
    selProductId = null;
    notifyListeners();
    return http.delete('https://flutter-products-7ddd6.firebaseio.com/products/$deletedProductId.json?auth=${authenticatedUser.token}')
    .then((http.Response response) {
      isLoading = false;
      notifyListeners();
      return true;
    })
    .catchError((error) {
      isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    isLoading  = true;
    notifyListeners();
    return http.get('https://flutter-products-7ddd6.firebaseio.com/products.json?auth=${authenticatedUser.token}')
    .then<Null>((http.Response response) {
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
          userId: productData['userId'],
          isFavorite: productData['whishlistUsers'] == null ? false : (productData['whishlistUsers'] as Map<String, dynamic>).containsKey(authenticatedUser.id)
        );
        fetchedProductList.add(product);
      });
      products = onlyForUser ? fetchedProductList.where((Product product) {
        return product.userId == authenticatedUser.id;
      }).toList() : fetchedProductList;
      isLoading = false;
      notifyListeners();
      selProductId = null;
    });
  }

  void toggleProductFavoriteStatus() async {
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
    http.Response response;
    if(newFavoriteStatus) {
      response = await http.put('https://flutter-products-7ddd6.firebaseio.com/products/${selectedProduct.id}/whishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}', body: json.encode(true));
    } else {
      response = await http.delete('https://flutter-products-7ddd6.firebaseio.com/products/${selectedProduct.id}/whishlistUsers/${authenticatedUser.id}.json?auth=${authenticatedUser.token}');
    }
    if(response.statusCode != 200 && response.statusCode != 201) {
        final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          isFavorite: !newFavoriteStatus,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id
        );
        products[selectedProductIndex] = updatedProduct;
        notifyListeners();
      }
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
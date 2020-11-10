import 'dart:convert';
import 'dart:io';

import 'package:flutter_course/models/location_data.dart';
import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<Map<String, dynamic>> uploadImage(File image, {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse('https://us-central1-flutter-products-7ddd6.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath('image', image.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    if(imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] = 'Bearer ${authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch(error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(String title, String description, File image, double price, LocationData locData) async {
    isLoading = true;
    notifyListeners();

    final uploadData = await uploadImage(image);

    if(uploadData == null) {
      print('Upload failed');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
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
        image: uploadData['imageUrl'],
        imagePath: uploadData['imagePath'],
        price: price,
        location: locData,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id
      );
      // print(product.image);
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

  Future<bool> updateProduct(String title, String description, File image, double price, LocationData locData) async {
    isLoading = true;
    notifyListeners();
    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if(image != null) {
      final uploadData = await uploadImage(image);

      if(uploadData == null) {
        print('Upload failed');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };

    try {
    final http.Response response = await http.put('https://flutter-products-7ddd6.firebaseio.com/products/${selectedProduct.id}.json?auth=${authenticatedUser.token}', body: json.encode(updatedData));
      isLoading = false;
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: imageUrl,
        imagePath: imagePath,
        price: price,
        location: selectedProduct.location,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id
      );
      products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      return false;
    }
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
    products = [];
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
          image: productData['imageUrl'],
          imagePath: productData['imagePath'],
          price: productData['price'],
          location: LocationData(address: productData['loc_address'], latitude: productData['loc_lat'], longitude: productData['loc_lng']),
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
      imagePath: selectedProduct.imagePath,
      location: selectedProduct.location,
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
          imagePath: selectedProduct.imagePath,
          location: selectedProduct.location,
          isFavorite: !newFavoriteStatus,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id
        );
        products[selectedProductIndex] = updatedProduct;
        notifyListeners();
      }
      selProductId = null;
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
import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import './user.dart';

class MainModel extends Model with ConnectedProducts, UserModel, ProductsModel {}
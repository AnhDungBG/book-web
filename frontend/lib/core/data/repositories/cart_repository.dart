import 'package:flutter_web_fe/core/services/api_service.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';

class CartService {
  final ApiClient _apiClient;

  CartService(this._apiClient);

  Future<CartModel> getCart() async {
    final response = await _apiClient.get('/cart');
    return CartModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<CartModel> addToCart(CartItemModel item) async {
    final response = await _apiClient.post('/cart/add', item.toJson());
    return CartModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<CartModel> removeFromCart(String itemId) async {
    final response = await _apiClient.post('/cart/remove', {'itemId': itemId});
    return CartModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<CartModel> updateCartItemQuantity(String itemId, int quantity) async {
    final response = await _apiClient.post('/cart/update', {
      'itemId': itemId,
      'quantity': quantity,
    });
    return CartModel.fromJson(response.body as Map<String, dynamic>);
  }

  Future<void> clearCart() async {
    await _apiClient.post('/cart/clear', {});
  }
}

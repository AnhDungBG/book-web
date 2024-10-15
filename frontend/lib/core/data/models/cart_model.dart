import 'package:equatable/equatable.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

// ignore: must_be_immutable
class CartModel extends Equatable {
  List<CartItemModel> items;
  double subtotal;
  final double shippingFee;
  double totalPrice;

  CartModel({
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [items, subtotal, shippingFee, totalPrice];

  // Factory method to create CartModel from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as double,
      shippingFee: json['shippingFee'] as double,
      totalPrice: json['totalPrice'] as double,
    );
  }

  // Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'totalPrice': totalPrice,
    };
  }

  // Copy with modified values and recalculate totals
  CartModel copyWith({
    List<CartItemModel>? items,
    double? subtotal,
    double? shippingFee,
    double? totalPrice,
  }) {
    return CartModel(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      totalPrice: totalPrice ?? this.totalPrice,
    ).._recalculateTotals();
  }

  // Add item to cart and recalculate totals
  void addItem(Product product, int quantity) {
    final existingItem = items.firstWhere(
      (item) => item.id == product.id.toString(),
      orElse: () => CartItemModel(
        id: product.id.toString(),
        title: product.title ?? '',
        author: product.author ?? '',
        imageUrl: product.imageUrl ?? '',
        price: product.price ?? 0,
        quantity: 0,
      ),
    );

    // Update quantity if item already exists, otherwise add new item
    if (existingItem.quantity == 0) {
      items.add(existingItem.copyWith(quantity: quantity));
    } else {
      final index =
          items.indexWhere((item) => item.id == product.id.toString());
      items[index] =
          existingItem.copyWith(quantity: existingItem.quantity + quantity);
    }

    // Recalculate totals after modification
    _recalculateTotals();
  }

  // Public method to recalculate totals
  void recalculateTotals() {
    _recalculateTotals();
  }

  // Private method to calculate subtotal and total price
  void _recalculateTotals() {
    subtotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
    totalPrice = subtotal + shippingFee;
  }
}

class CartItemModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, title, author, imageUrl, price, quantity];

  // Create a new CartItemModel with modified values
  CartItemModel copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      imageUrl: json['imageUrl'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_event.dart';
import 'package:flutter_web_fe/blocs/cart/cart_state.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';

class AddCart extends StatefulWidget {
  final Product product;
  final int quantity;

  const AddCart({
    super.key,
    required this.product,
    this.quantity = 1,
  });

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  void _addToCart() {
    if (widget.product.price != null &&
        widget.product.title != null &&
        widget.product.author != null &&
        widget.product.imageUrl != null) {
      context.read<CartBloc>().add(CartItemAdded(
            CartItemModel(
              id: widget.product.id.toString(),
              title: widget.product.title!,
              author: widget.product.author!,
              imageUrl: widget.product.imageUrl!,
              price: widget.product.price!,
              quantity: widget.quantity,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Không thể thêm sản phẩm vào giỏ hàng. Thông tin sản phẩm không hợp lệ.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) => current is CartLoaded,
      listener: (context, state) {
        if (state is CartLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm "${widget.product.title}" vào giỏ hàng'),
              action: SnackBarAction(
                label: 'XEM GIỎ HÀNG',
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: _addToCart,
          child: const Text('Thêm vào giỏ hàng'),
        );
      },
    );
  }
}

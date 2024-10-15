import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_bloc.dart';
import 'package:flutter_web_fe/blocs/cart/cart_event.dart';
import 'package:flutter_web_fe/blocs/cart/cart_state.dart';
import 'package:flutter_web_fe/core/data/models/cart_model.dart';
import 'package:flutter_web_fe/presentation/components/header_desktop.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(CartStarted());

    return Scaffold(
      body: Column(
        children: [
          const HeaderDesktop(),
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CartLoaded) {
                  return _buildCartContent(context, state.cart);
                } else if (state is CartNotAuthenticated) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Vui lòng đăng nhập để xem giỏ hàng'),
                        ElevatedButton(
                          onPressed: () {
                            // Điều hướng đến trang đăng nhập
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text('Đăng nhập'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CartError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đã xảy ra lỗi: ${state.message}'),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CartBloc>().add(CartStarted()),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('Đã xảy ra lỗi không xác định'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartModel cart) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giỏ hàng của bạn',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                if (cart.items.isEmpty)
                  _buildEmptyCart(context)
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildCartHeader(),
                            ..._buildCartItems(context, cart),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildOrderSummary(context, cart),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text('Giỏ hàng của bạn đang trống',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, '/products'); // Điều hướng đến trang sản phẩm
            },
            child: const Text('Tiếp tục mua sắm'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Sản phẩm')),
          Expanded(child: Text('Giá')),
          Expanded(child: Text('Số lượng')),
          Expanded(child: Text('Tổng cộng')),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  List<Widget> _buildCartItems(BuildContext context, CartModel cart) {
    return cart.items.map((item) => _buildCartItem(context, item)).toList();
  }

  Widget _buildCartItem(BuildContext context, CartItemModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Image.network(item.imageUrl,
                    width: 80, height: 120, fit: BoxFit.cover),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(item.author,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Text('${item.price} đ')),
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => context
                      .read<CartBloc>()
                      .add(CartItemQuantityChanged(item.id, item.quantity - 1)),
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context
                      .read<CartBloc>()
                      .add(CartItemQuantityChanged(item.id, item.quantity + 1)),
                ),
              ],
            ),
          ),
          Expanded(child: Text('${item.price * item.quantity} đ')),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                context.read<CartBloc>().add(CartItemRemoved(item.id)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartModel cart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tóm tắt đơn hàng',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildSummaryRow('Tổng tiền hàng:', '${cart.subtotal} đ'),
            _buildSummaryRow('Phí vận chuyển:', '${cart.shippingFee} đ'),
            const Divider(),
            _buildSummaryRow('Tổng cộng:', '${cart.totalPrice} đ',
                isTotal: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Xử lý thanh toán
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Tiến hành thanh toán'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Điều hướng đến trang sản phẩm
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Tiếp tục mua sắm'),
            ),
            ElevatedButton(
              onPressed: () => context.read<CartBloc>().add(CartCleared()),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa tất cả'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

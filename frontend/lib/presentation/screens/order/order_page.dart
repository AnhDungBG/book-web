// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_bloc.dart';
import 'package:flutter_web_fe/blocs/product/product_event.dart';
import 'package:flutter_web_fe/blocs/product/product_sate.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_event.dart';
import 'package:flutter_web_fe/blocs/checkout/checkout_state.dart';
import 'package:flutter_web_fe/presentation/screens/orderSuccess/order_confirm.dart';

class OrderPage extends StatefulWidget {
  final String productId;
  final int quantity;

  const OrderPage({
    super.key,
    required this.productId,
    required this.quantity,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String paymentMethod = '3';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductDetail(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailLoaded) {
            final product = state.product;

            return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: 900,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .shade300, // Your custom shadow color
                                    offset:
                                        const Offset(0, 5), // Shadow position
                                    blurRadius: 10, // Softness of the shadow
                                    spreadRadius: 0, // Size of the shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Center(
                                    child: Image.network(
                                      product.imageUrl ?? '',
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        'Tên sản phẩm: ${product.title}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                          'Tác giả: ${product.author ?? 'Không có thông tin'}'),
                                      Text(
                                          'Giá: \$${product.price?.toStringAsFixed(2)}'),
                                      Text('Số lượng: ${widget.quantity}'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 19),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DropdownButton<String>(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                  value: paymentMethod,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      paymentMethod = newValue!;
                                    });
                                  },
                                  items: <String>['1', '2', '3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text('Phương thức $value'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Beamer.of(context).beamBack();
                                    },
                                    child: const Text('Quay lại ')),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<CheckoutBloc>()
                                        .add(CheckoutSubmitted(
                                          productId: product.id,
                                          quantity: widget.quantity,
                                          paymentMethod: paymentMethod,
                                        ));

                                    context
                                        .read<CheckoutBloc>()
                                        .stream
                                        .listen((state) {
                                      if (state is CheckoutSuccess) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderConfirmationPage(
                                              orderId:
                                                  state.orderDetail.orderId,
                                              orderDate:
                                                  state.orderDetail.orderDate,
                                              deliveryAddress: state
                                                  .orderDetail.deliveryAddress,
                                              paymentStatus: state
                                                  .orderDetail.paymentStatus,
                                              paymentMethod: state
                                                  .orderDetail.paymentMethod,
                                              phoneNumber:
                                                  state.orderDetail.phoneNumber,
                                              productId:
                                                  state.orderDetail.productId,
                                              quantity:
                                                  state.orderDetail.quantity,
                                              unitPrice:
                                                  state.orderDetail.unitPrice,
                                            ),
                                          ),
                                        );
                                      } else if (state is CheckoutError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Lỗi khi xác nhận thanh toán: ${state.message}')),
                                        );
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                  ),
                                  child: const Text('Xác nhận mua hàng '),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          } else if (state is ProductError) {
            return Center(child: Text('Lỗi: ${state.errorMessage}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

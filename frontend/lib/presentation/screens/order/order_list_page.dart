import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_fe/blocs/order/order_bloc.dart';
import 'package:flutter_web_fe/blocs/order/order_event.dart';
import 'package:flutter_web_fe/blocs/order/order_state.dart';
import 'package:flutter_web_fe/core/data/models/my_order_model.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrderListLoaded) {
                // Orders successfully loaded
                final orders = state.orderLists;
                return constraints.maxWidth > 600
                    ? buildDesktopLayout(orders)
                    : buildMobileLayout(orders);
              } else if (state is OrderError) {
                return Center(
                    child: Text('Error loading orders: ${state.message}'));
              } else {
                return const Center(child: Text('No orders available'));
              }
            },
          );
        },
      ),
    );
  }

// Build desktop layout
  Widget buildDesktopLayout(List<Order> orders) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: orders.isEmpty
          ? const Center(child: Text('No orders available'))
          : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Customer ID')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Delivery Address')),
                  DataColumn(label: Text('Payment Status')),
                  DataColumn(label: Text('Total Price')),
                  DataColumn(label: Text('Action')), // Cột cho nút hủy
                ],
                rows: _buildDataRows(orders),
              ),
            ),
    );
  }

// Helper method to create data rows
  List<DataRow> _buildDataRows(List<Order> orders) {
    return orders.map(
      (order) {
        return DataRow(
          cells: [
            DataCell(Text(order.khachhang.toString())),
            DataCell(Text(order.ngaydat)),
            DataCell(Text(order.noigiao)),
            DataCell(Text(order.trangthaiThanhtoan ? 'Paid' : 'Unpaid')),
            DataCell(Text(order.dongia)),
            DataCell(
              ElevatedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(CancelOrder(order.id));
                },
                child: const Text('Hủy'),
              ),
            ),
          ],
        );
      },
    ).toList();
  }

  Widget buildMobileLayout(List<Order> orders) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: orders.isEmpty
          ? const Center(child: Text('No orders available'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: ${order.id}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Customer ID: ${order.khachhang}'),
                        Text('Date: ${order.ngaydat}'),
                        Text('Delivery Address: ${order.noigiao}'),
                        Text(
                            'Payment Status: ${order.trangthaiThanhtoan ? 'Paid' : 'Unpaid'}'),
                        Text('Total Price: ${order.dongia}'),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<OrderBloc>()
                                .add(CancelOrder(order.id));
                          },
                          child: const Text('Hủy'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatefulWidget {
  final void Function(String?) onChanged;

  const PaymentMethodSelector({super.key, required this.onChanged});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Thanh toán khi nhận hàng'),
          value: 'COD',
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() => _selectedMethod = value);
            widget.onChanged(value);
          },
        ),
        RadioListTile<String>(
          title: const Text('Chuyển khoản ngân hàng'),
          value: 'BankTransfer',
          groupValue: _selectedMethod,
          onChanged: (value) {
            setState(() => _selectedMethod = value);
            widget.onChanged(value);
          },
        ),
        // Thêm các phương thức thanh toán khác ở đây
      ],
    );
  }
}

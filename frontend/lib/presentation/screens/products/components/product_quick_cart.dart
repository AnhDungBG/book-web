import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/data/models/book_model.dart';

class ProductQuickCart extends StatelessWidget {
  final Product product;
  const ProductQuickCart({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Image.network(
                '${product.imageUrl}',
                width: 60,
                height: 60,
              )),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text('${product.title}'),
                Text('Tác giả : ${product.author}'),
                Row(
                  children: [
                    Text('${product.price} ?? '),
                    Text('${product.promotion}')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

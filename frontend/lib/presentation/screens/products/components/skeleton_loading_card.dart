import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardSkeleton extends StatelessWidget {
  final bool isSimpleView;

  const ProductCardSkeleton({super.key, this.isSimpleView = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSimpleView ? 2 : 0,
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(192, 224, 224, 224),
        highlightColor: Colors.grey[100]!,
        child: isSimpleView ? _buildSimpleView() : _buildDetailedView(),
      ),
    );
  }

  Widget _buildSimpleView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 14,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedView() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 18,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 120,
                  height: 17,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 80,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

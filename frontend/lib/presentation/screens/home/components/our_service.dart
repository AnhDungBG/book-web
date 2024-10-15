import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            color: CustomColor.softCyan,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildService(context, 'Return & refund', 'Money back guarantee',
                Icons.monetization_on),
            _buildService(context, 'Free Shipping', 'Orders over \$200',
                Icons.local_shipping),
            _buildService(
                context, '24/7 Support', 'Customer service', Icons.headset_mic),
            _buildService(
                context, 'Secure Payment', 'Safe & Trustworthy', Icons.security)
          ],
        ),
      ),
    );
  }

  Widget _buildService(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: CustomColor.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 40,
              color: CustomColor.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.secondBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColor.secondBlue,
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

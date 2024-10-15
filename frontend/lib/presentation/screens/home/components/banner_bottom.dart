import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class BannerBottom extends StatelessWidget {
  const BannerBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 100),
      decoration: const BoxDecoration(
          color: CustomColor.primaryBlue,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/banner_bottom.png',
            ),
          )),
      child: const Row(
        children: [
          Spacer(),
          Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _BannerContent(),
                ),
              )),
          Spacer(),
        ],
      ),
    );
  }
}

class _BannerContent extends StatelessWidget {
  const _BannerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Get 25% Discount In All\nKind Of Super Selling',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: CustomColor.textDarkGray,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/products');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.teal,
            backgroundColor: CustomColor.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shop Now',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

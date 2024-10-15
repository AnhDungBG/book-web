import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class SiteLogo extends StatelessWidget {
  const SiteLogo({
    super.key,
    this.onTab,
  });
  final VoidCallback? onTab;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: onTab,
          child: Row(
            children: [
              const Icon(
                Icons.menu_book_sharp,
                size: 46,
                color: Colors.white,
              ),
              Container(
                width: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 80,
                color: CustomColor.lightBlue,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Book',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Store',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          )),
    );
  }
}

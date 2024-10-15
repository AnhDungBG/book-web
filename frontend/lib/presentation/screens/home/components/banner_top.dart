import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class CustomBannerTop extends StatefulWidget {
  const CustomBannerTop({super.key});

  @override
  State<CustomBannerTop> createState() => _CustomBannerTopState();
}

class _CustomBannerTopState extends State<CustomBannerTop>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _textController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _textAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_textController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const headerHeight = 90.0;
    final bannerHeight = screenSize.height - headerHeight;

    return Container(
      height: bannerHeight,
      width: screenSize.width,
      decoration: const BoxDecoration(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: const BoxDecoration(
          color: CustomColor.softCyan,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final offsetY = 10 * (2 * _animation.value - 1).abs();
                        return Transform.translate(
                          offset: Offset(0, offsetY),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: const [
                                CustomColor.white,
                                CustomColor.neutralGray
                              ],
                              stops: [_animation.value, _animation.value + 0.1],
                            ).createShader(bounds),
                            child: const Text(
                              'Up To 30% Off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _textAnimation,
                      builder: (context, child) {
                        final shimmerValue =
                            ((_textAnimation.value + 1) / 2).clamp(0.0, 1.0);
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: const [
                                CustomColor.white,
                                CustomColor.warmBrown,
                                CustomColor.softGreen,
                              ],
                              stops: [
                                0.0,
                                shimmerValue,
                                shimmerValue + 0.2,
                              ],
                              tileMode: TileMode.clamp,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Get Your New Book\nWith The Best Price',
                            style: TextStyle(
                              color: CustomColor.secondBlue,
                              fontSize: 74,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final scale =
                            1 + 0.1 * (2 * _animation.value - 1).abs();
                        return Transform.scale(
                          scale: scale,
                          child: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              bool isHovered = false;
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => isHovered = true),
                                onExit: (_) =>
                                    setState(() => isHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: isHovered
                                      // ignore: dead_code
                                      ? Matrix4.identity().scaled(1.05)
                                      : Matrix4.identity(),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Beamer.of(context)
                                          .beamToNamed('/products');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHovered
                                          // ignore: dead_code
                                          ? CustomColor.primaryBlue
                                          : Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'Shop Now →',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: isHovered
                                            // ignore: dead_code
                                            ? Colors.white
                                            : CustomColor.neutralGray,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(
                height: 500,
                child: Image(
                  image: AssetImage('assets/images/banner_image_books.png'),
                ),
              ),
            ),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}

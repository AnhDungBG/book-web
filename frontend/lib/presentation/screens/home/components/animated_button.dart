import 'package:flutter/material.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class _GradientPainter extends CustomPainter {
  final double progress;
  final BorderRadius borderRadius;

  _GradientPainter({required this.progress, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [CustomColor.neutralGray, CustomColor.coolGray],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final path = Path()..addRRect(rect);

    final clipPath = Path()
      ..addRect(Rect.fromLTRB(0, 0, size.width * progress, size.height));
    final finalPath = Path.combine(PathOperation.intersect, path, clipPath);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomButton extends StatefulWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.title,
    this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double defaultWidth = 200;
    const double defaultHeight = 50;
    const double defaultFontSize = 19;
    const double defaultIconSize = 24;

    final double buttonWidth = widget.width ?? defaultWidth;
    final double buttonHeight = widget.height ?? defaultHeight;
    final double buttonFontSize = widget.fontSize ?? defaultFontSize;
    final double buttonIconSize = widget.iconSize ?? defaultIconSize;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _GradientPainter(
              progress: _animation.value,
              borderRadius: BorderRadius.circular(buttonHeight / 2),
            ),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              padding: EdgeInsets.symmetric(horizontal: buttonHeight * 0.3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColor.coolGray,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(buttonHeight / 2),
              ),
              child: InkWell(
                onTap: widget.onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: _isHovered
                              ? Colors.white
                              : CustomColor.textDarkGray,
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: buttonHeight * 0.16),
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: _isHovered
                            ? Colors.white
                            : CustomColor.textDarkGray,
                        size: buttonIconSize,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

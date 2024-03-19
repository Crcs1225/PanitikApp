import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  final Color color;
  final double dotSpacing;
  final double dotSize;

  const LoadingDots({
    Key? key,
    this.color = const Color.fromRGBO(139, 69, 19, 1.0),
    this.dotSpacing = 12, // Increased spacing
    this.dotSize = 8, // Increased dot size
  }) : super(key: key);

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(right: i == 2 ? 0 : widget.dotSpacing),
                child: Opacity(
                  opacity: _controller.value < 0.33 * (i + 1) ? 0.25 : 1.0,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class CustomMarker extends StatefulWidget {
  const CustomMarker({Key? key}) : super(key: key);

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();
  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.6, end: 1).animate(_controller);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1, end: 0.2).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 20 * 1.5,
              height: 20 * 1.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.green.shade300),
            ),
          ),
        ),
        Icon(
          Icons.circle,
          size: 20,
          color: Colors.green,
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

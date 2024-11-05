import 'package:flutter/material.dart';
import 'dart:math';

class WaterDroppingAnimation extends StatefulWidget {
  @override
  _WaterDroppingAnimationState createState() => _WaterDroppingAnimationState();
}

class _WaterDroppingAnimationState extends State<WaterDroppingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _dropletController;
  late AnimationController _waveController;
  double _progress = 0.2; // Initial water level

  @override
  void initState() {
    super.initState();

    // Droplet animation controller for the falling motion
    _dropletController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Trigger wave animation when the droplet hits the water
        _waveController.forward(from: 0);
        setState(() {
          _progress += 0.05; // Increment water level with each drop
          if (_progress > 1.0) _progress = 0.2; // Reset or limit water level
        });
      }
    });

    // Wave animation controller for the ripple effect
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _dropletController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Water Drop Animation with Clear Waves')),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Jar and water level with wave effect
            CustomPaint(
              size: const Size(400, 600),
              painter: JarWithClearWavePainter(_progress, _waveController),
            ),
            // Falling droplet animation
            AnimatedBuilder(
              animation: _dropletController,
              builder: (context, child) {
                double dropPosition = _dropletController.value * 500;
                return Positioned(
                  top: dropPosition,
                  child: Opacity(
                    opacity: _dropletController.value < 1.0 ? 1 : 0,
                    child: Icon(Icons.circle, size: 50, color: Colors.blueAccent),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Restart droplet animation on button press
          _dropletController.forward(from: 0);
        },
        child: Icon(Icons.water_drop),
      ),
    );
  }
}

class JarWithClearWavePainter extends CustomPainter {
  final double progress;
  final Animation<double> waveAnimation;

  JarWithClearWavePainter(this.progress, this.waveAnimation) : super(repaint: waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent.withOpacity(0.7);
    final waveHeight = 12.0;  // Higher amplitude for clearer waves
    final waveFrequency = 5.0; // Increased frequency for more ripples
    final waterLevel = size.height * (1 - progress);

    // Draw jar
    final jarRect = Rect.fromLTWH(50, 50, size.width - 100, size.height - 100);
    canvas.drawRect(jarRect, paint..color = Colors.grey.shade300);

    // Draw water level
    paint.color = Colors.blue.withOpacity(0.7);
    canvas.drawRect(
      Rect.fromLTWH(jarRect.left, waterLevel, jarRect.width, size.height - waterLevel),
      paint,
    );

    // Draw wave ripple effect with clearer, defined ripples
    for (double i = 0; i < jarRect.width; i += 2) {
      final waveY = waterLevel +
          sin((i / jarRect.width * waveFrequency * pi) + waveAnimation.value * pi) *
              waveHeight *
              (1 - waveAnimation.value); // Gradually fades out the waves
      canvas.drawLine(
        Offset(jarRect.left + i, waveY),
        Offset(jarRect.left + i, waterLevel),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

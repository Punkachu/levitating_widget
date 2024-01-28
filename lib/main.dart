import 'dart:ui';

import 'package:flutter/material.dart';

import 'levitating_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Floating Widget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          backgroundColor: const Color(0xFF00258D),
          appBar: AppBar(
            title: const Text(
              "Vibing In the Floating Space",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          body: _generateGrid()),
    );
  }

  Widget _generateGrid() {
    final List<IconData> icons = [
      Icons.add,
      Icons.account_circle_outlined,
      Icons.access_time_sharp,
      Icons.add_circle_outline,
      Icons.radar_rounded,
      Icons.radio,
      Icons.connected_tv_sharp,
      Icons.accessible_rounded,
      Icons.person,
      Icons.face,
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 10, // Number of items in the grid
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: LevitatingWidget(
                      topOffsetAnimation: Offset(0.2, 0.5 + (index / 100)),
                      leftOffsetAnimation:
                          Offset(0.1 + (index / 2 / 100), 0.5 + (index / 100)),
                      animationLeftDuration:
                          Duration(milliseconds: 500 + (index * 100)),
                      animationTopDuration:
                          Duration(milliseconds: 1000 + (index * 100)),
                      widget: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            painter: CustomRoundShape(
                              80,
                              gradientColors: const [
                                Color(0xff4d4dff),
                                Color(0xff400080),
                              ],
                            ),
                          ),
                          Icon(icons.elementAt(index),
                              size: 50, color: Colors.white),
                        ],
                      )),
                ),
                //const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 22,
                      sigmaY: 22,
                    ),

                    /// Filter effect field
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Item $index',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomRoundShape extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;

  CustomRoundShape(this.radius,
      {this.gradientColors = const [
        Color(0xff4d4dff),
        Color(0xff400080),
      ]});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromCircle(
        center: const Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

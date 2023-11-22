import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo'),
      home: const WidgetTreeLayout(),
    );
  }
}

class WidgetTreeLayout extends StatefulWidget {
  const WidgetTreeLayout({super.key});

  @override
  State<WidgetTreeLayout> createState() => _WidgetTreeLayoutState();
}

class _WidgetTreeLayoutState extends State<WidgetTreeLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomPaint(
          painter: _ConnectionPainter(),
          // size: const Size(60, double.infinity),
        ),
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    late double heightOfLine; // Untuk ukuran lebar height
    late Offset endOfLine; // Untuk titik akhir dengan x dan y

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2;

    final circlePaint = Paint()
      ..color = Colors.blue.shade800
      ..style = PaintingStyle.fill;

    final path = Path();

    heightOfLine = 40;
    endOfLine = Offset(50, heightOfLine);

    path.moveTo(15, 0);
    path.lineTo(15, heightOfLine - 20);
    path.arcToPoint(Offset(30, heightOfLine),
        radius: const Radius.circular(25), clockwise: false);
    path.lineTo(endOfLine.dx, endOfLine.dy);
    canvas.drawPath(path, linePaint);
    canvas.drawOval(
        Rect.fromCenter(center: endOfLine, width: 10, height: 10), circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

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
  final keys = <GlobalKey>[];
  late List<Widget> children;

  @override
  void initState() {
    children = [
      const Text("data"),
      Row(
        children: [
          Checkbox(value: true, onChanged: (value) {}),
          const Text('data'),
        ],
      ),
      const IntrinsicWidth(
        child: ExpansionTile(
          title: Text('data'),
          children: [
            Text('data'),
          ],
        ),
      )
    ];

    keys.addAll(List.generate(children.length, (index) => GlobalKey()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            CustomPaint(
              painter: _ConnectionPainter(keys),
              size: const Size(100, double.infinity),
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                for (int i = 0; i < children.length; i++) ...{
                  Container(
                    key: keys[i],
                    child: children[i],
                  ),
                }
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  final List<GlobalKey> keys;
  _ConnectionPainter(this.keys);
  @override
  void paint(Canvas canvas, Size size) {
    double firstOffset = -1;
    late double heightOfLine; // Untuk ukuran lebar height
    late Offset endOfLine; // Untuk titik akhir dengan x dan y

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2;

    final circlePaint = Paint()
      ..color = Colors.blue.shade800
      ..style = PaintingStyle.fill;

    for (final key in keys) {
      final path = Path();

      RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      Size widgetSize = renderBox.size;
      Offset widgetPosition = renderBox.localToGlobal(Offset.zero);

      heightOfLine = widgetPosition.dy - firstOffset + widgetSize.height / 2;
      endOfLine = Offset(size.width * 0.8, heightOfLine);

      path.moveTo(15, 0);
      path.lineTo(15, heightOfLine - 20);
      path.arcToPoint(
        Offset(30, heightOfLine),
        radius: const Radius.circular(25),
        clockwise: false,
      );
      path.lineTo(endOfLine.dx, endOfLine.dy);

      // Menggabar sekujur garis
      canvas.drawPath(path, linePaint);

      // Menggabar titi bulat di widget
      canvas.drawOval(Rect.fromCenter(center: endOfLine, width: 10, height: 10),
          circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

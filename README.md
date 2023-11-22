# widget_tree_practice

The Final result would be like this:
![WhatsApp Video 2023-11-22 at 22 29 01](https://user-images.githubusercontent.com/54527045/284968584-052f522e-3d21-47a2-b3b2-2dd7e45d6075.gif)

The source: https://github.com/inyong1/custompaint_widgettree/blob/main/lib/main.dart

## Getting Started
1. Bagian pertama, coba gambar lengkung garis yang ingin digunakan
```dart
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
```

Dan implement dengan menggunakan `CustomPaint`.
```dart
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
          size: const Size(60, double.infinity),
        ),
      ),
    );
  }
}
```
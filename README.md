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

    // Would be set later. Just dummy right now
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

2. Mencoba menambahkan widget agar berada di sebelah garis. Dan menyesuai dengan titik pada custom paint.
Buat `GlobalKey` agar dipasangkan ke widget yang ingin dipasangkan di sebelah garis. 

Sebelum itu, bungkus CustomPaint dalam row, dan tambahkan widget yang dipasangkan di kiri baris.
Sekedar tips, gunakan column untuk tetap menjaga widget disamping garis tetap di atas. Dan tambahkan Sizedbox
untuk menambah space/margin antara bagian atas dengan widget
```dart
class WidgetTreeLayout extends StatefulWidget {
  const WidgetTreeLayout({super.key});

  @override
  State<WidgetTreeLayout> createState() => _WidgetTreeLayoutState();
}

class _WidgetTreeLayoutState extends State<WidgetTreeLayout> {
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            CustomPaint(
              painter: _ConnectionPainter(key),
              size: const Size(100, double.infinity),
            ),
            Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    key: key,
                    child: const Text('Test'),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
```

Pada class _ConnectionPainter, buat variable di consturctor dengan tipe GlobalKey.
```dart
class _ConnectionPainter extends CustomPainter {
  final GlobalKey key;
  _ConnectionPainter(this.key);
  
  ....
}
```

Dengan constructer ini, Globalkey yang dipasangkan ke suatu widget bisa di taruh di constructer class ini.  Setelah ditaruh widget informasi widget seperti size dan positionnya bisa diakses di kelas ini dengan memanggil __RenderBox__ dari key tersebut.
```dart
  ...
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    Size widgetSize = renderBox.size;
    Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
  ...
```

Lalu dengan menggunakan informasi ini, variable `heightOfLine` dan `endOfLine` bisa diubah dari dummy ke kalkulasi dari informasi dari RenderBox tersebut.
```dart
  ...
    heightOfLine = widgetPosition.dy - firstOffset + widgetSize.height / 2;
    endOfLine = Offset(size.width * 0.8, heightOfLine);
  ...
```

3. Menyoba menyisipkan widget lebih dari 1.
Pada `WidgetTreeLayout` (dalam `_WidgetTreeLayoutState` lebih tepatnya) tambahkan variable baru untuk kebutuhan multple widgetnya
```dart
  final keys = <GlobalKey>[];
  late List<Widget> children;
```

Kemudian dibagian init state, coba tambahkan dummy widget yang akan di set di variable childrennya.
```dart
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
```

Kemudian pindah ke `_ConnectionPainter` untuk mengganti variabel dari single GlobalKey ke 
`List<GlobalKey>` dan bungkus bagian variable path sampai drawOval dengan `for` untuk melakukan looping drawnya sesuai dengan banyak key dari varibale.

```dart
  for (final key in keys) {
    final path = Path();
    ....
    canvas.drawOval(Rect.fromCenter(center: endOfLine, width: 10, height: 10),
        circlePaint);
  }
```

Lalu implementasikan di `WidgetTreeLayout`
```dart
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
```
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Tıklanma olayı
      onTap: widget.onTap,

      // Hover (fare üstüne geldiğinde) olayı
      onHover: (hovering) {
        setState(() {
          isHovered = hovering;
        });
      },

      // İmlecin üzerindeyken tıklanabileceğini belli etmek için.
      mouseCursor: SystemMouseCursors.click,

      // Hover ve tıklama renkleri
      hoverColor: Colors.white.withOpacity(0.1),
      splashColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.2),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // Kart merkezden büyüsün
        transformAlignment: Alignment.center, // <-- Ekledik
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),

        // Hover olunca gölge ekleyebilirsiniz
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white.withOpacity(0.2),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
          // Arka plan resmi
          image: DecorationImage(
            image: AssetImage(widget.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 9.0,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

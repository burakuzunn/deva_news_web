import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size; // Görselin boyutunu kontrol etmek için

  const AppNetworkImage({
    Key? key,
    required this.imageUrl,
    this.size = 100.0, // Varsayılan boyut
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

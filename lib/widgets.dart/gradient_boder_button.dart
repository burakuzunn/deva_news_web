import 'dart:math' as math;
import 'package:flutter/material.dart';

class GradientBorderButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isButtonEnabled;
  final String text;

  const GradientBorderButton({
    Key? key,
    required this.onPressed,
    required this.isButtonEnabled,
    required this.text,
  }) : super(key: key);

  @override
  _GradientBorderButtonState createState() => _GradientBorderButtonState();
}

class _GradientBorderButtonState extends State<GradientBorderButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Uygulama ilk açıldığında buton aktifse animasyonu başlatalım
    if (widget.isButtonEnabled) {
      _controller.repeat();
    }
  }

  /// Widget yeniden oluşturulurken (örneğin buton aktif/pasif durumu değişirken)
  /// animasyonu yönetmek için didUpdateWidget kullanıyoruz.
  @override
  void didUpdateWidget(covariant GradientBorderButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Yeni durum aktif ve önceki durumda animasyon oynatılmıyorsa, animasyonu başlat
    if (widget.isButtonEnabled && !_controller.isAnimating) {
      _controller.repeat();
    }

    // Yeni durum pasif ve önceki durumda animasyon oynuyorsa, animasyonu durdur
    else if (!widget.isButtonEnabled && _controller.isAnimating) {
      _controller.stop();
    }
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
        return Container(
          // Kenarlarda animasyonlu bir “sweep gradient” oluşturuyoruz
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // SweepGradient dönme hareketini 'GradientRotation' ile sağlıyoruz
            gradient: SweepGradient(
              startAngle: 0.0,
              endAngle: 2 * math.pi,
              colors: [
                widget.isButtonEnabled ? Colors.purpleAccent : Colors.transparent,
                widget.isButtonEnabled ? Colors.deepPurple : Colors.transparent,
                widget.isButtonEnabled ? Colors.purpleAccent : Colors.transparent,
              ],
              // Buton aktif değilse animasyonu durdurduğumuz için
              // `_controller.value` sabit kalacak veya 0 konumuna dönecek
              // Buton aktifleştirilince yeniden dönmeye başlar.
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ),
          ),
          // border kalınlığı hissi vermek için biraz padding
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            // Asıl butonu burada çiziyoruz
            child: ElevatedButton(
              onPressed: widget.isButtonEnabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  // Asıl “border” bu sefer düz veriliyor çünkü
                  // animasyonu dış kapsayıcıda sağlıyoruz
                  side: const BorderSide(color: Colors.transparent, width: 2.0),
                ),
                shadowColor: Colors.purple.withOpacity(0.5),
                elevation: 20,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "inter",
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RandomProgressIndicatorExample extends StatefulWidget {
  const RandomProgressIndicatorExample(this.onComplete, {super.key});
  final Function onComplete;

  @override
  State<RandomProgressIndicatorExample> createState() => _RandomProgressIndicatorExampleState();
}

class _RandomProgressIndicatorExampleState extends State<RandomProgressIndicatorExample> with SingleTickerProviderStateMixin {
  bool isLoading = true; // Ekran açılınca yükleme animasyonu gözüksün
  bool showData = false; // Yükleme bitince verileri göstermek için
  double progressValue = 0; // 0 ile 1 arası değer
  late double randomTime; // 2 - 5 saniye arası dolum süresi

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 2 ile 5 arasında rastgele saniye seç
    randomTime = 2 + Random().nextDouble() * 5; // 2..5 arası

    // AnimationController oluştur
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: randomTime.toInt()),
    );

    // 0.0'dan 1.0'a kadar değer üreten bir Tween tanımla
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        // Her frame'de progressValue'yu güncelle
        setState(() {
          progressValue = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animasyon bittiğinde
          setState(() {
            isLoading = false;
            showData = true;
            widget.onComplete();
          });
        }
      });

    // Animasyonu başlat
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // belleği temizlemeyi unutmayalım
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sadece progress bar gösteriyoruz; isterseniz Lottie de ekleyebilirsiniz
              LinearPercentIndicator(
                lineHeight: 28.0,
                animation: false,
                percent: progressValue,
                backgroundColor: Colors.grey.shade300,
                linearGradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                ),
                barRadius: const Radius.circular(10),
                center: Text(
                  "${(progressValue * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

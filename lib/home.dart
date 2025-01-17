import 'dart:ui';
import 'package:deva_news_web/data..dart';
import 'package:deva_news_web/news..dart';
import 'package:deva_news_web/widgets.dart/auto_generate.dart';
import 'package:deva_news_web/widgets.dart/category_item.dart';
import 'package:deva_news_web/widgets.dart/gradient_boder_button.dart';
import 'package:deva_news_web/widgets.dart/lineer_percent.dart';
import 'package:deva_news_web/widgets.dart/network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isButtonEnabled = false;
  bool showData = false; // DataSection görünür mü?
  bool isLoading = false; // Yükleniyor mu?
  Map<String, dynamic>? news;
  Map<String, dynamic>? medical;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Ekranın yarısı
          double baseWidth = constraints.maxWidth * 0.5;
          // DataSection görünürse 3 katı
          double targetWidth = showData ? baseWidth * 3 : baseWidth;
          // Yüksekliği sabit (örnek) = %90
          double containerHeight = constraints.maxHeight * 0.9;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF24243E),
                  Color.fromARGB(255, 63, 59, 109),
                  Color(0xFF0F0C29),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  width: targetWidth,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: isLoading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                ),
                                LottieBuilder.asset("assets/loadin.json"),
                                const SizedBox(height: 50),
                                RandomProgressIndicatorExample(() {
                                  setState(() {
                                    isLoading = false;
                                    showData = true;
                                  });
                                })
                              ],
                            )
                          : (showData
                              ? DataSection(
                                  news: news ?? {},
                                  medicals: medical ?? {},
                                  setState: () => setState(() {
                                        isLoading = false;
                                        showData = false;
                                      }))
                              : _buildMainContent()),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "DevaAI",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  flex: 7,
                  child: NewsAutocomplete(
                    onComplete: (selectedNews, randomIlac, randomGroupId) {
                      setState(() {
                        _isButtonEnabled = true;
                      });
                      news = selectedNews;
                      medical = randomIlac;
                      print(randomIlac);
                      print(randomGroupId);
                      print(selectedNews);
                    },
                  )),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: GradientBorderButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  isButtonEnabled: _isButtonEnabled,
                  text: "Fetch the related news...",
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          // Kategoriler
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              double childAspectRatio = constraints.maxWidth > 600 ? 1.2 : 1.0;
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: childAspectRatio * 1.2,
                children: [
                  // --- SPOR ---
                  CategoryItem(
                    title: 'Sport',
                    imageUrl: 'assets/sports.jpg',
                    onTap: () {
                      setState(() {
                        final filteredNews = newsData.where((item) => item["category"] == 0).toList();

                        if (filteredNews.isNotEmpty) {
                          filteredNews.shuffle();
                          final selectedNews = filteredNews.first;

                          final List<int> groupList = List<int>.from(selectedNews["groupList"]);
                          final matchedIlacList = ilaclar.where((ilac) => groupList.contains(ilac["group"])).toList();

                          if (matchedIlacList.isNotEmpty) {
                            matchedIlacList.shuffle();
                            final filteredIlac = matchedIlacList.first;

                            news = selectedNews;
                            medical = filteredIlac;
                            isLoading = true;
                          } else {}
                        } else {}
                      });
                    },
                  ),

                  // --- SEYAHAT ---
                  CategoryItem(
                    title: 'Travel',
                    imageUrl: 'assets/travel.jpg',
                    onTap: () {
                      setState(() {
                        final filteredNews = newsData.where((item) => item["category"] == 1).toList();

                        if (filteredNews.isNotEmpty) {
                          filteredNews.shuffle();
                          final selectedNews = filteredNews.first;

                          final List<int> groupList = List<int>.from(selectedNews["groupList"]);
                          final matchedIlacList = ilaclar.where((ilac) => groupList.contains(ilac["group"])).toList();

                          if (matchedIlacList.isNotEmpty) {
                            matchedIlacList.shuffle();
                            final filteredIlac = matchedIlacList.first;

                            news = selectedNews;
                            medical = filteredIlac;
                            isLoading = true;
                          } else {}
                        } else {}
                      });
                    },
                  ),

                  // --- TARİH ---
                  CategoryItem(
                    title: 'History',
                    imageUrl: 'assets/history.jpg',
                    onTap: () {
                      setState(() {
                        final filteredNews = newsData.where((item) => item["category"] == 2).toList();

                        if (filteredNews.isNotEmpty) {
                          filteredNews.shuffle();
                          final selectedNews = filteredNews.first;

                          final List<int> groupList = List<int>.from(selectedNews["groupList"]);
                          final matchedIlacList = ilaclar.where((ilac) => groupList.contains(ilac["group"])).toList();

                          if (matchedIlacList.isNotEmpty) {
                            matchedIlacList.shuffle();
                            final filteredIlac = matchedIlacList.first;

                            news = selectedNews;
                            medical = filteredIlac;
                            isLoading = true;
                          } else {}
                        } else {}
                      });
                    },
                  ),

                  // --- HOBİ ---
                  CategoryItem(
                    title: 'Hobby',
                    imageUrl: 'assets/hobies.jpg',
                    onTap: () {
                      setState(() {
                        final filteredNews = newsData.where((item) => item["category"] == 3).toList();

                        if (filteredNews.isNotEmpty) {
                          filteredNews.shuffle();
                          final selectedNews = filteredNews.first;

                          final List<int> groupList = List<int>.from(selectedNews["groupList"]);
                          final matchedIlacList = ilaclar.where((ilac) => groupList.contains(ilac["group"])).toList();

                          if (matchedIlacList.isNotEmpty) {
                            matchedIlacList.shuffle();
                            final filteredIlac = matchedIlacList.first;

                            news = selectedNews;
                            medical = filteredIlac;
                            isLoading = true;
                          } else {}
                        } else {}
                      });
                    },
                  ),
                ],
              );
              ;
            },
          ),
        ],
      ),
    );
  }
}

class DataSection extends StatelessWidget {
  final Function setState;
  final Map<String, dynamic> news;
  final Map<String, dynamic> medicals;

  const DataSection({
    Key? key,
    required this.setState,
    required this.news,
    required this.medicals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(medicals["assetPath"].toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SOLDAN, HABER İÇERİĞİ
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "News",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Divider(
                        endIndent: 2,
                        indent: 4,
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          news["imageAsset"].toString(), // Haber görseli
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        news["baslik"], // Haber başlığı
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        news["aciklama"], // Haber açıklaması
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                // İki sütun arasında dikey çizgi
                const VerticalDivider(
                  color: Color.fromARGB(255, 63, 59, 109),
                ),

                // SAĞDAN, İLGİLİ ÜRÜN
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Related Product",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Divider(),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${medicals["adi"]}", // İlaç adı
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...medicals["içerik"].map<Widget>((area) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    "- $area", // Kullanım alanlarını listele
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              medicals["assetPath"].toString(), // İlaç görseli
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${medicals["adi"]} ", // Kalın yazılacak kısım
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Kalın yazı stili
                              ),
                            ),
                            TextSpan(
                              text: medicals["amaci"], // İlaç amacı
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300, // Normal yazı stili
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Usage Areas:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...medicals["kullanimAlanlari"].asMap().entries.map<Widget>((entry) {
                        final index = entry.key + 1; // Liste sıralaması için 1'den başlatılır
                        final area = entry.value; // Kullanım alanı metni
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 6),
                          child: Text(
                            "$index. $area", // Sıra numarası ve metin
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GradientBorderButton(
                onPressed: () {
                  setState(); // Durumu güncelle
                },
                isButtonEnabled: true,
                text: "Fetch the related news...",
              ),
            )
          ],
        ),
      ),
    );
  }
}

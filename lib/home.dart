import 'dart:ui';
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
  final List<String> _suggestions = [
    'Futbol',
    'Basketbol',
    'Tenis',
    'Gezi Rotaları',
    'Tarih Kitapları',
    'Doğa Sporları',
  ];

  bool _isButtonEnabled = false;
  bool showData = false;
  bool isLoading = false;
  String _selectedSuggestion = '';

  @override
  Widget build(BuildContext context) {
    /// Ekran boyutu bilgisi
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF24243E), // Koyu mavi ton
              Color(0xFF302B63), // Daha koyu mavi-mor ton
              Color(0xFF0F0C29), // Çok koyu mor-siyah ton
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0], // Dinamik geçiş noktaları
          ),
        ),
        child: Center(
          child: Container(
            width: size.width * 0.5,
            height: size.height * 0.9,
            constraints: BoxConstraints(
              minHeight: 400, // Çok küçük ekranlar için minimum yükseklik
              maxHeight: size.height, // İçerik taşarsa kaydırılabilir
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(builder: (context, dialogState) {
              if (isLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset("assets/loadin.json"),
                    RandomProgressIndicatorExample(
                      () {
                        dialogState(
                          () {
                            isLoading = false;
                            showData = true;
                          },
                        );
                      },
                    )
                  ],
                );
              } else if (showData) {
                return DataSection();
                ;
              }
              return _buildMainContent(dialogState);
            }),
          ),
        ),
      ),
    );
  }

  /// Ana içeriği parçaladık (daha okunaklı olsun diye).
  Widget _buildMainContent(Function dialogState) {
    return Column(
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

        /// Autocomplete (Öneri listeli TextField)
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Kullanıcının yazdıklarıyla eşleşenleri döndürüyoruz
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _suggestions.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            setState(() {
              _selectedSuggestion = selection;
              _isButtonEnabled = true; // öneri seçilince buton aktif
            });
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Anahtar sözcük yazın...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white.withOpacity(0.9),
                elevation: 4.0,
                child: SizedBox(
                  width: 300,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        /// "Ara" Butonu
        GradientBorderButton(
            onPressed: () {
              dialogState(() {
                isLoading = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Aranacak terim: $_selectedSuggestion'),
                ),
              );
            },
            isButtonEnabled: _isButtonEnabled,
            text: "İlgili ilanı getir..."),

        const SizedBox(height: 30),

        /// Kategoriler başlığı
        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Kategoriler",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2,
          children: [
            _buildCategoryItem(
              title: 'Spor',
              imageUrl: 'assets/sports.jpg',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Spor kategorisi seçildi')),
                );
              },
            ),
            _buildCategoryItem(
              title: 'Seyahat',
              imageUrl: 'assets/travel.jpg',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seyahat kategorisi seçildi')),
                );
              },
            ),
            _buildCategoryItem(
              title: 'Tarih',
              imageUrl: 'assets/history.jpg',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tarih kategorisi seçildi')),
                );
              },
            ),
            _buildCategoryItem(
              title: 'Hobi',
              imageUrl: 'assets/hobies.jpg',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hobi kategorisi seçildi')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// GridView'da kategori öğesini oluşturan widget.
  Widget _buildCategoryItem({
    required String title,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        print("object");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 4.0,
                  color: Colors.black54,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DataSection extends StatelessWidget {
  const DataSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productData = {
      "name": "ABYGA 250 mg tablet",
      "form": "250 mg tablet (120 tablet)",
      "active_ingredient": "Abirateron asetat",
      "image_url": "https://www.deva.com.tr/uploads/product_images/big/ABYGA.png",
      "pdf_url": "https://www.deva.com.tr/uploads/product_files/6elKOZiMC6OpKp4mfOsk.pdf"
    };

    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Haber İçeriği",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 10,
                ),
                AppNetworkImage(imageUrl: "https://picsum.photos/300/300"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Son Dakika",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "İlaç mümessili, doktorla gerçekleştirdiği görüşmelerde belirli sorular sorarak doktorun ilgi alanlarını belirler. Bu süreçte yapay zeka devreye girer ve doktorun verdiği cevaplara göre segmentasyon yapar. Yapay zekanın analizi sayesinde, doktorun ilgi alanlarına uygun içerikler sunulabilir. Doktorun cevaplarına göre, yapay zeka uygulamanın sol tarafında ilgili haberleri ve sağ tarafında da haberle ilgili ürünleri gösterir. Bu sayede doktor, en yeni gelişmeleri ve uygun çözümleri hızlıca görür. Bu uygulama, doktorların bilgiye kolay erişimini ve ilaç mümessillerinin daha etkili tanıtım yapmasını sağlar. Yapay zeka destekli bu uygulama, sağlık sektöründe bilgi paylaşımını ve ürün tanıtımını yeni bir boyuta taşımaktadır.",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "İlgili Ürün",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      productData["name"]!,
                      style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  AppNetworkImage(imageUrl: "https://www.deva.com.tr/uploads/product_images/big/ABYGA.png"),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Form: ${productData["form"]}",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Etkin Madde: ${productData["active_ingredient"]}",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Detaylı bilgi için ",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () {
                  // PDF bağlantısına yönlendirme kodu eklenebilir.
                },
                child: Text(
                  "PDF'yi Görüntüleyin",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w400, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

/// GridView'da kategori öğesini oluşturan widget.
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
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovered = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Arkaplan görüntüsü
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: _isHovered
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    )
                  : null,
            ),

            // Başlık metni
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 4.0,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

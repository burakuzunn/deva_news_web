import 'dart:ui';
import 'package:flutter/material.dart';

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
            colors: [Colors.greenAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Container(
                  width: size.width * 0.6,
                  height: size.height * 0.9,

                  /// minHeight kullanımının sebebi: Çok dar ekranda
                  /// içerik taşmasın diye dinamik yükseklik sağlamak.
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
                  child: _buildMainContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ana içeriği parçaladık (daha okunaklı olsun diye).
  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Başlık
        const Text(
          "Hoş geldiniz!",
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
                hintText: 'Bir şeyler yazın...',
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
        ElevatedButton(
          onPressed: _isButtonEnabled
              ? () {
                  // Butona basılınca olacaklar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aranacak terim: $_selectedSuggestion'),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: const Text(
            'Ara',
            style: TextStyle(fontSize: 18),
          ),
        ),

        const SizedBox(height: 30),

        /// Kategoriler başlığı
        const Text(
          "Kategoriler",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        /// Responsive GridView
        LayoutBuilder(
          builder: (context, constraints) {
            // Ekranın anlık genişliğine göre sütun sayısını ve en-boy oranını ayarla
            int crossAxisCount;
            double childAspectRatio;

            if (constraints.maxWidth < 500) {
              // Dar ekranlar (mobil dikey)
              crossAxisCount = 1;
              childAspectRatio = 1.2; // Tek sütun, daha dik kart
            } else if (constraints.maxWidth < 900) {
              // Orta boy ekranlar (tablet veya dar web)
              crossAxisCount = 2;
              childAspectRatio = 1.1;
            } else {
              // Geniş ekranlar
              crossAxisCount = 3;
              childAspectRatio = 1.1;
            }

            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              children: [
                _buildCategoryItem(
                  title: 'Spor',
                  imageUrl: 'https://picsum.photos/300/300',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Spor kategorisi seçildi')),
                    );
                  },
                ),
                _buildCategoryItem(
                  title: 'Seyahat',
                  imageUrl: 'https://picsum.photos/300/300',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seyahat kategorisi seçildi')),
                    );
                  },
                ),
                _buildCategoryItem(
                  title: 'Tarih',
                  imageUrl: 'https://picsum.photos/300/300',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarih kategorisi seçildi')),
                    );
                  },
                ),
                _buildCategoryItem(
                  title: 'Hobi',
                  imageUrl: 'https://picsum.photos/300/300',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hobi kategorisi seçildi')),
                    );
                  },
                ),
              ],
            );
          },
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
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

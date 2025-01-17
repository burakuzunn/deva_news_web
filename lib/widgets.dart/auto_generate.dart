import 'dart:math';
import 'package:deva_news_web/data..dart';
import 'package:deva_news_web/news..dart';
import 'package:flutter/material.dart';

class NewsAutocomplete extends StatefulWidget {
  final Function(Map<String, dynamic> selectedNews, Map<String, dynamic> randomIlac, int randomGroupId) onComplete;

  const NewsAutocomplete({Key? key, required this.onComplete}) : super(key: key);

  @override
  _NewsAutocompleteState createState() => _NewsAutocompleteState();
}

class _NewsAutocompleteState extends State<NewsAutocomplete> {
  List<String> _suggestions = [];
  String _selectedSuggestion = "";

  @override
  void initState() {
    super.initState();
    _loadSuggestionsFromKeys();
  }

  void _loadSuggestionsFromKeys() {
    // keys içindeki tüm keywords'leri _suggestions listesine ekle
    final keywords = keys.expand((element) => element["keywords"] as List<String>);
    _suggestions = keywords.toSet().toList(); // Tekrar edenleri kaldır
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
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

          final selectedNews = newsData.firstWhere(
            (item) => item["baslik"].toString().contains(_selectedSuggestion) || item["aciklama"].toString().contains(_selectedSuggestion),
          );

          if (selectedNews != null) {
            // `selectedNews` içindeki groupList değerini al
            final List<int> groupList = List<int>.from(selectedNews["groupList"]);

            // `ilaclar` içinden `groupList` ile eşleşen ilk ilacı seç
            final filteredIlac = ilaclar.firstWhere(
              (ilac) => groupList.contains(ilac["group"]), // İlaç grubu, `groupList`'te varsa eşleşir
            );

            if (filteredIlac != null) {
              final selectedGroupId = filteredIlac["group"]; // Seçilen ilacın grubunu al
              widget.onComplete(selectedNews, filteredIlac, selectedGroupId); // İşleme devam et
            } else {
              // Hiçbir ilaç eşleşmezse kullanıcıya bir mesaj gösterebilirsiniz
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uygun bir ilaç bulunamadı')),
              );
            }
          }
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
            hintText: 'Enter a keyword...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0.01,
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
            elevation: 4, // Gölge efekti
            color: Colors.grey.shade900, // Koyu arkaplan
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 250),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey.shade700, // Koyu arka plan için daha açık gri
                    indent: 16,
                    endIndent: 16,
                  );
                },
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.elementAt(index);

                  return InkWell(
                    onTap: () => onSelected(option),
                    splashColor: Colors.blueAccent.withOpacity(0.1),
                    highlightColor: Colors.blueAccent.withOpacity(0.1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: Colors.white, // Koyu arka plan üzerinde beyaz yazı
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

final List<Map<String, dynamic>> keys = [
  {
    "keywords": [
      "Fenerbahçe",
      "Mourinho",
      "footballer",
      "transfer",
      "coach",
      "manager",
      "squad",
      "fans",
      "Galatasaray",
      "Başakşehir",
      "away match",
      "victory",
      "Barış",
      "Alper",
      "Super",
      "League",
      "Altay",
      "Manchester",
      "United",
      "penalty",
      "saved",
      "Arsenal",
      "match",
      "FA",
      "Cup",
      "Gran",
      "Fondo",
      "cycling",
      "event",
      "sustainability",
      "Antarctica",
      "guide",
      "traveler",
      "penguin",
      "colonies",
      "glaciers",
      "ecosystem",
      "Roman",
      "theater",
      "Naples",
      "excavations",
      "historical",
      "restoration",
      "festival",
      "tourism",
      "Royal",
      "garden",
      "events",
      "botanical",
      "exhibitions",
      "Hobby",
      "technologies",
      "artificial",
      "intelligence",
      "music",
      "Amazon",
      "rainforest",
      "discovery",
      "biological",
      "research",
      "plant",
      "animal",
      "conservation",
      "international",
      "nature",
      "fascinating",
      "danger",
      "player",
      "leader",
      "captain",
      "tournament",
      "championship"
    ]
  }
];

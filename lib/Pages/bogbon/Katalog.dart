import 'package:bogbon/Components/katalog_component.dart';
import 'package:bogbon/Pages/bogbon/Qidirish_Page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Katalog extends StatefulWidget {
  const Katalog({super.key});

  @override
  State<Katalog> createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
  late TextEditingController searchControl;

  final List<Map<String, dynamic>> toifalarList = [
    {
      "id": 1,
      "name": "Barcha o‘simliklar",
      "key": "all",
      "icon": "assets/images/toiflar/barcha.png",
      "description": "Barcha 50+ o‘simliklar ro‘yxati"
    },
    {
      "id": 2,
      "name": "Xonaki o'simliklar",
      "key": "xonaki",
      "icon": "assets/images/toiflar/uyosimlik.png",
      "description": "Xona sharoitida o‘sadigan gullar"
    },
    {
      "id": 3,
      "name": "Gulli o'simliklar",
      "key": "gulli",
      "icon":"assets/images/toiflar/gulli.png",
      "description": "Chiroyli gullaydigan navlar"
    },
    {
      "id": 4,
      "name": "Dorivor o'simliklar",
      "key": "dorivor",
      "icon": "assets/images/toiflar/dorivor.png",
      "description": "Shifobaxsh va foydali o‘simliklar"
    },
    {
      "id": 5,
      "name": "Sukkulent va Kaktus",
      "key": "sukkulent",
      "icon": "assets/images/toiflar/kaktuslar.png",
      "description": "Kam suv talab qiluvchi o‘simliklar"
    },
    {
      "id": 6,
      "name": "Mevali daraxtlar",
      "key": "mevali",
      "icon": "assets/images/toiflar/mevalar.png",
      "description": "Meva beruvchi o‘simliklar"
    },
    {
      "id": 7,
      "name": "Sabzavotlar",
      "key": "sabzavot",
      "icon": "assets/images/toiflar/sabzavot.png",
      "description": "Bog‘ va tomorqa sabzavotlari"
    },
    {
      "id": 8,
      "name": "Ko'katlar",
      "key": "ko'kat",
      "icon": "assets/images/toiflar/dorivor.png", 
      "description": "Oshxona uchun yangi ko'katlar"
    },
  ];

  void _onCategoryTap(Map<String, dynamic> category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchResultsPage(query: category["name"], filterKey: category["key"]),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchControl = TextEditingController();
  }

  @override
  void dispose() {
    searchControl.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    if (value.trim().isNotEmpty) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SearchResultsPage(query: value),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Katalog",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextField(
                  controller: searchControl,
                  onSubmitted: _onSearch,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    hintText: "O'simliklarni qidirish...",
                    hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : Colors.black38),
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return KatalogComponent(
                      category: toifalarList[index],
                      onTap: () => _onCategoryTap(toifalarList[index]),
                    );
                  },
                  childCount: toifalarList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

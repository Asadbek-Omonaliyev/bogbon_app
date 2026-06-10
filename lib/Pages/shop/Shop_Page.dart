import 'dart:ui';
import 'package:bogbon/Pages/shop/Shop_Details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategoryIndex = 0;
  int _currentBottomIndex = 0;

  final List<String> _categories = [
    "Barchasi 🌿",
    "O'simliklar",
    "Ko'chatlar",
    "O'g'itlar",
    "Idishlar",
    "Aksessuarlar"
  ];

  final List<Map<String, dynamic>> _products = [
    {
      "name": "Pomidor ko'chati",
      "desc": "Sifatli va serhosil nav",
      "price": "18 000 so'm",
      "rating": "4.8",
      "reviews": "128",
      "img": "assets/images/toiflar/uyosimlik.png",
      "badge": "-15%"
    },
    {
      "name": "Aloe Vera",
      "desc": "Shifobaxsh o'simlik",
      "price": "25 000 so'm",
      "rating": "4.9",
      "reviews": "85",
      "img": "assets/images/aloe.png",
      "badge": "Yangi"
    },
    {
      "name": "Kaktus mini",
      "desc": "Parvarishga oson",
      "price": "12 000 so'm",
      "rating": "4.7",
      "reviews": "56",
      "img": "assets/images/toiflar/kaktuslar.png",
      "badge": null
    },
    {
      "name": "Suyuq o'g'it",
      "desc": "Universal ozuqa",
      "price": "35 000 so'm",
      "rating": "4.6",
      "reviews": "210",
      "img": "assets/images/toiflar/uyosimlik.png",
      "badge": "Trend"
    },
  ];

  final List<Map<String, dynamic>> _shopCatalog = [
    {"name": "Xonaki o'simliklar", "icon": Icons.home_rounded, "count": "120+ mahsulot"},
    {"name": "Bog' anjomlari", "icon": Icons.handyman_rounded, "count": "45 mahsulot"},
    {"name": "O'g'itlar", "icon": Icons.science_rounded, "count": "30 mahsulot"},
    {"name": "Idishlar va bezaklar", "icon": Icons.grid_view_rounded, "count": "85 mahsulot"},
    {"name": "Urug'lar", "icon": Icons.eco_rounded, "count": "200+ mahsulot"},
    {"name": "Sug'orish tizimlari", "icon": Icons.water_drop_rounded, "count": "15 mahsulot"},
  ];

  final List<Map<String, dynamic>> _partnersShops = [
    {"name": "Green Garden", "location": "Toshkent sh, Yunusobod", "rating": "4.9", "img": Icons.store_rounded},
    {"name": "O'simliklar Dunyosi", "location": "Toshkent sh, Chilonzor", "rating": "4.7", "img": Icons.storefront_rounded},
    {"name": "Eco Flower", "location": "Samarqand sh, Markaz", "rating": "4.8", "img": Icons.local_florist_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF6F8F6),
      body: _buildBody(isDark),
      bottomNavigationBar: _buildBottomBar(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    switch (_currentBottomIndex) {
      case 0:
        return _buildShopHome(isDark);
      case 1:
        return _buildCatalogView(isDark);
      case 2:
        return _buildShopsView(isDark);
      default:
        return _buildShopHome(isDark);
    }
  }

  // --- SHOP HOME VIEW ---
  Widget _buildShopHome(bool isDark) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(isDark, "Do'kon 🌿", "Yaxshi o'simliklar – sog'lom hayot"),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(isDark),
                SizedBox(height: 24.h),
                _buildCategoryRow(isDark),
                SizedBox(height: 24.h),
                _buildPromoCarousel(),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Mashhur mahsulotlar",
                        style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => setState(() => _currentBottomIndex = 1),
                      child: Text("Barchasini ko'rish →",
                          style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(_products[index], isDark),
              childCount: _products.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                const Divider(),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(child: _buildTrustItem(Icons.verified_user_outlined, "Sifat kafolati", "100% sifatli", isDark)),
                    Expanded(child: _buildTrustItem(Icons.local_shipping_outlined, "Tez yetkazib berish", "1–3 kun", isDark)),
                  ],
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- CATALOG VIEW ---
  Widget _buildCatalogView(bool isDark) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(isDark, "Katalog", "Barcha turdagi mahsulotlar"),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _shopCatalog[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item['name']} bo'limi yuklanmoqda...")));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], color: const Color(0xFF2E7D32), size: 32.sp),
                        SizedBox(height: 12.h),
                        Text(item['name'], 
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                        Text(item['count'], 
                            style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
              childCount: _shopCatalog.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  // --- SHOPS VIEW ---
  Widget _buildShopsView(bool isDark) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(isDark, "Do'konlar", "Yaqin atrofdagi hamkorlar"),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final shop = _partnersShops[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetailPage(shop: shop, products: _products),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(shop['img'], color: const Color(0xFF2E7D32), size: 30.sp),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop['name'], style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                              Text(shop['location'], style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18.sp),
                            Text(shop['rating'], style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _partnersShops.length,
            ),
          ),
        ),
      ],
    );
  }

  void _showShopDetail(Map<String, dynamic> shop, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w, height: 4.h,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2.r)),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(shop['img'], color: const Color(0xFF2E7D32), size: 35.sp),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop['name'], style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                        Text(shop['location'], style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded))
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mavjud o'simliklar", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Text("${_products.length} ta mahsulot", style: TextStyle(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.65,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) => _buildProductCard(_products[index], isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildAppBar(bool isDark, String title, String subtitle) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 80.h,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF2E7D32), size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B1B1B))),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 12.sp, color: const Color(0xFF6B6B6B))),
        ],
      ),
      actions: [_buildCartIcon(isDark)],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF1E1E1E).withOpacity(0.7) 
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, Icons.storefront_rounded, "Asosiy"),
                _buildBottomNavItem(1, Icons.category_rounded, "Katalog"),
                _buildBottomNavItem(2, Icons.location_on_rounded, "Do'konlar"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentBottomIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentBottomIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF2E7D32) : Colors.grey, size: 24.sp),
          Text(label, style: GoogleFonts.poppins(fontSize: 10.sp, color: isSelected ? const Color(0xFF2E7D32) : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildCartIcon(bool isDark) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Savatcha hozircha bo'sh"))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.shopping_cart_outlined, color: const Color(0xFF2E7D32), size: 24.sp),
          ),
          Positioned(
            top: 8.h,
            right: 18.w,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text("3", style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Qidirish...",
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: const Color(0xFF6B6B6B)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B6B6B)),
          suffixIcon: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Filtr oynasi..."))),
            child: Container(
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(12.r)),
              child: Icon(Icons.tune, color: Colors.white, size: 18.sp),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(bool isDark) {
    return SizedBox(
      height: 44.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : (isDark ? Colors.white10 : Colors.white),
                borderRadius: BorderRadius.circular(22.r),
              ),
              alignment: Alignment.center,
              child: Text(_categories[index], style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF6B6B6B)))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 160.h,
      child: PageView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildPromoCard("Bahor chegirmalari", "20% gacha", "Hozir xarid qilish", const Color(0xFF2E7D32), "assets/images/toiflar/uyosimlik.png"),
          _buildPromoCard("Yangi kelganlar", "Sifatli ko'chatlar", "Ko'rish", const Color(0xFFFBC02D), "assets/images/aloe.png", isDarkPromo: true),
        ],
      ),
    );
  }

  Widget _buildPromoCard(String title, String sub, String btn, Color color, String img, {bool isDarkPromo = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: GoogleFonts.poppins(color: isDarkPromo ? Colors.black87 : Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                Text(sub, style: GoogleFonts.poppins(color: isDarkPromo ? Colors.black54 : Colors.white.withOpacity(0.9), fontSize: 12.sp)),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(color: isDarkPromo ? Colors.black87 : Colors.white, borderRadius: BorderRadius.circular(12.r)),
                  child: Text(btn, style: TextStyle(color: isDarkPromo ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                ),
              ],
            ),
          ),
          Expanded(child: Hero(tag: 'promo_$img', child: Image.asset(img, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.white, size: 80)))),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product, shopName: "Bog'bon Rasmiy"),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Container(height: 140.h, width: double.infinity, color: isDark ? Colors.white10 : const Color(0xFFF0F4F0), child: Center(child: Image.asset(product['img'], height: 100.h, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.green, size: 50)))),
                ),
                if (product['badge'] != null)
                  Positioned(top: 10.h, left: 10.w, child: Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), decoration: BoxDecoration(color: product['badge'] == "Yangi" ? const Color(0xFF2E7D32) : Colors.redAccent, borderRadius: BorderRadius.circular(8.r)), child: Text(product['badge'], style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)))),
                Positioned(top: 8, right: 8, child: GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${product['name']} saqlandi"))), child: const CircleAvatar(backgroundColor: Colors.white70, radius: 14, child: Icon(Icons.favorite_border, color: Color(0xFF6B6B6B), size: 18)))),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'], style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.bold), maxLines: 1),
                  Text(product['desc'], style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B6B6B))),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product['price'], style: GoogleFonts.poppins(color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      Container(padding: EdgeInsets.all(6.r), decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(10.r)), child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String title, String sub, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24.sp),
        SizedBox(width: 8.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.bold)), Text(sub, style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B6B6B)))]))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopDetailPage extends StatelessWidget {
  final Map<String, dynamic> shop;
  final List<Map<String, dynamic>> products;

  const ShopDetailPage({super.key, required this.shop, required this.products});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF6F8F6),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    child: Icon(shop['img'], size: 100.sp, color: const Color(0xFF2E7D32)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark ? const Color(0xFF121212) : const Color(0xFFF6F8F6)).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E7D32)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shop['name'], style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                            Text(shop['location'], style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(shop['rating'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text("Do'kon mahsulotlari", style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.h),
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
                (context, index) => _buildProductCard(context, products[index], shop['name'], isDark),
                childCount: products.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50.h)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, String shopName, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product, shopName: shopName),
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
                  child: Container(
                    height: 140.h,
                    width: double.infinity,
                    color: isDark ? Colors.white10 : const Color(0xFFF0F4F0),
                    child: Center(
                      child: Image.asset(
                        product['img'],
                        height: 100.h,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.green, size: 50),
                      ),
                    ),
                  ),
                ),
                if (product['badge'] != null)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: product['badge'] == "Yangi" ? const Color(0xFF2E7D32) : Colors.redAccent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(product['badge'], style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
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
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(10.r)),
                        child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
                      ),
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
}

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String shopName;

  const ProductDetailsPage({super.key, required this.product, required this.shopName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF6F8F6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isDark ? Colors.white10 : const Color(0xFFF0F4F0),
                child: Center(
                  child: Hero(
                    tag: 'prod_${product['name']}',
                    child: Image.asset(
                      product['img'],
                      height: 250.h,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.eco, color: Colors.green, size: 150),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E7D32)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: Color(0xFF2E7D32))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Color(0xFF2E7D32))),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'], style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                            Text(product['desc'], style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(product['price'], style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_rounded, color: Color(0xFF2E7D32)),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sotuvchi do'kon:", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            Text(shopName, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text("Mahsulot haqida", style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(
                    "Ushbu mahsulot bog'bonlar uchun eng yaxshi tanlov hisoblanadi. Sifatli va hamyonbop. Batafsil ma'lumot olish uchun do'kon bilan bog'lanishingiz mumkin.",
                    style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(16.r)),
                        child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF2E7D32)),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Savatchaga qo'shildi!")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          ),
                          child: Text("Savatchaga qo'shish", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

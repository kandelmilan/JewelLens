import 'package:flutter/material.dart';
import 'package:jewellens/core/theme/app_color.dart';
import 'package:jewellens/features/cart/views/cart_view.dart';
import 'package:jewellens/features/category/views/%20category_detail_view.dart';
import 'package:jewellens/features/category/views/categories_view.dart';
import 'package:jewellens/features/home/views/landing_page.dart';
import 'package:jewellens/features/orders/views/order_list_view.dart';
import 'package:jewellens/features/product/views/product_list_view.dart';
import 'package:jewellens/features/profile/views/profile_page.dart';

// import wishlist_view, cart_view, profile_view when ready

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int currentIndex = 0;

  final List<Widget> _tabs = [
    HomeView(),
    ProductListView(),
    OrderListView(),
    // OrderListView(),
    // Center(child: Text("Cart")),
    CartView(),
    ProfilePage(), // placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "Products",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt_long_outlined,
              ), // was Icons.favorite_border
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

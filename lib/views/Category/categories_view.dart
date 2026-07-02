// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellens/controllers/category_controller.dart';

// class CategoriesView extends StatefulWidget {
//   const CategoriesView({super.key});

//   @override
//   State<CategoriesView> createState() => _CategoriesViewState();
// }

// class _CategoriesViewState extends State<CategoriesView> {
//   static const Color _primary = Color(0xFF9C7C38);
//   static const Color _surface = Color(0xFFFAF7F2);
//   static const Color _textDark = Color(0xFF1F1B16);
//   static const Color _textMuted = Color(0xFF7A7168);
//   static const Color _border = Color(0xFFE4DED2);

//   final CategoryController controller = Get.put(CategoryController());

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchCategory();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _surface,
//       appBar: AppBar(
//         backgroundColor: _surface,
//         elevation: 0,
//         title: const Text(
//           "Categories",
//           style: TextStyle(color: _textDark, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: _textDark),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: _primary),
//           );
//         }

//         final list = controller.category.value.data;

//         if (list.isEmpty) {
//           return const Center(
//             child: Text(
//               "No categories found",
//               style: TextStyle(color: _textMuted),
//             ),
//           );
//         }

//         return RefreshIndicator(
//           color: _primary,
//           onRefresh: controller.fetchCategory,
//           child: GridView.builder(
//             padding: const EdgeInsets.all(20),
//             physics: const BouncingScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//               childAspectRatio: 0.95,
//             ),
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               final item = list[index];
//               return GestureDetector(
//                 onTap: () {
//                   // TODO: navigate to product listing filtered by item.slug
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     border: Border.all(color: _border),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 70,
//                         width: 70,
//                         decoration: BoxDecoration(
//                           color: _primary.withOpacity(.10),
//                           shape: BoxShape.circle,
//                         ),
//                         child: ClipOval(
//                           child: item.icon != null && item.icon!.isNotEmpty
//                               ? Image.network(
//                                   item.icon!,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) => const Icon(
//                                     Icons.diamond_outlined,
//                                     color: _primary,
//                                     size: 30,
//                                   ),
//                                 )
//                               : const Icon(
//                                   Icons.diamond_outlined,
//                                   color: _primary,
//                                   size: 30,
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Text(
//                           item.name ?? "",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: _textDark,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellens/controllers/Category/category_controller.dart';
import 'package:jewellens/views/Category/%20category_detail_view.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  static const Color _primary = Color(0xFF9C7C38);
  static const Color _surface = Color(0xFFFAF7F2);
  static const Color _textDark = Color(0xFF1F1B16);
  static const Color _textMuted = Color(0xFF7A7168);
  static const Color _border = Color(0xFFE4DED2);

  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header — replaces the removed AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Grid content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primary),
                  );
                }

                final list = controller.category.value.data;

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      "No categories found",
                      style: TextStyle(color: _textMuted),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: _primary,
                  onRefresh: controller.fetchCategory,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio:
                              0.85, // taller cards, avoids overflow
                        ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return GestureDetector(
                        // onTap: () {
                        //   // TODO: navigate to product listing filtered by item.slug
                        // },
                        // inside categories_view.dart's itemBuilder
                        onTap: () {
                          if (item.slug != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryDetailView(slug: item.slug!),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: _primary.withOpacity(.10),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child:
                                      item.icon != null && item.icon!.isNotEmpty
                                      ? Image.network(
                                          item.icon!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.diamond_outlined,
                                                color: _primary,
                                                size: 30,
                                              ),
                                        )
                                      : const Icon(
                                          Icons.diamond_outlined,
                                          color: _primary,
                                          size: 30,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  item.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

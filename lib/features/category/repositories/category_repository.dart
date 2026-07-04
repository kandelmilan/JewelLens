import 'package:jewellens/features/category/models/categories_by_slug_model.dart';
import 'package:jewellens/features/category/models/categories_model.dart';
import 'package:jewellens/features/category/models/category_by_id_model.dart';
import 'package:jewellens/features/category/services/categories_service.dart';
import 'package:jewellens/features/category/services/category_by_id_service.dart';
import 'package:jewellens/features/category/services/category_by_slug_service.dart';

abstract class CategoryRepository {
  Future<CategoriesModel> getCategories();
  Future<CategoryByIdModel> getCategoryById(int categoryId);
  Future<CategoryBySlugModel> getCategoryBySlug(String slug);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoriesService _categoriesService;
  final CategoryByIdService _categoryByIdService;
  final CategoryBySlugService _categoryBySlugService;

  CategoryRepositoryImpl({
    CategoriesService? categoriesService,
    CategoryByIdService? categoryByIdService,
    CategoryBySlugService? categoryBySlugService,
  }) : _categoriesService = categoriesService ?? CategoriesService(),
       _categoryByIdService = categoryByIdService ?? CategoryByIdService(),
       _categoryBySlugService =
           categoryBySlugService ?? CategoryBySlugService();

  @override
  Future<CategoriesModel> getCategories() {
    return _categoriesService.getCategories();
  }

  @override
  Future<CategoryByIdModel> getCategoryById(int categoryId) {
    return _categoryByIdService.getCategoryById(categoryId);
  }

  @override
  Future<CategoryBySlugModel> getCategoryBySlug(String slug) {
    return _categoryBySlugService.getCategoryBySlug(slug);
  }
}

import 'dart:convert';

class ProductResponseModel {
  final bool? success;
  final List<Product>? data;
  final PaginationMeta? meta;

  ProductResponseModel({this.success, this.data, this.meta});

  factory ProductResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return ProductResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Product>.from(map['data'].map((x) => Product.fromMap(x)))
          : null,
      meta: map['meta'] != null ? PaginationMeta.fromMap(map['meta']) : null,
    );
  }
}

class Product {
  final int? id;
  final int? categoryId;
  final String? name;
  final String? slug;
  final String? description;
  final String? price; // String decimal: "299000.00"
  final String? image;
  final int? stock;
  final int? weight; // gram
  final bool? isActive;
  final bool? isFeatured;
  final String? createdAt;
  final String? updatedAt;
  final Category? category;

  Product({
    this.id,
    this.categoryId,
    this.name,
    this.slug,
    this.description,
    this.price,
    this.image,
    this.stock,
    this.weight,
    this.isActive,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt(),
      categoryId: map['categoryId']?.toInt(),
      name: map['name'],
      slug: map['slug'],
      description: map['description'],
      price: map['price']?.toString(),
      image: map['image'],
      stock: map['stock']?.toInt(),
      weight: map['weight']?.toInt(),
      isActive: map['isActive'],
      isFeatured: map['isFeatured'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      category: map['category'] != null
          ? Category.fromMap(map['category'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'slug': slug,
        'description': description,
        'price': price,
        'image': image,
        'stock': stock,
        'weight': weight,
        'isActive': isActive,
        'isFeatured': isFeatured,
      };

  String get imageUrl => image ?? '';
}

class Category {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Category({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt(),
      name: map['name'],
      slug: map['slug'],
      description: map['description'],
      image: map['image'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}

class PaginationMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  PaginationMeta({this.page, this.limit, this.total, this.totalPages});

  factory PaginationMeta.fromMap(Map<String, dynamic> map) {
    return PaginationMeta(
      page: map['page']?.toInt(),
      limit: map['limit']?.toInt(),
      total: map['total']?.toInt(),
      totalPages: map['totalPages']?.toInt(),
    );
  }
}

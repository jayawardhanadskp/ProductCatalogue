// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class ProductResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponseModel.fromMap(Map<String, dynamic> map) {
    return ProductResponseModel(
      total: map['total'] as int? ?? 0,
      skip: map['skip'] as int? ?? 0,
      limit: map['limit'] as int? ?? 0,
      products: map['products'] != null
          ? List<ProductModel>.from(
              (map['products'] as List<dynamic>).map(
                (x) => ProductModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }
}


class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List<dynamic> images;
  final double rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'images': images,
      'rating': rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      category: map['category'] as String,
      images: List<dynamic>.from((map['images'] as List<dynamic>)),
      rating: map['rating'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

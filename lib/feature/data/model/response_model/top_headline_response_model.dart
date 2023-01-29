// To parse this JSON data, do
//
//     final topHeadlineResponseModel = topHeadlineResponseModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'top_headline_response_model.freezed.dart';
part 'top_headline_response_model.g.dart';

TopHeadlineResponseModel topHeadlineResponseModelFromJson(String str) =>
    TopHeadlineResponseModel.fromJson(json.decode(str));

String topHeadlineResponseModelToJson(TopHeadlineResponseModel data) =>
    json.encode(data.toJson());

@freezed
class TopHeadlineResponseModel with _$TopHeadlineResponseModel {
  const factory TopHeadlineResponseModel({
    String? status,
    int? totalResults,
    List<Article>? articles,
  }) = _TopHeadlineResponseModel;

  factory TopHeadlineResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopHeadlineResponseModelFromJson(json);
}

@freezed
class Article with _$Article {
  const factory Article({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

@freezed
class Source with _$Source {
  const factory Source({
    String? id,
    String? name,
  }) = _Source;

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

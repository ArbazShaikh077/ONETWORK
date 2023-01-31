import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/feature/presentation/bloc/bloc.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_bloc.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_failure_message.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_item_news.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final topHeadlinesNewsBloc =
      DependencyInjector.serviceLocator<TopHeadlinesNewsBloc>();
  final controllerKeyword = TextEditingController();
  final focusNodeIconSearch = FocusNode();
  String? keyword;
  Timer? debounce;

  @override
  void initState() {
    keyword = '';
    controllerKeyword.addListener(_onSearching);
    super.initState();
  }

  @override
  void dispose() {
    focusNodeIconSearch.dispose();
    controllerKeyword.removeListener(_onSearching);
    controllerKeyword.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDarkTheme = theme.brightness == Brightness.dark;
    return Scaffold(
      body: BlocProvider<TopHeadlinesNewsBloc>(
        create: (context) => topHeadlinesNewsBloc,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: isDarkTheme ? null : Color(0xFFEFF5F5),
            ),
            Container(
              color: isDarkTheme ? null : Color(0xFFEFF5F5),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 24.h,
                horizontal: 10.w,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Platform.isIOS
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllerKeyword,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Searching something?',
                                    hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'iconSearch',
                                child: Focus(
                                  focusNode: focusNodeIconSearch,
                                  child: Icon(
                                    Icons.search,
                                    size: 16.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesState>(
                      builder: (context, state) {
                        if (state is LoadingHeadlineState) {
                          return Center(
                            child: Platform.isIOS
                                ? const CupertinoActivityIndicator()
                                : const CircularProgressIndicator(),
                          );
                        } else if (state is FailureHeadlineState) {
                          return const WidgetFailureMessage();
                        } else if (state is SearchedHeadlineState) {
                          var listArticles = state.listArticles;
                          if (listArticles.isEmpty) {
                            return const WidgetFailureMessage(
                              errorTitle: 'Data not found',
                              errorSubtitle:
                                  'Hm, we couldn\'t find what you were looking for.',
                            );
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                var itemArticle = listArticles[index];
                                var dateTimePublishedAt =
                                    DateFormat('yyy-MM-ddTHH:mm:ssZ').parse(
                                        itemArticle.publishedAt ?? "", true);
                                var strPublishedAt =
                                    DateFormat('MMM dd, yyyy HH:mm')
                                        .format(dateTimePublishedAt);
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: WidgetItemNews(
                                    itemArticle: itemArticle,
                                    strPublishedAt: strPublishedAt,
                                  ),
                                );
                              },
                              itemCount: listArticles.length,
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearching() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }
    debounce = Timer(const Duration(milliseconds: 800), () {
      var keyword = controllerKeyword.text.trim();
      if (keyword.isEmpty || this.keyword == keyword) {
        return;
      }
      this.keyword = keyword;
      focusNodeIconSearch.requestFocus();
      topHeadlinesNewsBloc.add(SearchHeadlineEvent(keyword: keyword));
    });
  }
}

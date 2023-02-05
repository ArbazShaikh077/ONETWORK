import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/feature/presentation/bloc/bloc.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // leadingWidth: ,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
            Expanded(
              child: TextField(
                showCursor: true,
                focusNode: focusNodeIconSearch,
                cursorColor: Colors.white,
                controller: controllerKeyword,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search for topics, locations & sources',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white60,
                  ),
                  // border: OutlineInputBorder()
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                focusNodeIconSearch.requestFocus();
              },
            ),
          ],
        ),
      ),
      body: BlocProvider<TopHeadlinesNewsBloc>(
        create: (context) => topHeadlinesNewsBloc,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            // vertical: 10.h,
            horizontal: 10.w,
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesState>(
                  builder: (context, state) {
                    if (state is LoadingHeadlineState) {
                      return Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 20.r,
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      );
                    } else if (state is FailureHeadlineState) {
                      return const Center(
                        child: SingleChildScrollView(
                            child: WidgetFailureMessage()),
                      );
                    } else if (state is SearchedHeadlineState) {
                      var listArticles = state.listArticles;
                      if (listArticles.isEmpty) {
                        focusNodeIconSearch.unfocus();
                        return const Center(
                          child: SingleChildScrollView(
                            child: WidgetFailureMessage(
                              errorTitle: 'Data not found',
                              errorSubtitle:
                                  'Hm, we couldn\'t find what you were looking for.',
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var itemArticle = listArticles[index];
                            var dateTimePublishedAt =
                                DateFormat('yyy-MM-ddTHH:mm:ssZ')
                                    .parse(itemArticle.publishedAt ?? "", true);
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

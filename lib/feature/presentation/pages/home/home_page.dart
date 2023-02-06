import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/feature/data/model/category_news_model.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_news_app/feature/presentation/bloc/bloc.dart';
import 'package:flutter_news_app/feature/presentation/pages/home/widget/first_news_item.dart';
import 'package:flutter_news_app/feature/presentation/pages/search/news_search.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_failure_message.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_item_news.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final topHeadlinesNewsBloc =
      DependencyInjector.serviceLocator<TopHeadlinesNewsBloc>();
  final refreshIndicatorState = GlobalKey<RefreshIndicatorState>();

  // bool isLoadingCenterIOS = false;
  Completer? completerRefresh;
  var indexCategorySelected = 0;

  final listCategories = <CategoryNewsModel>[
    CategoryNewsModel(image: '', title: 'All'),
    CategoryNewsModel(
        image: 'assets/images/img_business.png', title: 'Business'),
    CategoryNewsModel(
        image: 'assets/images/img_entertainment.png', title: 'Entertainment'),
    CategoryNewsModel(image: 'assets/images/img_health.png', title: 'Health'),
    CategoryNewsModel(image: 'assets/images/img_science.png', title: 'Science'),
    CategoryNewsModel(image: 'assets/images/img_sport.png', title: 'Sports'),
    CategoryNewsModel(
        image: 'assets/images/img_technology.png', title: 'Technology'),
  ];

  @override
  void initState() {
    topHeadlinesNewsBloc.add(
      LoadHeadLineEvent(
          category: listCategories[indexCategorySelected].title.toLowerCase()),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return DefaultTabController(
      length: listCategories.length,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                stretch: false,
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: true,
                title: const Text('ONETWORK'),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SearchPage()));
                      },
                      icon: const Icon(Icons.search))
                ],
                bottom: TabBar(
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  tabs: List.generate(
                    listCategories.length,
                    (index) => Tab(
                      text: listCategories[index].title,
                    ),
                  ),
                  onTap: (index) {
                    if (indexCategorySelected == index) {
                      return;
                    }
                    indexCategorySelected = index;

                    topHeadlinesNewsBloc.add(
                      ChangeCategoryEvent(indexCategorySelected: index),
                    );
                  },
                ), // TabBar
              ),
            ];
          },
          body: BlocProvider<TopHeadlinesNewsBloc>(
            create: (context) => topHeadlinesNewsBloc,
            child: BlocListener<TopHeadlinesNewsBloc, TopHeadlinesState>(
                listener: (context, state) {
                  if (state is FailureHeadlineState) {
                    _resetRefreshIndicator();
                  } else if (state is LoadedHeadlineState) {
                    _resetRefreshIndicator();
                  } else if (state is ChangeCategoryHeadlineState) {
                    indexCategorySelected = state.indexCategorySelected;

                    var category = listCategories[indexCategorySelected]
                        .title
                        .toLowerCase();
                    topHeadlinesNewsBloc
                        .add(LoadHeadLineEvent(category: category));
                  }
                },
                child: _buildWidgetContentNews()),
          ),
        ),
      ),
    );
  }

  void _resetRefreshIndicator() {
    completerRefresh?.complete();
    completerRefresh = Completer();
  }

  Widget _buildWidgetContentNews() {
    return BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesState>(
      builder: (context, state) {
        var listArticles = <Article>[];
        if (state is LoadedHeadlineState) {
          listArticles.addAll(state.listArticles);
        } else if (state is FailureHeadlineState) {
          return _buildWidgetFailureLoadData(errorMessage: state.errorMessage);
        } else if (state is LoadingHeadlineState) {
          return Platform.isIOS
              ? Center(
                  child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 20.r,
                ))
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
        }
        return LiquidPullToRefresh(
          backgroundColor: Colors.white,
          animSpeedFactor: 1.0,
          height: 60.h,
          color: Theme.of(context).appBarTheme.backgroundColor,
          key: refreshIndicatorState,
          onRefresh: () async {
            topHeadlinesNewsBloc.add(
              LoadHeadLineEvent(
                  category: listCategories[indexCategorySelected]
                      .title
                      .toLowerCase()),
            );
            completerRefresh?.future;
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              var itemArticle = listArticles[index];
              var dateTimePublishedAt = DateFormat('yyyy-MM-ddTHH:mm:ssZ')
                  .parse(itemArticle.publishedAt ?? "", true);
              var strPublishedAt =
                  DateFormat('MMM dd, yyyy HH:mm').format(dateTimePublishedAt);
              if (index == 0) {
                return FirstNewsItem(
                    itemArticle: itemArticle, strPublishedAt: strPublishedAt);
              } else {
                return _buildWidgetItemNews(index, itemArticle, strPublishedAt);
              }
            },
            itemCount: listArticles.length,
          ),
        );
      },
    );
  }

  Widget _buildWidgetFailureLoadData({String? errorMessage}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetFailureMessage(errorSubtitle: errorMessage),
          SizedBox(
            height: 10.h,
          ),
          TextButton(
            onPressed: () {
              topHeadlinesNewsBloc.add(
                LoadHeadLineEvent(
                    category: listCategories[indexCategorySelected]
                        .title
                        .toLowerCase()),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).appBarTheme.backgroundColor,
              ),
            ),
            child: Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetItemNews(
    int index,
    Article itemArticle,
    String strPublishedAt,
  ) {
    return Padding(
      padding: EdgeInsets.only(
          top: index == 1 ? 32.h : 16.h, bottom: 16.h, left: 10.w, right: 10.w),
      child: WidgetItemNews(
        itemArticle: itemArticle,
        strPublishedAt: strPublishedAt,
      ),
    );
  }
}

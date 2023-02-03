import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/feature/data/model/category_news_model.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_news_app/feature/presentation/bloc/bloc.dart';
import 'package:flutter_news_app/feature/presentation/pages/search/news_search.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_failure_message.dart';
import 'package:flutter_news_app/feature/presentation/pages/widget/widget_item_news.dart';
import 'package:flutter_news_app/onetwork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final topHeadlinesNewsBloc =
      DependencyInjector.serviceLocator<TopHeadlinesNewsBloc>();
  final refreshIndicatorState = GlobalKey<RefreshIndicatorState>();

  bool isLoadingCenterIOS = false;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isIOS) {
        isLoadingCenterIOS = true;
        topHeadlinesNewsBloc.add(
          LoadHeadLineEvent(
              category:
                  listCategories[indexCategorySelected].title.toLowerCase()),
        );
      } else {
        completerRefresh = Completer();
        refreshIndicatorState.currentState?.show();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return DefaultTabController(
      length: listCategories.length,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
        appBar: AppBar(
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: TabBar(
                  isScrollable: true,
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
                ),
              ),
            ],
          ), // TabBar
        ), // AppBar
        backgroundColor: Colors.black,
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
                if (Platform.isIOS) {
                  isLoadingCenterIOS = true;
                  var category =
                      listCategories[indexCategorySelected].title.toLowerCase();
                  topHeadlinesNewsBloc
                      .add(LoadHeadLineEvent(category: category));
                } else {
                  refreshIndicatorState.currentState?.show();
                }
              }
            },
            child: Platform.isIOS
                ? _buildWidgetContentNewsIOS()
                : _buildWidgetContentNewsAndroid(),
            //                 Stack(
            //   children: [
            //     Container(
            //       width: double.infinity,
            //       // color: isDarkMode ? null : Color(0xFFEFF5F5),
            //       padding: EdgeInsets.symmetric(
            //         vertical: 24.h,
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 20.w),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Expanded(
            //                   child: Text(
            //                     'Daily News',
            //                     style: TextStyle(
            //                       fontSize: 18.sp,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //                 GestureDetector(
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => SearchPage()),
            //                     );
            //                   },
            //                   child: Hero(
            //                     tag: 'iconSearch',
            //                     child: Icon(
            //                       Icons.search,
            //                       size: 20.h,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(width: 10.w),
            //                 GestureDetector(
            //                   onTap: () {
            //                     // Navigator.push(
            //                     //   context,
            //                     //   MaterialPageRoute(
            //                     //     builder: (context) => SettingsPage(),
            //                     //   ),
            //                     // );
            //                   },
            //                   child: Icon(
            //                     Icons.settings,
            //                     size: 20.h,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           // SizedBox(height: 24.h),
            //           // WidgetCategoryNews(
            //           //     listCategories: listCategories,
            //           //     indexDefaultSelected: indexCategorySelected),
            //           // SizedBox(height: 24.h),
            //           Expanded(
            //             child:
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

  void _resetRefreshIndicator() {
    if (isLoadingCenterIOS) {
      isLoadingCenterIOS = false;
    }
    completerRefresh?.complete();
    completerRefresh = Completer();
  }

  Widget _buildWidgetContentNewsIOS() {
    return BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesState>(
      builder: (context, state) {
        var listArticles = <Article>[];
        if (state is LoadedHeadlineState) {
          listArticles.addAll(state.listArticles);
        } else if (isLoadingCenterIOS) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      topHeadlinesNewsBloc.add(
                        LoadHeadLineEvent(
                            category: listCategories[indexCategorySelected]
                                .title
                                .toLowerCase()),
                      );
                      completerRefresh?.future;
                    },
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var itemArticle = listArticles[index];
                        var dateTimePublishedAt =
                            DateFormat('yyyy-MM-ddTHH:mm:ssZ')
                                .parse(itemArticle.publishedAt ?? "", true);
                        var strPublishedAt = DateFormat('MMM dd, yyyy HH:mm')
                            .format(dateTimePublishedAt);
                        if (index == 0) {
                          return _buildWidgetItemLatestNews(
                              itemArticle, strPublishedAt);
                        } else {
                          return _buildWidgetItemNews(
                              index, itemArticle, strPublishedAt);
                        }
                      },
                      childCount: listArticles.length,
                    ),
                  ),
                ],
              ),
            ),
            listArticles.isEmpty && state is! LoadingHeadlineState
                ? _buildWidgetFailureLoadData()
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildWidgetContentNewsAndroid() {
    return BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesState>(
      builder: (context, state) {
        var listArticles = <Article>[];
        if (state is LoadedHeadlineState) {
          listArticles.addAll(state.listArticles);
        }
        return Stack(
          children: [
            RefreshIndicator(
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
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                itemBuilder: (context, index) {
                  var itemArticle = listArticles[index];
                  var dateTimePublishedAt = DateFormat('yyyy-MM-ddTHH:mm:ssZ')
                      .parse(itemArticle.publishedAt ?? "", true);
                  var strPublishedAt = DateFormat('MMM dd, yyyy HH:mm')
                      .format(dateTimePublishedAt);
                  if (index == 0) {
                    return _buildWidgetItemLatestNews(
                        itemArticle, strPublishedAt);
                  } else {
                    return _buildWidgetItemNews(
                        index, itemArticle, strPublishedAt);
                  }
                },
                itemCount: listArticles.length,
              ),
            ),
            listArticles.isEmpty && state is FailureHeadlineState
                ? _buildWidgetFailureLoadData()
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildWidgetFailureLoadData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const WidgetFailureMessage(),
          TextButton(
            onPressed: () {
              if (Platform.isIOS) {
                isLoadingCenterIOS = true;
                topHeadlinesNewsBloc.add(
                  LoadHeadLineEvent(
                      category: listCategories[indexCategorySelected]
                          .title
                          .toLowerCase()),
                );
              } else {
                refreshIndicatorState.currentState?.show();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
            ),
            child: Text(
              'Try Again'.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
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
        top: index == 1 ? 32.h : 16.h,
        bottom: 16.h,
      ),
      child: WidgetItemNews(
        itemArticle: itemArticle,
        strPublishedAt: strPublishedAt,
      ),
    );
  }

  Widget _buildWidgetItemLatestNews(
    Article itemArticle,
    String strPublishedAt,
  ) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(itemArticle.url ?? ""))) {
          await launchUrl(Uri.parse(itemArticle.url ?? ""));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            (const SnackBar(
              content: Text('Couldn\'t open detail news'),
            )),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: ScreenUtil().screenHeight / 1.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(
              itemArticle.urlToImage ?? "",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().screenHeight / 1.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.0),
                  ],
                  stops: [
                    0.0,
                    1.0,
                  ],
                ),
              ),
              // padding: EdgeInsets.all(48.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 14.h,
                    ),
                    child: Text(
                      'Latest News',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      itemArticle.title ?? "Dafault Title",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          strPublishedAt,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          itemArticle.source?.name ?? "Dafault Article Name",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetCategoryNews extends StatefulWidget {
  final List<CategoryNewsModel> listCategories;
  final int indexDefaultSelected;

  const WidgetCategoryNews({
    super.key,
    required this.listCategories,
    required this.indexDefaultSelected,
  });

  @override
  State<WidgetCategoryNews> createState() => _WidgetCategoryNewsState();
}

class _WidgetCategoryNewsState extends State<WidgetCategoryNews> {
  late int indexCategorySelected;

  @override
  void initState() {
    indexCategorySelected = widget.indexDefaultSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 48.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var itemCategory = widget.listCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12.w,
              right: index == widget.listCategories.length - 1 ? 0 : 12.w,
            ),
            child: GestureDetector(
              onTap: () {
                if (indexCategorySelected == index) {
                  return;
                }
                setState(() => indexCategorySelected = index);
                var topHeadlinesNewsBloc =
                    BlocProvider.of<TopHeadlinesNewsBloc>(context);
                topHeadlinesNewsBloc.add(
                  ChangeCategoryEvent(indexCategorySelected: index),
                );
              },
              child: Container(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        itemCategory.title.toLowerCase() == 'all' ? 48.w : 32.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                        indexCategorySelected == index ? 0.2 : 0.6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    border: indexCategorySelected == index
                        ? Border.all(
                            color: Colors.white,
                            width: 2.0,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      itemCategory.title,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: itemCategory.title.toLowerCase() == 'all'
                      ? Color(0xFFBBCDDC)
                      : null,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  image: itemCategory.title.toLowerCase() == 'all'
                      ? null
                      : DecorationImage(
                          image: AssetImage(
                            itemCategory.image,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.listCategories.length,
      ),
    );
  }
}

class WidgetDateToday extends StatefulWidget {
  const WidgetDateToday({super.key});

  @override
  State<WidgetDateToday> createState() => _WidgetDateTodayState();
}

class _WidgetDateTodayState extends State<WidgetDateToday> {
  late String strToday;

  @override
  void initState() {
    strToday = DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        strToday,
        style: TextStyle(
          fontSize: 25.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
}

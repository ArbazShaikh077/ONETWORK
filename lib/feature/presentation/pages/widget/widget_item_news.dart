import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:timeago/timeago.dart' as timeago;

class WidgetItemNews extends StatelessWidget {
  final Article itemArticle;
  final String strPublishedAt;

  const WidgetItemNews({
    super.key,
    required this.itemArticle,
    required this.strPublishedAt,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
        onTap: () async {
          if (await canLaunchUrlString(itemArticle.url ?? "")) {
            await launchUrlString(itemArticle.url ?? "");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Couldn\'t open detail news'),
            ));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              child: CachedNetworkImage(
                imageUrl: itemArticle.urlToImage ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.h,
                errorWidget: (context, url, error) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/img_not_found.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.h,
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.white10,
                    highlightColor: Theme.of(context)
                            .appBarTheme
                            .backgroundColor
                            ?.withOpacity(0.5) ??
                        Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              itemArticle.title ?? "",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            Text(
              timeago.format(DateTime.parse(itemArticle.publishedAt ?? ""),
                  allowFromNow: true),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.8.h,
            ),
          ],
        ));
  }
}

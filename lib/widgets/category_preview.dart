import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';

class CategoryPreview extends StatelessWidget {
  final Category category;
  final String activityInfo;

  const CategoryPreview(this.category, this.activityInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(left: 40, right: 10, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          // first row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                () {
                  String headerPreview = category.title!.split("\n")[0];
                  if (headerPreview.length > Config.maxPreviewChars) {
                    headerPreview = "${category.title!.substring(0, Config.maxPreviewChars)}...";
                  }
                  return headerPreview;
                } (),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                )
              ),
              const SizedBox(width: 20,),
              Text(
                () {
                  String bodyPreview = category.description!.split("\n")[0];
                  if (bodyPreview.length > Config.maxPreviewChars) {
                    bodyPreview = "${category.description!.substring(0, Config.maxPreviewChars)}...";
                  }                    
                  return bodyPreview;
                } (),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w300
                ),
              )
            ],
          ),
          // second row | info about lastest activities
          Text(
            activityInfo,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    );
  }
}
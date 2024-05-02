import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';

class CategoryPreview extends StatelessWidget {
  final Category category;

  const CategoryPreview(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 10, top: 5, bottom: 5),
      decoration: const BoxDecoration(
        //border: Border.all(color: Colors.white),
        //color: Colors.grey[900]!,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            () {
              String headerPreview = category.title!.split("\n")[0];
              if (headerPreview.length > Config.maxPreviewChars) {
                headerPreview = "${category.title!.substring(0, Config.maxPreviewChars)}...";
              }
              return "/$headerPreview/";
            } (),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500
            )
          ),
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
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w300
            ),
          )
        ],
      ),
    );
  }
}
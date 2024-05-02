import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';

class ThreadPreview extends StatelessWidget {
  final Thread thread;

  const ThreadPreview(this.thread, {super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            () {
              String headerPreview = thread.title!.split("\n")[0];
              if (headerPreview.length > Config.maxPreviewChars) {
                headerPreview = thread.title!.substring(0, Config.maxPreviewChars);
              }
              return headerPreview;
            } (),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500
            )
          ),
          Text(
            () {
              if (thread.content == null || thread.content! == "") {
                return "created by ${thread.author} at ${thread.creationDate}";
              }
              String bodyPreview = thread.content!.split("\n")[0];
              if (bodyPreview.length > Config.maxPreviewChars) {
                bodyPreview = thread.content!.substring(0, Config.maxPreviewChars);
              }                    
              return bodyPreview;
            } (),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w300
            ),
          ),
          Row(
            children: [
              // number of posts
              const Icon(Icons.message, size: 12),
              const SizedBox(width: 10),
              Text(
                "${thread.postIDs.length}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 20),
              // number of views
              const Icon(Icons.remove_red_eye_outlined, size: 12),
              const SizedBox(width: 10),
              Text(
                "${thread.views}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

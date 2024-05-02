import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';

class PostDisplay extends StatelessWidget {
  final Post post;

  const PostDisplay(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 10, top: 5, bottom: 5),      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // post's number of views
          Row(
            children: [
              Text(
                post.author!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  //fontWeight: FontWeight.w300
                )
              ),
              const SizedBox(width: 15,),
              Text(
                post.creationDate!,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              )
            ],
          ),

          // post's content
          Text(
            post.content!,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          // post's attachment / media
          Config.getMediaWidget(post)
        ],
      ),
    );
  }
}
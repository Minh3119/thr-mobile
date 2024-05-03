import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/post_display.dart';
import 'package:thr_client/widgets/video_display.dart';

class ThreadView extends StatefulWidget {
  final Category category;
  final Thread thread;

  const ThreadView(this.category, this.thread, {super.key});

  @override
  State<ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  List<PostDisplay> postDisplays = [];
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    //updatePostDisplays();
    _futurePosts = DataController.getPosts(widget.thread.ID!, postIDs: widget.thread.postIDs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onPrimary,
                  offset: const Offset(0.6,0.6),
                  blurRadius: 0.35,
                  spreadRadius: 0
                )
              ]
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18,),
          ),
        ),
        title: Text(
          "${widget.category.title}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600
          )
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:(context, animation, secondaryAnimation) => widget,
              transitionDuration: const Duration(seconds: 0)
            ),
          );
          return Future.value();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // views
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                  
                const Icon(Icons.remove_red_eye_outlined, size: 12),
                const SizedBox(width: 10,),
                Text(
                  "${widget.thread.views} views",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300
                  )
                ),
              ],
            ),
            const SizedBox(height: 16,),
        
            // thread.content
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "thread.title-${widget.thread.title}",
                    child: Text(
                      widget.thread.title!,
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                  ),
                  Hero(
                    tag: "thread.content-${widget.thread.content}",
                    child: Text(
                      widget.thread.content!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    "created by ${widget.thread.author!} at ${widget.thread.creationDate}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
        
            // media
            Config.getMediaWidget(widget.thread),
            const SizedBox(height: 10,),
            Divider(color: Colors.grey[800]!),
        
            // posts / comments
            FutureBuilder<List<Post>>(
              future: _futurePosts,
              builder: (c, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface
                      )
                    )
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_,__) => Divider(color: Colors.grey[800]!),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                        },
                        child: PostDisplay(snapshot.data![index]),
                      )
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void updatePostDisplays() {    
    DataController.getPosts(widget.thread.ID!, postIDs: widget.thread.postIDs).then(
      (posts) {
        List<PostDisplay> newList = [];
        for (int i=0; i<posts.length; i++) {
          newList.add(PostDisplay(posts[i]));
        }
        if (postDisplays != newList) {
          setState(() {
            postDisplays = newList;
          });
        }
      }
    );
  }
}
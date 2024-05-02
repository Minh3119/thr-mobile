import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/pages/thread_view.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/thread_preview.dart';

// show list of threads
class CategoryView extends StatefulWidget {
  final Category category;

  const CategoryView(this.category, {super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ThreadPreview> threadPreviews = [];

  @override
  void initState() {
    super.initState();
    updateThreadPreviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(top: 4),
            width: 50,
            child: const Icon(Icons.arrow_back_ios_new, size: 18,),
          ),
        ),
        title: Text(
          "/${widget.category.title}/",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600
          )
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(
                    "${threadPreviews.length} threads",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300
                    )
                  )]
                ),
                const SizedBox(height: 22,),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.category.description!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300
                    )
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 35,),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_,__) => Divider(color: Colors.grey[800]!),
              itemCount: threadPreviews.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // moves to ThreadView
                  navigateToThreadView(
                    widget.category,
                    threadPreviews[index].thread
                  );
                },
                child: threadPreviews[index],
              )
            ),
          ),
        ],
      ),
    );
  }

  void navigateToThreadView(Category category, Thread thread) async {
    await Navigator.push(context, Config.createRoute(ThreadView(category, thread)));
    updateThreadPreviews();
  }

  void updateThreadPreviews() {
    DataController.getThreads(widget.category.ID!, threadIDs: widget.category.threadIDs).then(
      (threads) {
        List<ThreadPreview> newList = [];
        for (int i=0; i<threads.length; i++) {
          newList.add(ThreadPreview(threads[i]));
        }
        if (threadPreviews != newList) {
          setState(() {
            threadPreviews = newList;
          },);
        }
      }
    );
  }
  
}
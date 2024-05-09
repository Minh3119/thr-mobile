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
        surfaceTintColor: Theme.of(context).colorScheme.background,
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
        title: const Text(
          "The House",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600
          )
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // views
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // category title
                      Hero(
                        tag: "category.title-${widget.category.title!}",
                        child: Text(
                          "${widget.category.title}",
                          // style: TextStyle(
                          //   fontSize: 22,
                          //   fontWeight: FontWeight.w600,
                          //   color: Theme.of(context).colorScheme.primary
                          // )
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),

                      // category description
                      Hero(
                        tag: "category.description-${widget.category.description!}",
                        child: Text(
                          widget.category.description!,
                          // style: TextStyle(
                          //   fontSize: 20,
                          //   fontWeight: FontWeight.w300,
                          //   color: Theme.of(context).colorScheme.secondary
                          // )
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10,),
          //Divider(color: Colors.grey[800]!),

          // ThreadPreivews section
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left:26, bottom: 10),
            child: Text(
              "Threads",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withAlpha(210),
                fontSize: 15,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_,__) => const SizedBox(height: 10,),
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
        setState(() {
          threadPreviews = newList;
        },);        
      }
    );
  }
  
}
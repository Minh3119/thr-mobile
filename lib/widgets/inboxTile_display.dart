
import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/widgets/post_display.dart';

class InboxTileDisplay extends StatefulWidget {
  final InboxInfo inboxInfo;

  const InboxTileDisplay(this.inboxInfo, {super.key});

  @override
  State<InboxTileDisplay> createState() => _InboxTileDisplayState();
}

class _InboxTileDisplayState extends State<InboxTileDisplay> {
  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return expandedContainer();
  }

  Widget expandedContainer() => GestureDetector(
    onTap: () {
      setState(() {
        expand = !expand;
      },);
    },
    child: Container(
      // duration: const Duration(seconds: 1),
      // curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: Colors.white70        
        )
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // a button to navigate to the reply's thread here
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text("In ..."),
          ),
          const SizedBox(height: 10,),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: (expand)
            ? Column(
              children: [
                PostDisplay(widget.inboxInfo.userPost),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
                  child: PostDisplay(widget.inboxInfo.replyPost),
                ),
              ],
            )
            : PostDisplay(widget.inboxInfo.replyPost),
          ),
        ]
      )
    ),
  );
}
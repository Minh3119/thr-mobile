import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';

class MediaView extends StatelessWidget {
  final Thread thread;
  const MediaView(this.thread, {super.key});

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
          "go back to thread",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          )
        ),
      ),
      body: Center(child: Config.getMediaWidget(thread))
    );
  }
}
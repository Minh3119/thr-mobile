import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/widgets/video_display.dart';

class Config {
  static String apiURL = "https://qmass.pythonanywhere.com/api";
  static int maxPreviewChars = 37;
  static List<String> fileTypes = ["image", "audio", "video"];

  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.linearToEaseOut));
        
        final offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static String? getFiletype(String? attachmentURL) {
    String? filetype;
    if (attachmentURL != null) {
      List<String> splited = attachmentURL.split(".");
      if (["mp4", "webm"].contains(splited.last)) {
        filetype = Config.fileTypes[2];
      } else if (["mp3", "ogg", "wav", "flac", "alac", "m4a", "aac"].contains(splited.last)) {
        filetype = Config.fileTypes[1];
      }
      else if (["png", "jpeg", "jpg", "webp", "gif", "svg"].contains(splited.last)) {
        filetype = Config.fileTypes[0];
      }
    }
    return filetype;
  }

  static Widget getMediaWidget(var thread) {
    if (thread.fileType == "image") {
      return Image.network(
        thread.attachmentURL!,
        loadingBuilder: (context, child, loadingProgress) {                  
          if (loadingProgress == null) {
            return child; // If no progress, show the child (the image)
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }
        },
      );
    } else if (thread.fileType == "audio") {
      return VideoPlayerScreen(thread.attachmentURL!, true);
    } else if (thread.fileType == "video") {
      return VideoPlayerScreen(thread.attachmentURL!, false);
    } else {
      return const SizedBox(height: 1,);
    }
  }
}
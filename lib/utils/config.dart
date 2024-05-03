import 'package:flutter/material.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/video_display.dart';

class Config {
  static String apiURL = "https://qmass.pythonanywhere.com/api";
  static int categoryPreviewCharsCap = 13;
  static int threadPreviewCharsCap = 37;
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
  
  static Route createScaleRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.linearToEaseOut,
            ),
          ),
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

  static Widget getMediaWidget(var thread) { //this could be thread or post
    if (thread.fileType == "image") {
      return getImage(thread.attachmentURL!);
    } else if (thread.fileType == "audio") {
      return VideoPlayerScreen(thread.attachmentURL!, true);
    } else if (thread.fileType == "video") {
      return VideoPlayerScreen(thread.attachmentURL!, false);
    } else {
      return const SizedBox(height: 1,);
    }
  }

  static Widget getImage(String imageURL) {
    return InteractiveViewer(
      child: () {
        if (SimpleCache.attachments.containsKey(imageURL)) {
          return SimpleCache.attachments[imageURL]!;
        } else {
          Image image = Image.network(
            imageURL,
            loadingBuilder: (context, child, loadingProgress) {                  
              if (loadingProgress == null) {
                return child; // If no progress, show the child (the image)
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
          SimpleCache.attachments[imageURL] = image;
          return image;
        }
      } ()
    );
  }
}
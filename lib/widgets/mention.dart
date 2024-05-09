import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/user_profile.dart';



class UserMention extends StatelessWidget {
  final String username;
  bool color;

  UserMention(this.username, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSheet(context);
      },
      child: (color)
       ? Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(5)
          ),
          child: Text(
            username,
          ),
        )
       : Text(username)
    );
  }

  void showSheet(var context) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      //constraints: const BoxConstraints(minWidth: 500, minHeight: 600, maxHeight: double.infinity),
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      barrierColor: Colors.black87.withOpacity(0.5),
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (context) {
        if (SimpleCache.users.containsKey(username)) {
          return buildSheet(context, SimpleCache.users[username]!);
        }
        return FutureBuilder<User?>(
          future: DataController.getUser(username), 
          builder: (c, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return buildSheet(context, snapshot.data!);
              } else {
                return const Center(child: Text("Unable to fetch user profile."));
              }                  
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface
                )
              );
            }                
          }
        );
      }
    );
  }

  Widget buildSheet(BuildContext context, User user) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
    child: UserProfileCombined(user)
  );
}
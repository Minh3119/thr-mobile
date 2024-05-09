import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';

class UserProfileCombined extends StatelessWidget {
  final User user;

  const UserProfileCombined(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.horizontal_rule_rounded, size: 30),
        UserPicture(user),
        const SizedBox(height: 10,),
        UserInfo(user),
        const SizedBox(height: 8,),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.greenAccent, // Border color
          width: 2.0, // Border width
        ),
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("@${user.name}", style: Theme.of(context).textTheme.titleSmall,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: (user.role == "admin")
                    ? Colors.redAccent
                    : Colors.grey,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Text(user.role, style: Theme.of(context).textTheme.titleSmall,)
              )
            ],
          ),
          const SizedBox(height: 12,),
          Text("'${user.bio}'", style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 15,),
          Text("joined at: ${user.joinDate}"),
          const SizedBox(height: 5,),
          Text("${user.recentActivities.length} activities"),                            
        ],
      )
    );
  }
}

class UserPicture extends StatelessWidget {
  final User user;

  const UserPicture(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    if (user.pictureURL == null) {
      return const SizedBox(height: 1);
    }
    return Flexible(child: Config.getImage(user.pictureURL!));
  }
}
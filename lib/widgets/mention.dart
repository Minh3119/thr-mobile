import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';



class UserMention extends StatelessWidget {
  final String username;
  bool color;

  UserMention(this.username, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          constraints: const BoxConstraints(minWidth: 500),
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))
          ),
          barrierColor: Colors.black87.withOpacity(0.5),
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
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: (color)
           ? Colors.grey[800]
           : null,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Text(
          username,
        ),
      ),
    );
  }

  Widget buildSheet(BuildContext context, User user) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.horizontal_rule_rounded, size: 30),
        (user.pictureURL == null)
          ? const SizedBox(height: 1)
          : Config.getImage(user.pictureURL!),
        const SizedBox(height: 10,),
        Container(
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
        ),
        const SizedBox(height: 10,),
        (user.pictureURL == null) 
          ? const SizedBox(height: 11,)
          : Config.getImage(user.pictureURL!)
      ],
    ),
  );
}
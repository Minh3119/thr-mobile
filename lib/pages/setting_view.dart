import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/user_profile.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  TextEditingController tokenInput = TextEditingController();
  TextEditingController bioInput = TextEditingController();


  bool showRetryMessage = false;

  bool showNetworkError = false;

  String? feedbackContent;

  @override
  void initState() {
    super.initState();
    if (Config.loggedinAccount != null) {
      bioInput.text = Config.loggedinAccount!.bio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Config.loggedinAccount == null)
         ? const Text("Login")
         : const Text("Settings"),
        centerTitle: true,
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
      ),
      body: (Config.loggedinAccount == null)
       ? loginScreen(context)
       : settingScreen(context)
    );
  }

  Widget loginScreen(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Use your account token to login.",
          style: TextStyle(
            fontStyle: FontStyle.italic
          )
        ),
        const Text(
          "Head over to THR website -> profile settings to get token.",
          style: TextStyle(
            fontStyle: FontStyle.italic
          )
        ),
        const SizedBox(height: 30,),
        const Text("Token"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12)
          ),
          child: TextField(
            controller: tokenInput,          
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintText: "Insert your account token here",
              hintStyle: const TextStyle(
                fontSize: 14
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)
              )
            ),
            maxLength: 100,
            onSubmitted: (text) async {
              // request api call, authorize the user
              (Config.useTestToken)
              ? text = Config.testToken
              : "";
              String? username = await DataController.whoami(text);
              if (username == null) {
                setState(() {
                  showRetryMessage = true;
                });
              }
              else {
                setState(() {
                  showRetryMessage = false;
                });
                // get user
                User? user = await DataController.getUser(username);
                if (user == null) {
                  setState(() {
                    showNetworkError = true;
                  });
                } else {
                  Config.loggedinAccount = user;
                  
                  Config.token = text;

                  setState(() {
                    showNetworkError = false;
                    bioInput.text = user.bio;
                  });
                }                
              }
              
            },
          ),
        ),
        (showRetryMessage)
          ? const Text("Wrong token / User not found. Try again.",
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            )
          : const SizedBox(height: 0,),
        (showNetworkError)
          ? const Text("Network error. Unable to fetch your profile.",
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            )
          : const SizedBox(height: 0,),
        
      ],
    ),
  );

  Widget settingScreen(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserPicture(Config.loggedinAccount!),
        const SizedBox(height: 10,),
        UserInfo(Config.loggedinAccount!),
        const SizedBox(height: 40,),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Modify Bio"
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12)
          ),
          child: TextField(
            controller: bioInput,          
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              // hintText: "",
              // hintStyle: const TextStyle(
              //   fontSize: 14
              // ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)
              )
            ),
            maxLength: 100,
            onSubmitted: (text) {              
              // request POST update settings
              updateBioAPIRequest(text);
            },
          ),
        ),
        const SizedBox(height: 10,),
        (feedbackContent != null)
         ? Text(feedbackContent!,
            style: const TextStyle(
              fontStyle: FontStyle.italic
            ),
          )
         : const SizedBox(height: 0,),
      ],
    ),
  );

  Future updateBioAPIRequest(String text) async {
    bool success = await DataController.updateSettings(newBio: text).timeout(const Duration(seconds: 10));
    if (success) {
      setState(() {
        feedbackContent = "Updated bio!";
      });
    }
  }

}
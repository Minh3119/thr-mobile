import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/pages/setting_view.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/inboxTile_display.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  List<InboxInfo> inboxInfos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inbox",
        ),
        centerTitle: true,
        surfaceTintColor: Theme.of(context).colorScheme.background,
      ),
      body: (Config.loggedinAccount == null)
       ? Center(
         child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              "You have to login first.",
              style: TextStyle(
                fontSize: 16
              )
            ),
            const SizedBox(height: 10,),
            GestureDetector(
            onTap: () {
               Navigator.of(context).pushReplacement(Config.createRoute(const SettingView()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 0.5,
                  color: Colors.yellow
                )
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            )
          ],
         ),
       )
       : showInbox()
    );
  }

  Widget showInbox() => //const Center(child: Text("list view here..."),);
  // ListView.separated(
  //   separatorBuilder: (_,__) => const SizedBox(height: 15,), 
  //   itemCount: itemCount
  //   itemBuilder: itemBuilder,
  // );
  FutureBuilder<List<InboxInfo>>(
    future: DataController.getInboxes(null),
    builder: (c, AsyncSnapshot<List<InboxInfo>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface
            )
          )
        );
      } else if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Expanded(
            child: ListView.separated(
              separatorBuilder: (_,__) => const SizedBox(height: 10,),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                },
                child: InboxTileDisplay(snapshot.data![index]),
              )
            ),
          ),
        );
      }
    },
  );
}
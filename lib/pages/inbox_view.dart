import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/pages/setting_view.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/inboxTile_display.dart';

class InboxView extends StatelessWidget {
  InboxView({super.key});

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
      body: FutureBuilder<List<InboxInfo>>(
          future: DataController.getInboxes(null),
          builder: (c, AsyncSnapshot<List<InboxInfo>> snapshot) {
            if (Config.loggedinAccount == null) return requiresLogin(c);
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView.separated(
                  separatorBuilder: (_,__) => const SizedBox(height: 10,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => InboxTileDisplay(snapshot.data![index])
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurface
                )
              );
            }
          },
        ),
    );
  }

  Widget requiresLogin(var context) => Center(
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
            width: 1,
            color: Colors.yellow
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary,
              offset: const Offset(0.6,0.6),
              blurRadius: 0.35,
              spreadRadius: 0
            )
          ]
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
  );
}
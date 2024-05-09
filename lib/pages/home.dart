import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/pages/category_view.dart';
import 'package:thr_client/pages/inbox_view.dart';
import 'package:thr_client/pages/setting_view.dart';
import 'package:thr_client/utils/config.dart';
import 'package:thr_client/utils/data_control.dart';
import 'package:thr_client/widgets/category_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryPreview> categoryPreviews = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    updateCategoryPreviews();
  }

  @override
  Widget build(BuildContext context) {
    // if (categoryPreviews.isEmpty) {
    //   updateCategoryPreviews();
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(Config.createRoute(const InboxView())),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(8),
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
              child: const Icon(Icons.inbox_rounded, size: 22,),
            ),
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: () => Navigator.of(context).push(Config.createRoute(const SettingView())),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(8),
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
              child: const Icon(Icons.person, size: 22,),
            ),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //backgroundColor: Theme.of(context).colorScheme.onPrimary,
            floating: true,
            pinned: true,
            expandedHeight: 200,
            foregroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "The House",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        )
                      ),
                      Text(
                        "\nreloaded",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Colors.brown[200]
                        )
                      )
                    ],
                  ),
                ],
              ),
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
              background: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Image.network("https://picsum.photos/600/500")
              ),
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left:20, bottom: 10),
              child: Text(
                "Categories",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          (_loading)
           ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
           :
          SliverList.separated(
            separatorBuilder:(_,__) => const SizedBox(height: 10,),
            itemCount: categoryPreviews.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // moves to CategoryView
                navigateToCategoryView(categoryPreviews[index].category);
              },
              child: categoryPreviews[index],
            )
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 200,)),
          
          const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Text("client v0.1.6"),
          ),)
        ],
      )
    );
  }

  Scaffold homeBuild1() {
    return Scaffold(
    appBar: AppBar(
      actions: [
        Container(
          padding: const EdgeInsets.only(top: 4),
          width: 50,
          child: const Icon(Icons.account_circle)
        )
      ],
      elevation: 0,
    ),
    body: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 15.0, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "The House",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600
                )
              ),
              Text(
                "\nreloaded",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300
                )
              )
            ],
          ),
        ),
        const SizedBox(height: 40,),
        Expanded(
          child: ListView.separated(
            separatorBuilder:(_,__) => Divider(color: Colors.grey[800]!),
            itemCount: categoryPreviews.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // moves to CategoryView
                navigateToCategoryView(categoryPreviews[index].category);
              },
              child: categoryPreviews[index],
            )
          ),
        ),
        const Text("client v0.2"),
      ],
    ),
  );
  }

  void navigateToCategoryView(Category category) async {
    await Navigator.push(context, Config.createRoute(CategoryView(category)));
    updateCategoryPreviews();
    // Navigator.pushReplacement(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder:(context, animation, secondaryAnimation) => widget,
    //     transitionDuration: const Duration(seconds: 0)
    //   ),
    // );
  }

  void updateCategoryPreviews() {
    DataController.getCategories().then(
      (categories) async {
        // process data for categoryPreviews
        List<CategoryPreview> newList = [];
        for (int i=0; i<categories.length; i++) {
          String text = "New Category";
          if (categories[i].lastActivity != null) {
            var post = await DataController.getPost(categories[i].lastActivity!["id"]);
            text = "last active user @${post.author}\nat ${post.creationDate}";
          }
          newList.add(CategoryPreview(categories[i], text));
        }
        // update the previews        
        setState(() {
          categoryPreviews = newList;
          _loading = false;
        },);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    SimpleCache.disposeAllMediaControllers();
  }
}
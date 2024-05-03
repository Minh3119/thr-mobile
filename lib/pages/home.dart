import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';
import 'package:thr_client/pages/category_view.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //backgroundColor: Theme.of(context).colorScheme.onPrimary,
            floating: true,
            centerTitle: true,
            expandedHeight: 180,
            stretch: true,
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
                  const SizedBox(height: 14,)
                ],
              ),
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.fadeTitle
              ],
              background: Image.network("https://picsum.photos/500/300"),
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
          const SliverToBoxAdapter(child: SizedBox(height: 50,)),
          
          const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Text("client v0.1.5"),
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
        const Text("client v0.1.3"),
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
        if (categoryPreviews != newList) {
          setState(() {
            categoryPreviews = newList;
            _loading = false;
          },);
        }
      }
    );
  }
}
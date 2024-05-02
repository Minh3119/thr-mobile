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
                    fontSize: 34,
                    fontWeight: FontWeight.w600
                  )
                ),
                Text(
                  "\nreloaded",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 55,),
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
          const Text("client v0.1"),
        ],
      ),
    );
  }

  void navigateToCategoryView(Category category) async {
    await Navigator.push(context, Config.createRoute(CategoryView(category)));
    updateCategoryPreviews();
  }

  void updateCategoryPreviews() {
    DataController.getCategories().then(
      (categories) {
        List<CategoryPreview> newList = [];
        for (int i=0; i<categories.length; i++) {
          newList.add(CategoryPreview(categories[i]));
        }
        if (categoryPreviews != newList) {
          setState(() {
            categoryPreviews = newList;
          },);
        }
      }
    );
  }
}
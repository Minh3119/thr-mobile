import 'package:flutter/material.dart';
import 'package:thr_client/models/models.dart';

class CategoryPreview extends StatefulWidget {
  final Category category;
  final String activityInfo;

  CategoryPreview(this.category, this.activityInfo, {super.key});

  @override
  State<CategoryPreview> createState() => _CategoryPreviewState();
}

class _CategoryPreviewState extends State<CategoryPreview> {
  final GlobalKey headerKey = GlobalKey();
  double? _containerWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the width of the container after the layout has been calculated
      final RenderBox renderBox = headerKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _containerWidth = renderBox.size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(left: 5, right: 10, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary,
            offset: const Offset(2, 2),
            blurRadius: 2,
            spreadRadius: 1.5
          )
        ]
      ),
      child: Row(
        children: [
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.folder)
              ),
              SizedBox(height: 15,)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // first row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
    
                  // category title
                  Container(
                    key: headerKey,
                    constraints: const BoxConstraints(
                      minWidth: 10.0,
                      maxWidth: 120.0,
                    ),
                    child: Hero(
                      tag: widget.category.title!,
                      child: Text(
                        widget.category.title!,
                        // style: TextStyle(
                        //   color: Theme.of(context).colorScheme.primary,
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w500
                        // ),
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
    
                  // category description
                  Container(
                    constraints: BoxConstraints(
                      minWidth: 10.0,
                      maxWidth: getTextWidth(),
                    ),
                    child: Hero(
                      tag: widget.category.description!,
                      child: Text(
                        widget.category.description!,
                        // style: TextStyle(
                        //   fontSize: 14,
                        //   color: Theme.of(context).colorScheme.secondary,
                        //   fontWeight: FontWeight.w300
                        // ),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
              // second row | info about lastest activities
              Text(
                widget.activityInfo,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w300
                ),
                maxLines: 2,
                softWrap: true,
              )
            ],
          ),
        ],
      ),
    );
  }

  double getTextWidth() {
    if (_containerWidth != null) {
      return 240 - _containerWidth!;
    }
    return 120;
  }
}
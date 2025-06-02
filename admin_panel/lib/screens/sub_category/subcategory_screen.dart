import 'package:admin_panel/screens/sub_category/components/add_subcategory_form.dart';
import 'package:admin_panel/screens/sub_category/components/subcategory_header.dart';
import 'package:admin_panel/screens/sub_category/components/subcategory_list_section.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';


class SubCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SubCategoryHeader(),
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Sub Categories",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical:
                                defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddSubCategoryForm(context,null);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add New"),
                          ),
                          Gap(20),
                          IconButton(
                              onPressed: () {
                                context.dataProvider.getAllSubCategory(showSnack: true);
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      Gap(defaultPadding),
                      SubCategoryListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

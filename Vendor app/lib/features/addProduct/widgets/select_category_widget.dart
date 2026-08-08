import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/category_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Product? product;
  const SelectCategoryWidget({super.key, required this.product});

  @override
  SelectCategoryWidgetState createState() => SelectCategoryWidgetState();
}

class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    log("category section===>");
    return Consumer<CategoryController>(
      builder: (context, categoryController, child) {
        String selectedCategoryName = getTranslated('select_category', context)!;
        if (categoryController.categoryIndex != null && categoryController.categoryIndex! > 0 && categoryController.categoryList != null) {
          selectedCategoryName = categoryController.categoryList![categoryController.categoryIndex! - 1].name!;
          if (categoryController.subCategoryIndex != null && categoryController.subCategoryIndex! > 0 && categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty) {
            selectedCategoryName += ' > ${categoryController.subCategoryList![categoryController.subCategoryIndex! - 1].name!}';
            if (categoryController.subSubCategoryIndex != null && categoryController.subSubCategoryIndex! > 0 && categoryController.subSubCategoryList != null && categoryController.subSubCategoryList!.isNotEmpty) {
              selectedCategoryName += ' > ${categoryController.subSubCategoryList![categoryController.subSubCategoryIndex! - 1].name!}';
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslated('category', context)!,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            InkWell(
              onTap: () {
                if (categoryController.categoryList == null) return;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault)),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return Consumer<CategoryController>(
                          builder: (context, catController, _) {
                            return Column(
                              children: [
                                AppBar(
                                  title: Text(getTranslated('select_category', context)!, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  automaticallyImplyLeading: false,
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: catController.categoryList!.length,
                                    itemBuilder: (context, catIndex) {
                                      final category = catController.categoryList![catIndex];
                                      final isSelectedCat = catController.categoryIndex == (catIndex + 1);

                                      return ExpansionTile(
                                        key: PageStorageKey<String>('cat_${category.id}'),
                                        initiallyExpanded: isSelectedCat,
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                category.name!,
                                                style: robotoMedium.copyWith(
                                                  color: isSelectedCat ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                catController.setCategoryIndex(catIndex + 1, false);
                                                catController.setSubCategoryIndex(0, false);
                                                catController.setSubSubCategoryIndex(0, true);
                                                Navigator.pop(context);
                                              },
                                              child: Text(getTranslated('select', context)!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                                            ),
                                          ],
                                        ),
                                        children: category.subCategories!.map((subCategory) {
                                          final subIndex = category.subCategories!.indexOf(subCategory);
                                          final isSelectedSub = isSelectedCat && catController.subCategoryIndex == (subIndex + 1);

                                          final subSubCategories = subCategory.subSubCategories ?? [];

                                          if (subSubCategories.isEmpty) {
                                            return ListTile(
                                              title: Padding(
                                                padding: const EdgeInsets.only(left: 16.0),
                                                child: Text(
                                                  subCategory.name!,
                                                  style: robotoRegular.copyWith(
                                                    color: isSelectedSub ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                                                  ),
                                                ),
                                              ),
                                              trailing: TextButton(
                                                onPressed: () {
                                                  catController.setCategoryIndex(catIndex + 1, false);
                                                  catController.getSubCategoryList(context, catIndex + 1, false, null);
                                                  catController.setSubCategoryIndex(subIndex + 1, false);
                                                  catController.setSubSubCategoryIndex(0, true);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(getTranslated('select', context)!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                                              ),
                                            );
                                          }

                                          return ExpansionTile(
                                            key: PageStorageKey<String>('sub_${subCategory.id}'),
                                            initiallyExpanded: isSelectedSub,
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 16.0),
                                                    child: Text(
                                                      subCategory.name!,
                                                      style: robotoMedium.copyWith(
                                                        color: isSelectedSub ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    catController.setCategoryIndex(catIndex + 1, false);
                                                    catController.getSubCategoryList(context, catIndex + 1, false, null);
                                                    catController.setSubCategoryIndex(subIndex + 1, false);
                                                    catController.setSubSubCategoryIndex(0, true);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(getTranslated('select', context)!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                                                ),
                                              ],
                                            ),
                                            children: subSubCategories.map((subSubCategory) {
                                              final subSubIndex = subSubCategories.indexOf(subSubCategory);
                                              final isSelectedSubSub = isSelectedSub && catController.subSubCategoryIndex == (subSubIndex + 1);

                                              return ListTile(
                                                title: Padding(
                                                  padding: const EdgeInsets.only(left: 32.0),
                                                  child: Text(
                                                    subSubCategory.name!,
                                                    style: robotoRegular.copyWith(
                                                      color: isSelectedSubSub ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                                                    ),
                                                  ),
                                                ),
                                                trailing: TextButton(
                                                  onPressed: () {
                                                    catController.setCategoryIndex(catIndex + 1, false);
                                                    catController.getSubCategoryList(context, catIndex + 1, false, null);
                                                    catController.setSubCategoryIndex(subIndex + 1, false);
                                                    catController.getSubSubCategoryList(subIndex + 1, false);
                                                    catController.setSubSubCategoryIndex(subSubIndex + 1, true);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(getTranslated('select', context)!, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedCategoryName,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeMedium),
          ],
        );
      },
    );
  }
}

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
  Widget _buildDropdown<T>({
    required BuildContext context,
    required String title,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .25)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, catController, child) {
        if (catController.categoryList == null) {
          return const SizedBox();
        }

        // Category items
        List<DropdownMenuItem<int>> categoryItems = [
          DropdownMenuItem(
            value: 0,
            child: Text(getTranslated('select_category', context) ?? 'Select Category', style: robotoRegular),
          ),
        ];
        if (catController.categoryList != null) {
          for (int i = 0; i < catController.categoryList!.length; i++) {
            categoryItems.add(DropdownMenuItem(
              value: i + 1,
              child: Text(catController.categoryList![i].name ?? '', style: robotoRegular),
            ));
          }
        }

        // Sub Category items
        List<DropdownMenuItem<int>> subCategoryItems = [
          DropdownMenuItem(
            value: 0,
            child: Text(getTranslated('select_sub_category', context) ?? 'Select Sub Category', style: robotoRegular),
          ),
        ];
        if (catController.subCategoryList != null) {
          for (int i = 0; i < catController.subCategoryList!.length; i++) {
            subCategoryItems.add(DropdownMenuItem(
              value: i + 1,
              child: Text(catController.subCategoryList![i].name ?? '', style: robotoRegular),
            ));
          }
        }

        // Sub Sub Category items
        List<DropdownMenuItem<int>> subSubCategoryItems = [
          DropdownMenuItem(
            value: 0,
            child: Text(getTranslated('select_sub_sub_category', context) ?? 'Select Sub Sub Category', style: robotoRegular),
          ),
        ];
        if (catController.subSubCategoryList != null) {
          for (int i = 0; i < catController.subSubCategoryList!.length; i++) {
            subSubCategoryItems.add(DropdownMenuItem(
              value: i + 1,
              child: Text(catController.subSubCategoryList![i].name ?? '', style: robotoRegular),
            ));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              context: context,
              title: getTranslated('category', context) ?? 'Category',
              value: catController.categoryIndex,
              items: categoryItems,
              onChanged: (val) {
                if (val != null) {
                  catController.setCategoryIndex(val, true);
                  catController.getSubCategoryList(context, val, true, null);
                  catController.setSubCategoryIndex(0, true);
                  catController.setSubSubCategoryIndex(0, true);
                }
              },
            ),

            if (catController.categoryIndex != null && catController.categoryIndex! > 0 && catController.subCategoryList != null && catController.subCategoryList!.isNotEmpty)
              _buildDropdown(
                context: context,
                title: getTranslated('sub_category', context) ?? 'Sub Category',
                value: catController.subCategoryIndex,
                items: subCategoryItems,
                onChanged: (val) {
                  if (val != null) {
                    catController.setSubCategoryIndex(val, true);
                    catController.getSubSubCategoryList(val, true);
                    catController.setSubSubCategoryIndex(0, true);
                  }
                },
              ),

            if (catController.subCategoryIndex != null && catController.subCategoryIndex! > 0 && catController.subSubCategoryList != null && catController.subSubCategoryList!.isNotEmpty)
              _buildDropdown(
                context: context,
                title: getTranslated('sub_sub_category', context) ?? 'Sub Sub Category',
                value: catController.subSubCategoryIndex,
                items: subSubCategoryItems,
                onChanged: (val) {
                  if (val != null) {
                    catController.setSubSubCategoryIndex(val, true);
                  }
                },
              ),
          ],
        );
      },
    );
  }
}

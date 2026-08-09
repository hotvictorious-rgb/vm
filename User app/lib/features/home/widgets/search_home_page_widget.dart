import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SearchHomePageWidget extends StatelessWidget {
  const SearchHomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraExtraSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          height: 50,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Theme.of(context).cardColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(25), // Pill shape like Jumia
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).hintColor, size: 24),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'Search on Victorious MARKET',
                style: textRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

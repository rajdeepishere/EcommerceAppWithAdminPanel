
import 'package:admin_panel/models/product_summary_info.dart';
import 'package:admin_panel/screens/dashboard/components/product_summary_card.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';

import '../../../utility/constants.dart';


class ProductSummarySection extends StatelessWidget {
  const ProductSummarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        int totalProduct = 1;
        totalProduct = context.dataProvider.calculateProductWithQuantity(null);
        int outOfStockProduct = context.dataProvider.calculateProductWithQuantity(0);
        int limitedStockProduct = context.dataProvider.calculateProductWithQuantity(1);
        int otherStockProduct = totalProduct - outOfStockProduct - limitedStockProduct;

        List<ProductSummaryInfo> productSummaryItems = [
          ProductSummaryInfo(
            title: "All Product",
            productsCount: totalProduct,
            svgSrc: "assets/icons/Product.svg",
            color: primaryColor,
            percentage: 100,
          ),
          ProductSummaryInfo(
            title: "Out of Stock",
            productsCount: outOfStockProduct,
            svgSrc: "assets/icons/Product2.svg",
            color: Color(0xFFEA3829),
            percentage: totalProduct != 0 ? (outOfStockProduct / totalProduct) * 100 : 0,
          ),
          ProductSummaryInfo(
            title: "Limited Stock",
            productsCount: limitedStockProduct,
            svgSrc: "assets/icons/Product3.svg",
            color: Color(0xFFECBE23),
            percentage: totalProduct != 0 ? (limitedStockProduct / totalProduct) * 100 : 0,
          ),
          ProductSummaryInfo(
            title: "Other Stock",
            productsCount: otherStockProduct,
            svgSrc: "assets/icons/Product4.svg",
            color: Color(0xFF47e228),
            percentage: totalProduct != 0 ? (otherStockProduct / totalProduct) * 100 : 0,
          ),
        ];

        return Column(
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: productSummaryItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
              ),
              itemBuilder: (context, index) => ProductSummaryCard(
                info: productSummaryItems[index],
                onTap: (productType) {
                  context.dataProvider.filterProductsByQuantity(productType ?? '');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:admin_panel/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/coupon.dart';
import 'add_coupon_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';



class CouponListSection extends StatelessWidget {
  const CouponListSection({
     super.key,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Coupons",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: defaultPadding,
                  // minWidth: 600,
                  columns: [
                    DataColumn(
                      label: Text("Coupon Name"),
                    ),
                    DataColumn(
                      label: Text("Status"),
                    ),
                    DataColumn(
                      label: Text("Type"),
                    ),
                    DataColumn(
                      label: Text("Amount"),
                    ),
                    DataColumn(
                      label: Text("Edit"),
                    ),
                    DataColumn(
                      label: Text("Delete"),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.coupons.length,
                    (index) => couponDataRow(
                      dataProvider.coupons[index],
                      index + 1,
                      edit: () {
                        showAddCouponForm(context, dataProvider.coupons[index]);
                      },
                      delete: () {
                        context.couponCodeProvider.deleteCoupon(dataProvider.coupons[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow couponDataRow(Coupon coupon, int index, {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(index.toString(), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(coupon.couponCode ?? ''),
            ),
          ],
        ),
      ),
      DataCell(Text(coupon.status ?? '')),
      DataCell(Text(coupon.discountType ?? '')),
      DataCell(Text('${coupon.discountAmount}' ?? '')),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}

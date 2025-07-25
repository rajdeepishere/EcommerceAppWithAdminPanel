import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/order.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import 'view_order_form.dart';

class OrderListSection extends StatelessWidget {
  const OrderListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Order",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return DataTable(
                  columnSpacing: defaultPadding,
                  // minWidth: 600,
                  columns: const [
                    DataColumn(
                      label: Text("Customer Name"),
                    ),
                    DataColumn(
                      label: Text("Order Amount"),
                    ),
                    DataColumn(
                      label: Text("Payment"),
                    ),
                    DataColumn(
                      label: Text("Status"),
                    ),
                    DataColumn(
                      label: Text("Date"),
                    ),
                    DataColumn(
                      label: Text("Edit"),
                    ),
                    DataColumn(
                      label: Text("Delete"),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.orders.length,
                    (index) => orderDataRow(
                        dataProvider.orders[index], index + 1, delete: () {
                      context.orderProvider
                          .deleteOrder(dataProvider.orders[index]);
                    }, edit: () {
                      showOrderForm(context, dataProvider.orders[index]);
                    }),
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

DataRow orderDataRow(Order orderInfo, int index,
    {Function? edit, Function? delete}) {
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
              child: Text(orderInfo.userID?.name ?? ''),
            ),
          ],
        ),
      ),
      DataCell(Text('${orderInfo.orderTotal?.total}')),
      DataCell(Text(orderInfo.paymentMethod ?? '')),
      DataCell(Text(orderInfo.orderStatus ?? '')),
      DataCell(Text(orderInfo.orderDate ?? '')),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}

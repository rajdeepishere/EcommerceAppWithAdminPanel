import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/my_notification.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import 'view_notification_form.dart';

class NotificationListSection extends StatelessWidget {
  const NotificationListSection({
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
            "All Notification",
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
                      label: Text("Title"),
                    ),
                    DataColumn(
                      label: Text("Description"),
                    ),
                    DataColumn(
                      label: Text("Send Date"),
                    ),
                    DataColumn(
                      label: Text("View"),
                    ),
                    DataColumn(
                      label: Text("Delete"),
                    ),
                  ],
                  rows: List.generate(
                    dataProvider.notifications.length,
                    (index) => notificationDataRow(
                        dataProvider.notifications[index], index + 1, edit: () {
                      viewNotificationStatics(
                          context, dataProvider.notifications[index]);
                    }, delete: () {
                      context.notificationProvider.deleteNotification(
                          dataProvider.notifications[index]);
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

DataRow notificationDataRow(MyNotification notificationInfo, int index,
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
              child: Text(notificationInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(notificationInfo.description ?? '')),
      DataCell(Text(notificationInfo.createdAt ?? '')),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: const Icon(
            Icons.remove_red_eye_sharp,
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

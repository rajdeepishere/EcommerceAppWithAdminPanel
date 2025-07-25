import 'package:admin_panel/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';

class SendNotificationForm extends StatelessWidget {
  const SendNotificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: context.notificationProvider.sendNotificationFormKey,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          width: size.width * 0.5,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(defaultPadding),
              CustomTextField(
                controller: context.notificationProvider.titleCtrl,
                labelText: 'Enter Notification Title ....',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Title name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: context.notificationProvider.descriptionCtrl,
                labelText: 'Enter Notification Description ....',
                lineNumber: 3,
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description ';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: context.notificationProvider.imageUrlCtrl,
                labelText: 'Enter Notification Image Url ....',
                onSave: (val) {},
              ),
              const Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.notificationProvider.sendNotificationFormKey
                          .currentState!
                          .validate()) {
                        context.notificationProvider.sendNotificationFormKey
                            .currentState!
                            .save();
                        context.notificationProvider.sendNotification();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void sendNotificationFormForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Send Notification'.toUpperCase(),
                style: const TextStyle(color: primaryColor))),
        content: const SendNotificationForm(),
      );
    },
  );
}

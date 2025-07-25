import 'package:admin_panel/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../models/poster.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/category_image_card.dart';
import '../provider/poster_provider.dart';

class PosterSubmitForm extends StatelessWidget {
  final Poster? poster;

  const PosterSubmitForm({super.key, this.poster});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.posterProvider.setDataForUpdatePoster(poster);
    return SingleChildScrollView(
      child: Form(
        key: context.posterProvider.addPosterFormKey,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(defaultPadding),
              Consumer<PosterProvider>(
                builder: (context, posterProvider, child) {
                  return CategoryImageCard(
                    labelText: "Poster",
                    imageFile: posterProvider.selectedImage,
                    imageUrlForUpdateImage: poster?.imageUrl,
                    onTap: () {
                      posterProvider.pickImage();
                    },
                  );
                },
              ),
              const Gap(defaultPadding),
              CustomTextField(
                controller: context.posterProvider.posterNameCtrl,
                labelText: 'Poster Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a poster name';
                  }
                  return null;
                },
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
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: const Text('Cancel'),
                  ),
                  const Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.posterProvider.addPosterFormKey.currentState!
                          .validate()) {
                        context.posterProvider.addPosterFormKey.currentState!
                            .save();
                        context.posterProvider.submitPoster();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
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
void showAddPosterForm(BuildContext context, Poster? poster) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Add Poster'.toUpperCase(),
                style: const TextStyle(color: primaryColor))),
        content: PosterSubmitForm(poster: poster),
      );
    },
  );
}

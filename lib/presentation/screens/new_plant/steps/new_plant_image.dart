import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';


import 'package:my_tflit_app/data/models/themes_model.dart';
import 'package:my_tflit_app/data/providers/theme_provider.dart';
import 'package:my_tflit_app/logic/image_picker/image_picker.dart';
import 'package:my_tflit_app/logic/localization/localization_handler.dart';
import 'package:my_tflit_app/presentation/widgets/elevated_notification.dart';
import 'package:my_tflit_app/presentation/widgets/buttons/appbar_leading_button.dart';
import 'new_pnat_name.dart';

class AddNewPlantImage extends ConsumerWidget {
  const AddNewPlantImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);

    LocalizationHandler localizationHandler = LocalizationHandler();

    double dividerWidth = (localizationHandler
        .getMessage(ref, "add_plant_gallery")
        .length +
        localizationHandler.getMessage(ref, "add_plant_camera").length)
        .toDouble() /
        2;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        leading: LeadingButton(
          iconColor: theme.textColor,
          backgroundColor: theme.primaryColor,
        ),
        title: Text(
          "${localizationHandler.getMessage(ref, "add_plant")} (1/3)"
              .toUpperCase(),
          style: GoogleFonts.rubik(
            color: theme.textColor,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Choose a picture
                  Lottie.asset("assets/animations/taking_a_picture.json",
                      width: 128, height: 128),

                  Column(
                    children: [
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_choose_picture"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_picture_description"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: theme.primaryColor),
                    width: MediaQuery.of(context).size.width - 50,
                    height: 4,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: theme.secondaryColor,
                        ),
                        onPressed: () async {
                          Uint8List? imageBytes = await ImageSelector()
                              .pickImage(ImageSource.gallery);

                          if (context.mounted) {
                            if (imageBytes == null) {
                              showElevatedNotification(
                                  context,
                                  localizationHandler.getMessage(
                                      ref, "add_plant_invalid_image"),
                                  theme.secondaryColor);
                              return;
                            }

                            Navigator.push(
                              context,
                              PageTransition(
                                child: AddNewPlantName(
                                  imageBytes: imageBytes,
                                ),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.image,
                          color: theme.textColor,
                          size: 20,
                        ),
                        label: Text(
                          localizationHandler.getMessage(
                              ref, "add_plant_gallery"),
                          style: GoogleFonts.openSans(
                            color: theme.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: dividerWidth,
                        height: 3,
                        decoration: BoxDecoration(color: theme.textColor),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        localizationHandler.getMessage(ref, "or").toUpperCase(),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: dividerWidth,
                        height: 3,
                        decoration: BoxDecoration(color: theme.textColor),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: theme.secondaryColor,
                        ),
                        onPressed: () async {
                          Uint8List? imageBytes = await ImageSelector()
                              .pickImage(ImageSource.camera);

                          if (context.mounted) {
                            if (imageBytes == null) {
                              showElevatedNotification(
                                  context,
                                  localizationHandler.getMessage(
                                      ref, "add_plant_invalid_image"),
                                  theme.secondaryColor);
                              return;
                            }

                            Navigator.push(
                              context,
                              PageTransition(
                                child: AddNewPlantName(
                                  imageBytes: imageBytes,
                                ),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: theme.textColor,
                          size: 20,
                        ),
                        label: Text(
                          localizationHandler.getMessage(
                              ref, "add_plant_camera"),
                          style: GoogleFonts.openSans(
                            color: theme.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';


import '../../../../data/models/themes_model.dart';
import '../../../../data/providers/theme_provider.dart';
import '../../../../logic/localization/localization_handler.dart';
import '../../../widgets/buttons/appbar_leading_button.dart';
import '../../../widgets/elevated_notification.dart';
import 'new_plant_variable.dart';

class AddNewPlantName extends HookConsumerWidget {
  final Uint8List imageBytes;
  const AddNewPlantName({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);

    TextEditingController nameController = useTextEditingController();

    LocalizationHandler localizationHandler = LocalizationHandler();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        leading: LeadingButton(
          iconColor: theme.textColor,
          backgroundColor: theme.primaryColor,
        ),
        title: Text(
          "${localizationHandler.getMessage(ref, "add_plant")} (2/3)"
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
                  Lottie.asset("assets/animations/name_your_plant.json",
                      width: 128, height: 128),

                  Column(
                    children: [
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_choose_name"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_choose_name_description"),
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

                  Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: nameController,
                      maxLines: 1,
                      maxLength: 24,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        hintText: localizationHandler.getMessage(
                            ref, "add_plant_display_name"),
                        hintStyle: TextStyle(color: theme.textColor),
                        contentPadding: const EdgeInsets.all(8.0),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      cursorColor: theme.primaryColor,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      String plantName = nameController.text;
                      if (plantName.isEmpty) {
                        showElevatedNotification(
                          context,
                          localizationHandler.getMessage(
                              ref, "add_plant_choose_name_warning"),
                          theme.secondaryColor,
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        PageTransition(
                          child: AddNewPlantVariables(
                            plantName: plantName,
                            imageBytes: imageBytes,
                          ),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12.0),
                      backgroundColor: theme.primaryColor,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: theme.textColor,
                      size: 20,
                    ),
                    label: Text(
                      localizationHandler.getMessage(ref, "next_step"),
                      style: GoogleFonts.openSans(
                        color: theme.textColor,
                        fontSize: 14,
                      ),
                    ),
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

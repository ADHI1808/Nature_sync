import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


import '../../../../data/models/plant_model.dart';
import '../../../../data/models/themes_model.dart';
import '../../../../data/providers/plants_providers.dart';
import '../../../../data/providers/theme_provider.dart';
import '../../../../logic/localization/localization_handler.dart';
import '../../../widgets/buttons/appbar_leading_button.dart';
import '../../../widgets/elevated_notification.dart';

class AddNewPlantVariables extends HookConsumerWidget {
  final String plantName;
  final Uint8List imageBytes;
  const AddNewPlantVariables(
      {super.key, required this.plantName, required this.imageBytes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    LocalizationHandler localizationHandler = LocalizationHandler();
    TextEditingController variableController = useTextEditingController();
    TextEditingController valueController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        leading: LeadingButton(
          iconColor: theme.textColor,
          backgroundColor: theme.primaryColor,
        ),
        title: Text(
          "${localizationHandler.getMessage(ref, "add_plant")} (3/3)"
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
                  Lottie.asset("assets/animations/custom_variable.json",
                      width: 128, height: 128),

                  Column(
                    children: [
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_custom_variable"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        localizationHandler.getMessage(
                            ref, "add_plant_custom_variable_description"),
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
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextField(
                      controller: variableController,
                      maxLines: 1,
                      maxLength: 16,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        hintText:
                        localizationHandler.getMessage(ref, "variable"),
                        hintStyle: TextStyle(color: theme.textColor),
                        contentPadding: const EdgeInsets.all(8.0),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      cursorColor: theme.primaryColor,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: theme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextField(
                      controller: valueController,
                      maxLines: 1,
                      maxLength: 1024,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        hintText: localizationHandler.getMessage(ref, "value"),
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
                      Map<String, String> variables =
                      variableController.text.isNotEmpty
                          ? {
                        variableController.text.toLowerCase():
                        valueController.text
                      }
                          : {};
                      Plant plant = Plant(imageBytes, variables, null);

                      if (!Hive.box('plants').containsKey(plantName)) {
                        Hive.box('plants').put(plantName, plant);

                        ref.invalidate(plantsProvider);
                        showElevatedNotification(context,
                            "Added the new plant!", theme.primaryColor);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } else {
                        showElevatedNotification(
                          context,
                          "A plant with that name already exists.",
                          theme.secondaryColor,
                        );
                      }
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
                      localizationHandler.getMessage(ref, "finish"),
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

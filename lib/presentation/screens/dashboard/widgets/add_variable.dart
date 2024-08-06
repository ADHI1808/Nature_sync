import 'package:my_tflit_app/presentation/screens/dashboard/widgets/view_card.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import '../../../../data/models/plant_model.dart';
import '../../../../data/models/themes_model.dart';
import '../../../../data/providers/plants_providers.dart';
import '../../../../data/providers/theme_provider.dart';
import '../../../../logic/localization/localization_handler.dart';
import '../../../widgets/elevated_notification.dart';

class AddPlantVariable extends HookConsumerWidget {
  final String title;
  final Map? variables;

  const AddPlantVariable({
    super.key,
    required this.title,
    required this.variables,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);

    LocalizationHandler localizationHandler = LocalizationHandler();

    TextEditingController variableController = useTextEditingController();
    TextEditingController valueController = useTextEditingController();

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
          ),
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height / 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/animations/custom_variable.json",
                      width: 96, height: 96),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
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
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(color: theme.primaryColor),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Material(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
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
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: theme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Material(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      child: TextField(
                        controller: valueController,
                        maxLines: 1,
                        maxLength: 1024,
                        style: TextStyle(color: theme.textColor),
                        decoration: InputDecoration(
                          hintText:
                          localizationHandler.getMessage(ref, "value"),
                          hintStyle: TextStyle(color: theme.textColor),
                          contentPadding: const EdgeInsets.all(8.0),
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        cursorColor: theme.primaryColor,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Plant plant = Hive.box('plants').get(title);

                            String variable = valueController.text,
                                value = valueController.text;

                            if (variable.isEmpty || value.isEmpty) {
                              showElevatedNotification(
                                  context,
                                  localizationHandler.getMessage(
                                      ref, "add_variable_invalid_input"),
                                  Colors.redAccent.shade700);
                              return;
                            }

                            plant.addVariable(
                                variableController.text.toLowerCase(),
                                valueController.text);

                            Hive.box('plants').put(title, plant);

                            ref
                              ..read(viewCardPanelProvider.notifier).state = -1
                              ..invalidate(viewCardPanelProvider);

                            if (variableController.text.toLowerCase() ==
                                localizationHandler.getMessage(
                                    ref, "description")) {
                              ref.invalidate(plantsProvider);
                            }

                            showElevatedNotification(
                                context,
                                localizationHandler.getMessage(
                                    ref, "add_variable_success"),
                                theme.primaryColor);
                            Navigator.pop(context);
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
                            "${localizationHandler.getMessage(ref, "add")} ",
                            style: GoogleFonts.openSans(
                              color: theme.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12.0),
                          backgroundColor: theme.secondaryColor,
                        ),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

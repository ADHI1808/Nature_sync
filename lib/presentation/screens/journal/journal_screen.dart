import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tflit_app/presentation/screens/journal/providers/state_providers.dart';


import '../../../data/models/themes_model.dart';
import '../../../data/providers/theme_provider.dart';
import '../../../logic/localization/localization_handler.dart';
import '../../../logic/setting_logic/setting_handler.dart';
import '../../widgets/buttons/appbar_leading_button.dart';
import '../../widgets/elevated_notification.dart';

class JournalScreen extends HookConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    bool isSaving = ref.watch(inSavingStateProvider);

    SettingsHandler settingsHandler = SettingsHandler();
    LocalizationHandler localizationHandler = LocalizationHandler();

    TextEditingController journalController = useTextEditingController(
        text: settingsHandler.getValue('journal_value'));
    journalController.selection =
        TextSelection.collapsed(offset: journalController.text.length);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        leading: LeadingButton(
          iconColor: theme.textColor,
          backgroundColor: theme.primaryColor,
        ),
        title: Text(
          localizationHandler.getMessage(ref, "journal").toUpperCase(),
          style: GoogleFonts.rubik(
            color: theme.textColor,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            ref.read(inSavingStateProvider.notifier).state = false;
            //cancelTimer.cancel();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizationHandler.getMessage(ref, "journal_title"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isSaving
                            ? () {}
                            : () {
                          settingsHandler.setValue(
                              "journal_value", journalController.text);
                          showElevatedNotification(
                              context,
                              localizationHandler.getMessage(
                                  ref, "journal_update_successful"),
                              theme.primaryColor);

                          ref.read(inSavingStateProvider.notifier).state =
                          true;

                          Timer(const Duration(seconds: 5), () {
                            if (context.mounted) {
                              ref
                                  .read(inSavingStateProvider.notifier)
                                  .state = false;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          backgroundColor: isSaving
                              ? theme.primaryColor
                              : theme.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Icon(
                          isSaving ? Icons.check : Icons.save,
                          color: theme.textColor,
                          size: 24,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Journal Box
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: theme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: journalController,
                      maxLines: MediaQuery.of(context).size.height ~/ 40,
                      style: TextStyle(color: theme.textColor),
                      decoration: InputDecoration(
                        hintText: localizationHandler.getMessage(
                            ref, "journal_take_notes"),
                        hintStyle: TextStyle(color: theme.textColor),
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        focusedBorder: InputBorder.none,
                        fillColor: theme.secondaryColor,
                        filled: true,
                      ),
                      cursorColor: theme.primaryColor,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      localizationHandler.getMessage(ref, "journal_disclaimer"),
                      style: GoogleFonts.openSans(
                        color: theme.textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
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

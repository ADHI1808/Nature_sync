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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  // Your code to make the screen empty
                  const SizedBox(height: 16),
                  // Optionally, add a placeholder or a message
                  Text(
                    "No content available",
                    style: GoogleFonts.openSans(
                      color: theme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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


import 'package:my_tflit_app/logic/localization/localization_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tflit_app/data/models/themes_model.dart';
import 'package:my_tflit_app/data/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmDialog extends ConsumerWidget {
  final String text;
  final Function? confirm;

  const ConfirmDialog({super.key, required this.text, required this.confirm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);

    LocalizationHandler localizationHandler = LocalizationHandler();

    return AlertDialog(
      title: Center(
        child: Text(
          localizationHandler.getMessage(ref, "alert").toUpperCase(),
          style: GoogleFonts.rubik(
            color: theme.textColor,
            fontSize: 16,
          ),
        ),
      ),
      content: Text(
        text,
        style: GoogleFonts.openSans(
          color: theme.textColor,
          fontSize: 14,
        ),
      ),
      backgroundColor: theme.backgroundColor,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        IconButton(
          icon: Icon(Icons.done, size: 20, color: theme.primaryColor),
          onPressed: () => confirm!(),
        ),
        IconButton(
          icon: Icon(Icons.close, size: 20, color: Colors.red.shade800),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

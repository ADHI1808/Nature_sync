import 'dart:typed_data';

import 'package:my_tflit_app/data/models/themes_model.dart';
import 'package:my_tflit_app/data/providers/theme_provider.dart';
import 'package:my_tflit_app/logic/limit_string.dart';
import 'package:my_tflit_app/logic/localization/localization_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_tflit_app/presentation/screens/dashboard/widgets/view_card.dart';

class ListViewCard extends ConsumerWidget {
  final Uint8List backgroundImage;
  final String title;
  final String? aiTips;
  final Map? variables;

  const ListViewCard({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.aiTips,
    required this.variables,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    LocalizationHandler localizationHandler = LocalizationHandler();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: 105,
          child: Stack(
            children: [
              Image.memory(
                backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(1.0),
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (variables != null &&
                              variables![localizationHandler.getMessage(
                                  ref, "description")] !=
                                  null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.note_alt,
                                  color: theme.primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  limitString(
                                      variables![localizationHandler.getMessage(
                                          ref, "description")],
                                      32),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.black.withOpacity(0.5),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(4.0),
                  //     child: Icon(
                  //       synced ? Icons.sync : Icons.sync_disabled,
                  //       color: synced ? theme.primaryColor : Colors.redAccent,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ViewCard(
                        backgroundImage: backgroundImage,
                        title: title,
                        aiTips: aiTips,
                        variables: variables,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
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

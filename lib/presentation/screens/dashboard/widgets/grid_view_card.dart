import 'dart:typed_data';

import 'package:my_tflit_app/presentation/screens/dashboard/widgets/view_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../data/models/themes_model.dart';
import '../../../../data/providers/theme_provider.dart';
import '../../../../logic/limit_string.dart';
import '../../../../logic/localization/localization_handler.dart';

class GridViewCard extends ConsumerWidget {
  final Uint8List backgroundImage;
  final String title;
  final String? aiTips;
  final Map? variables;

  const GridViewCard({
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 25,
        height: MediaQuery.of(context).size.width / 2,
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                      24),
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
    );
  }
}

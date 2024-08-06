import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tflit_app/presentation/screens/dashboard/providers/viewtype_provider.dart';
import 'package:my_tflit_app/presentation/screens/dashboard/widgets/grid_view_card.dart';
import 'package:my_tflit_app/presentation/screens/dashboard/widgets/list_view_card.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Ml/LeafScanner.dart';
import '../../../data/models/themes_model.dart';
import '../../../data/providers/plants_providers.dart';
import '../../../data/providers/theme_provider.dart';
import '../../../logic/localization/localization_handler.dart';
import '../../../logic/setting_logic/setting_handler.dart';
import '../journal/journal_screen.dart';
import '../new_plant/new_plant_screen.dart';
import '../settings/setting_screen.dart';
import 'models/viewtype_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    Map plants = ref.watch(plantsProvider);
    SettingsHandler settingsHandler = SettingsHandler();
    LocalizationHandler localizationHandler = LocalizationHandler();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              "assets/newlogo.jpg",
              width: 192,
              height: 48,
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                color: theme.secondaryColor,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const AddNewPlantScreen(),
                        ),
                      );
                    },
                    color: theme.textColor,
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const JournalScreen(),
                        ),
                      );
                    },
                    color: theme.textColor,
                    icon: const Icon(
                      Icons.menu_book_rounded,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const SettingsScreen(),
                        ),
                      );
                    },
                    color: theme.textColor,
                    icon: Icon(
                      Icons.settings,
                      color: theme.textColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.75,
                      child: Text(
                        localizationHandler.getMessage(ref, "dashboard_title"),
                        style: GoogleFonts.openSans(
                          color: theme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ref.watch(viewTypeProvider) == ViewType.list
                                ? theme.primaryColor
                                : theme.secondaryColor,
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              settingsHandler.setValue(
                                  "plants_viewtype", ViewType.list);
                              ref.invalidate(viewTypeProvider);
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: theme.textColor,
                            icon: const Icon(
                              Icons.view_list,
                              size: 20,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ref.watch(viewTypeProvider) == ViewType.grid
                                ? theme.primaryColor
                                : theme.secondaryColor,
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(16)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              settingsHandler.setValue(
                                  "plants_viewtype", ViewType.grid);
                              ref.invalidate(viewTypeProvider);
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: theme.textColor,
                            icon: const Icon(
                              Icons.grid_view_rounded,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Cards
              if (ref.watch(viewTypeProvider) == ViewType.grid) ...[
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (var entry in plants.entries)
                      GridViewCard(
                        backgroundImage: entry.value.image,
                        title: entry.key,
                        aiTips: entry.value.aiTips,
                        variables: entry.value.variables,
                      ),
                  ],
                ),
              ],

              if (ref.watch(viewTypeProvider) == ViewType.list) ...[
                for (var entry in plants.entries)
                  ListViewCard(
                    backgroundImage: entry.value.image,
                    title: entry.key,
                    aiTips: entry.value.aiTips,
                    variables: entry.value.variables,
                  ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const LeafScanner(),
            ),
          );
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.document_scanner_rounded, color: theme.textColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

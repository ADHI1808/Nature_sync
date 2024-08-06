import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/models/plant_model.dart';
import '../../../../data/models/themes_model.dart';
import '../../../../data/providers/plants_providers.dart';
import '../../../../data/providers/theme_provider.dart';
import '../../../../logic/ai_handler/ai_handler.dart';
import '../../../../logic/localization/localization_handler.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/elevated_notification.dart';
import '../providers/edittingstate_provider.dart';
import 'add_variable.dart';

final viewCardPanelProvider = StateProvider<int>((ref) => 0);
final regeneratingStateProvider = StateProvider<int>((ref) => 0);

class ViewCard extends HookConsumerWidget {
  final Uint8List backgroundImage;
  final String title;
  final String? aiTips;
  final Map? variables;

  const ViewCard({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.aiTips,
    required this.variables,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    bool editMode = ref.watch(editingStateProvider);

    LocalizationHandler localizationHandler = LocalizationHandler();
    TextEditingController titleController =
    useTextEditingController(text: title);

    final aiTipsProvider =
    StateProvider<String?>((ref) => Hive.box('plants').get(title).aiTips);

    var panelState = ref.watch(viewCardPanelProvider);
    var tipsText = ref.watch(aiTipsProvider);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(
                  backgroundImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      editMode
                          ? SizedBox(
                        width: MediaQuery.of(context).size.width / 1.25,
                        height: 50,
                        child: Material(
                          color: theme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                          child: TextField(
                            controller: titleController,
                            maxLines: 1,
                            maxLength: 24,
                            style: TextStyle(color: theme.textColor),
                            decoration: InputDecoration(
                              hintText: localizationHandler.getMessage(
                                  ref, "add_plant_display_name"),
                              hintStyle:
                              TextStyle(color: theme.textColor),
                              contentPadding: const EdgeInsets.all(8.0),
                              border: InputBorder.none,
                              counterText: "",
                            ),
                            cursorColor: theme.primaryColor,
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      )
                          : Text(
                        title,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: theme.secondaryColor,
                            ),
                            onPressed: () {
                              editMode = !editMode;
                              ref.read(editingStateProvider.notifier).state =
                                  editMode;

                              String newText = titleController.text;
                              if (!editMode &&
                                  newText != title &&
                                  newText.isNotEmpty) {
                                Hive.box('plants')
                                    .get(title)
                                    .update(title, newText);
                                ref.invalidate(plantsProvider);

                                showElevatedNotification(
                                    context,
                                    localizationHandler
                                        .getMessage(ref,
                                        "view_plants_update_notification")
                                        .replaceAll("%plant_name%", newText),
                                    theme.primaryColor);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            },
                            icon: Icon(
                              !editMode ? Icons.edit_note_rounded : Icons.save,
                              color: !editMode
                                  ? Colors.cyanAccent
                                  : theme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: theme.secondaryColor,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AddPlantVariable(
                                  title: title, variables: variables),
                            ),
                            icon: Icon(
                              Icons.playlist_add_rounded,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: theme.secondaryColor,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  text: localizationHandler
                                      .getMessage(ref,
                                      "view_plants_delete_confirmation")
                                      .replaceAll("%plant_name%", title),
                                  confirm: () {
                                    Hive.box('plants').delete(title);
                                    ref.invalidate(plantsProvider);

                                    showElevatedNotification(
                                      context,
                                      localizationHandler
                                          .getMessage(ref,
                                          "view_plants_delete_notification")
                                          .replaceAll("%plant_name%", title),
                                      theme.primaryColor,
                                    );
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          // IconButton(
                          //   style: ElevatedButton.styleFrom(
                          //     padding: const EdgeInsets.all(8.0),
                          //     backgroundColor: theme.secondaryColor,
                          //   ),
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     synced
                          //         ? Icons.sync_rounded
                          //         : Icons.sync_disabled_rounded,
                          //     color: synced ? theme.primaryColor : Colors.red,
                          //     size: 20,
                          //   ),
                          // ),
                          // const SizedBox(width: 4),
                          IconButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              backgroundColor: theme.secondaryColor,
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => ref
                                .read(viewCardPanelProvider.notifier)
                                .state = 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: panelState == 0
                                    ? theme.primaryColor
                                    : theme.secondaryColor,
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  localizationHandler.getMessage(
                                      ref, "variables"),
                                  style: TextStyle(
                                    color: theme.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(viewCardPanelProvider.notifier)
                                .state = 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: panelState == 1
                                    ? theme.primaryColor
                                    : theme.secondaryColor,
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  localizationHandler.getMessage(ref, "tips"),
                                  style: TextStyle(
                                    color: theme.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (panelState == 0 &&
                          variables != null &&
                          variables!.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var variable in variables!.entries)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (editMode)
                                      SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: IconButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            theme.secondaryColor,
                                          ),
                                          onPressed: () {
                                            Hive.box('plants')
                                                .get(title)
                                                .removeVariable(variable.key);

                                            Hive.box('plants').put(title,
                                                Hive.box('plants').get(title));

                                            ref
                                              ..invalidate(editingStateProvider)
                                              ..read(editingStateProvider
                                                  .notifier)
                                                  .state =
                                              true; // updating entries
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      width:
                                      (MediaQuery.of(context).size.width -
                                          100) /
                                          2,
                                      child: Text(
                                        variable.key + ":",
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                      width:
                                      (MediaQuery.of(context).size.width -
                                          (editMode ? 150 : 100)) /
                                          2,
                                      child: Text(
                                        variable.value,
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      if (panelState == 1) ...[
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (ref.watch(regeneratingStateProvider) == 1) {
                                return;
                              }

                              ref
                                  .read(regeneratingStateProvider.notifier)
                                  .state = 1;

                              ref.read(aiTipsProvider.notifier).state =
                              await OpenAI().prompt(localizationHandler
                                  .getMessage(ref, "ai_prompt")
                                  .replaceAll("%plant_name%", title));
                              ref
                                  .read(regeneratingStateProvider.notifier)
                                  .state = 0;

                              Plant plant = Hive.box('plants').get(title);
                              plant.aiTips = ref.watch(aiTipsProvider);
                              Hive.box('plants').put(title, plant);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.secondaryColor,
                              ),
                              width: MediaQuery.of(context).size.width / 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.autorenew,
                                      color: theme.primaryColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      localizationHandler.getMessage(
                                          ref, "regenerate"),
                                      style: TextStyle(
                                        color: theme.textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (ref.watch(regeneratingStateProvider) == 0 &&
                                    tipsText != null) ...[
                                  Text(
                                    tipsText,
                                    style: TextStyle(
                                      color: theme.textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                    ref.watch(regeneratingStateProvider) ==
                                        0
                                        ? theme.primaryColor
                                        : Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

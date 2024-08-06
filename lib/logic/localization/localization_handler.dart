import 'package:my_tflit_app/logic/localization/providers/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import 'languages/de_lang.dart';
import 'languages/en_lang.dart';
import 'languages/es_lang.dart';
import 'languages/fr_lang.dart';
import 'languages/it_lang.dart';
import 'languages/ro_lang.dart';

class LocalizationHandler {
  String getMessage(WidgetRef ref, String id) {
    String locale = ref.watch(languageProvider);
    switch (locale) {
      case "de":
        return de[id] ?? "%undefined%";
      case "en":
        return en[id] ?? "%undefined%";
      case "es":
        return es[id] ?? "%undefined%";
      case "fr":
        return fr[id] ?? "%undefined%";
      case "it":
        return it[id] ?? "%undefined%";
      case "ro":
        return ro[id] ?? "%undefined%";
    }
    return "%undefined%";
  }
}

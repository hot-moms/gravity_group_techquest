import 'package:flutter/widgets.dart';
import 'package:gravity_group_techquest/src/core/localization/app_localization.dart';

extension LocalizationX on BuildContext {
  GeneratedLocalization get localized =>
      AppLocalization.stringOf<GeneratedLocalization>(this);
}

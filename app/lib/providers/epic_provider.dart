import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

final currentEpicProvider = StateProvider<EpicTheme>(
  (ref) => EpicTheme.ramayana,
);

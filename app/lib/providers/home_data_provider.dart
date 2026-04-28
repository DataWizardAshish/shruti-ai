import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_data.dart';
import '../models/daily_shloka.dart';
import 'providers.dart';

final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  return ref.watch(apiServiceProvider).getHome(deviceId);
});

final dailyShlokaProvider = FutureProvider<DailyShloka>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  return ref.watch(apiServiceProvider).getDailyShloka(deviceId: deviceId);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journey_data.dart';
import '../models/episode.dart';
import 'providers.dart';

final journeyProvider = FutureProvider<JourneyData>((ref) async {
  final deviceId = await ref.watch(deviceIdProvider.future);
  return ref.watch(apiServiceProvider).getJourney(deviceId);
});

final episodesProvider = FutureProvider<List<Episode>>((ref) async {
  return ref.watch(apiServiceProvider).getEpisodes();
});

class DailyShloka {
  final String textDevanagari;
  final String transliteration;
  final String meaningContext;

  const DailyShloka({
    required this.textDevanagari,
    required this.transliteration,
    required this.meaningContext,
  });

  // Backend DB fields: sanskrit_devanagari, sanskrit_transliteration, meaning_context
  factory DailyShloka.fromJson(Map<String, dynamic> json) => DailyShloka(
        textDevanagari: (json['sanskrit_devanagari'] as String?) ?? '',
        transliteration: (json['sanskrit_transliteration'] as String?) ?? '',
        meaningContext: (json['meaning_context'] as String?) ?? '',
      );
}

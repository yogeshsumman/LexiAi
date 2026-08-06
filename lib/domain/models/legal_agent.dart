import 'package:equatable/equatable.dart';

import 'practice_area.dart';

/// Domain entity describing an AI lawyer agent.
///
/// This is the canonical model the UI depends on. The [data] layer maps
/// backend payloads onto this entity so UI code never touches raw JSON.
class LegalAgent extends Equatable {
  const LegalAgent({
    required this.id,
    required this.name,
    required this.title,
    required this.emoji,
    required this.practiceAreas,
    required this.rating,
    required this.consultations,
    required this.successRate,
    required this.responseTime,
    required this.languages,
    required this.bio,
    required this.gradientIndex,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String title;
  final String emoji;
  final List<PracticeArea> practiceAreas;
  final double rating;
  final int consultations;
  final double successRate; // 0..1
  final Duration responseTime;
  final List<String> languages;
  final String bio;
  final int gradientIndex;
  final bool isFeatured;

  String get initials => name
      .split(' ')
      .where((e) => e.isNotEmpty)
      .map((e) => e[0])
      .take(2)
      .join()
      .toUpperCase();

  bool matches(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        title.toLowerCase().contains(q) ||
        practiceAreas.any((a) => a.label.toLowerCase().contains(q));
  }

  @override
  List<Object?> get props => [id];
}

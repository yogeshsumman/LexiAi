import 'package:flutter/material.dart';

/// The practice areas an AI agent can specialize in.
enum PracticeArea {
  corporate('Corporate & Commercial', Icons.business_rounded),
  criminal('Criminal Defense', Icons.gavel_rounded),
  family('Family Law', Icons.family_restroom_rounded),
  ip('Intellectual Property', Icons.lightbulb_rounded),
  tax('Tax & Estate', Icons.receipt_long_rounded),
  immigration('Immigration', Icons.flight_takeoff_rounded),
  employment('Employment & Labor', Icons.work_rounded),
  realEstate('Real Estate', Icons.apartment_rounded);

  const PracticeArea(this.label, this.icon);

  final String label;
  final IconData icon;
}

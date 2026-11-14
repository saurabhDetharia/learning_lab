import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/application/learning_lab.dart';

void main() {
  runApp(

    // For widgets to be able to read providers, wrap the entire
    // application in a "ProviderScope" widget.
    ProviderScope(
      child: const LearningLab(),
    ),
  );
}

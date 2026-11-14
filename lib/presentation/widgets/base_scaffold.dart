import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_lab/application/provider/learning_lab_app_provider.dart';

import '../../gen/assets.gen.dart';

class BaseScaffold extends ConsumerStatefulWidget {
  const BaseScaffold({
    super.key,
  });

  @override
  ConsumerState<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends ConsumerState<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    final screenProvider = ref.watch(screenNotifier);

    return Scaffold(
      body: Stack(
        children: [
          // Background widget
          _getBackgroundWidget,

          // Shows the selected screen
          screenProvider.screen.child,
        ],
      ),
    );
  }

  /// This represents the background image of the UI.
  Widget get _getBackgroundWidget {
    return Assets.images.background.image(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learning_lab/presentation/widgets/base_scaffold.dart';
import 'package:learning_lab/utils/extensions/navigation_extension.dart';
import 'package:learning_lab/values/constants.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // To handle opacity animation.
  double _opacity = 0;

  // To handle animations timely.
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    // Production name animation
    _showLogoAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: AppConstants.animationDuration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left column - icon
              Assets.images.steplonIcon.image(
                height: 100,
                width: 100,
              ),

              // Space - 10px
              SizedBox(
                width: 10,
              ),

              // Right column
              SizedBox(
                height: 100,
                child: _getNameWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// This represents the Right column of the UI.
  /// Which is the list of texts.
  Widget get _getNameWidget {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Steplon Media',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            fontFamily: FontFamily.nunito,
          ),
        ),
        Text(
          'presents',
          style: TextStyle(
            fontSize: 20,
            fontFamily: FontFamily.nunito,
          ),
        ),
      ],
    );
  }

  /// This will be used to show Production
  /// name with animation and redirects to
  /// the next screen once [AppConstants.splashDuration]
  /// completes.
  void _showLogoAnimation() {
    _animationTimer = Timer.periodic(
      AppConstants.animationDuration,
      (timer) {
        if (timer.tick == 1) {
          // When timer completes first cycle, (900ms)
          // this will show the widget on the screen.
          setState(() {
            _opacity = 1;
          });
        } else if (timer.tick == 3) {
          // When timer completes third cycle, (2700ms)
          // this will hide the widget on the screen.
          setState(() {
            _opacity = 0;
          });
        } else if (timer.tick == 4) {
          // When timer completes fourth cycle, (3600ms)
          // this will cancel timer and redirects to next screen.
          _animationTimer!.cancel();
          context.pushReplacement(
            BaseScaffold(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // Cancels timer used for animation.
    _animationTimer?.cancel();

    super.dispose();
  }
}

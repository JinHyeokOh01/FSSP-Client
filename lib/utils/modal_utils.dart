// lib/utils/modal_utils.dart
import 'package:flutter/material.dart';
import '../widgets/profile_modal.dart';

class ModalUtils {
  static void showProfileModal(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + kToolbarHeight;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              right: 16,
              top: topPadding,
              child: ProfileModal(topPadding: topPadding),
            ),
          ],
        );
      },
    );
  }
}
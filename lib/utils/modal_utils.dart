// lib/utils/modal_utils.dart
import 'package:flutter/material.dart';
import '../widgets/profile_modal.dart';

class ModalUtils {
  static void showProfileModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 120, right: 16),
            child: ProfileModal(),
          ),
        );
      },
    );
  }
}
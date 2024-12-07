// lib/widgets/logout_modal.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LogoutModal extends StatelessWidget {
  final AuthService _authService = AuthService();

  LogoutModal({super.key});

  @override
  Widget build(BuildContext context) {
      return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 325,
        height: 246,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '로그아웃 하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.20,
              ),
            ),
            const SizedBox(height: 47), // 텍스트와 버튼 사이 간격
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final success = await _authService.logout();
                    if (success) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Container(
                    width: 94,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF7171),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '예',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 39), // 버튼 사이 간격
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 94,
                    height: 28,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE8E8E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showLogoutModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return LogoutModal();
    },
  );
}
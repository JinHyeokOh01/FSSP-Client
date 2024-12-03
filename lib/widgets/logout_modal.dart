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
        child: Stack(
          children: [
            // 로그아웃 메시지
            const Positioned(
              left: 32,
              top: 91,
              child: SizedBox(
                width: 261,
                height: 32,
                child: Text(
                  '로그아웃 하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0.07,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),

            // 예 버튼
            Positioned(
              left: 49,
              top: 170,
              child: GestureDetector(
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
                        height: 0.10,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 아니오 버튼
            Positioned(
              left: 182,
              top: 170,
              child: GestureDetector(
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
                        height: 0.10,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),
              ),
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
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/modal_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 앱바
            Container(
              width: 412,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: const BoxDecoration(color: Color(0xFFCBF1BF)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      color: Color(0xFF1D1B20),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => ModalUtils.showProfileModal(context),
                  ),
                ],
              ),
            ),
            
            // 메인 컨텐츠
            Expanded(
              child: Stack(
                children: [
                  // 중앙 텍스트
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 200,
                    child: Text(
                      '대화를 시작해보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Jua',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // 메시지 입력 필드
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              if (_messageController.text.isNotEmpty) {
                                final response = await _chatService.sendMessage(_messageController.text);
                                Navigator.pushNamed(
                                  context,
                                  '/result',
                                  arguments: {
                                    'message': _messageController.text,
                                    'response': response,
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 하단 네비게이션
            const BottomNavigation(currentRoute: '/home'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
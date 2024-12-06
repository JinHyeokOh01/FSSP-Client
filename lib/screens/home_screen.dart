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
  bool _isLoading = false;

  Future<void> _handleMessageSubmit() async {
    final message = _messageController.text;
    if (message.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await _chatService.sendMessage(message);
      
      if (mounted) {
        if (result['success']) {
          _messageController.clear();
          Navigator.pushNamed(
            context,
            '/result',
            arguments: {
              'message': message,
              'response': result['data'],
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['error'] ?? '오류가 발생했습니다')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 앱바
            Container(
              width: double.infinity,
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
                  // 로고 이미지
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 40,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 중앙 텍스트
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 250,
                    child: Text(
                      '대화를 시작해보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: 'Jua',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // 메시지 입력 필드
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 80,
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
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _handleMessageSubmit(),
                        decoration: InputDecoration(
                          hintText: 'ex) 점심 메뉴 추천 해줘',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: _isLoading 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                            onPressed: _isLoading ? null : _handleMessageSubmit,
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
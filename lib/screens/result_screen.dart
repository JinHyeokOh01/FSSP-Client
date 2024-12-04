// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../services/location_service.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/modal_utils.dart';

class ResultScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        // Named route에서 전달된 arguments 처리
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return ResultScreen(
          message: args['message'] as String,
          response: args['response'] as String,
        );
      },
    );
  }

  final String message;
  final String response;
  
  const ResultScreen({
    super.key, 
    required this.message, 
    required this.response
  });
  
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final LocationService _locationService = LocationService();
  String _currentLocation = '영통동';
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentAddress();
      if (mounted) {
        setState(() {
          _currentLocation = location;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 정보를 가져오는데 실패했습니다.')),
        );
      }
    }
  }

  Future<void> _searchRestaurants(String keyword) async {
  if (_currentLocation.isEmpty || keyword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('위치 정보와 검색어를 확인해주세요.')),
    );
    return;
  }
  
  setState(() => _isLoading = true);
  
  try {
    final query = "$_currentLocation $keyword";
    print('Searching with query: $query'); // 디버깅용

    final result = await _chatService.searchRestaurants(query);
    print('Search result: $result'); // 디버깅용
    
    if (mounted) {
      if (result['success'] && result['data'] is List) {
        Navigator.pushNamed(
          context,
          '/search-results',
          arguments: result['data'],
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? '검색 중 오류가 발생했습니다.')),
        );
      }
    }
  } catch (e) {
    print('Search error: $e'); // 디버깅용
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 중 오류가 발생했습니다: $e')),
      );
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
              width: 412,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: const BoxDecoration(color: Color(0xFFCBF1BF)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Chat',
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 사용자 메시지
                      const Text(
                        '메시지',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 채팅 응답
                      const Text(
                        '답변',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFD9D9D9)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.response,
                          style: const TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 검색 섹션
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              '식당을 검색해볼까요?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Jua',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 247,
                              height: 48,
                              child: TextField(
                                controller: _searchController,
                                enabled: !_isLoading,
                                decoration: InputDecoration(
                                  hintText: '메뉴 이름',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFB3B3B3),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(Icons.search),
                                    onPressed: _isLoading ? null : () => _searchRestaurants(_searchController.text),
                                  ),
                                ),
                                onSubmitted: (value) => _searchRestaurants(value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 네비게이션
            const BottomNavigation(currentRoute: '/result'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
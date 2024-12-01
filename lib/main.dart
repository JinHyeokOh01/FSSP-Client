import 'package:flutter/material.dart';

void main() {
 runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
 const FigmaToCodeApp({super.key});

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     theme: ThemeData.dark().copyWith(
       scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
     ),
     home: Scaffold(
       body: ListView(children: const [
         MainScreen(),
       ]),
     ),
   );
 }
}

class MainScreen extends StatelessWidget {
 const MainScreen({super.key});

 @override
 Widget build(BuildContext context) {
   final screenWidth = MediaQuery.of(context).size.width;
   final screenHeight = MediaQuery.of(context).size.height;

   return Column(
     children: [
       Container(
         width: screenWidth,
         height: screenHeight,
         clipBehavior: Clip.antiAlias,
         decoration: const BoxDecoration(color: Colors.white),
         child: Stack(
           children: [
             Positioned(
               left: 0,
               top: -2,
               child: Container(
                 width: screenWidth,
                 height: screenHeight,
                 padding: EdgeInsets.only(top: screenHeight * 0.9),
                 clipBehavior: Clip.antiAlias,
                 decoration: ShapeDecoration(
                   color: Colors.white,
                   shape: RoundedRectangleBorder(
                     side: const BorderSide(
                       width: 8,
                       strokeAlign: BorderSide.strokeAlignOutside,
                       color: Color(0xFFCAC4D0),
                     ),
                     borderRadius: BorderRadius.circular(18),
                   ),
                 ),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     SizedBox(
                       width: screenWidth,
                       height: 24,
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Container(
                             width: screenWidth * 0.25,  // 108/412 ≈ 0.25
                             height: 4,
                             decoration: ShapeDecoration(
                               color: const Color(0xFF1D1B20),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(12),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
              Positioned(
              left: screenWidth * 0.25,
              top: screenHeight * 0.1,
              child: Container(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/app_logo.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(20),  // 모서리 둥글게
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F000000),  // 반투명 검정색
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,  // left를 0으로 설정
              right: 0, // right를 0으로 설정하여 전체 너비 사용
              top: screenHeight * 0.48,
              child: const Center(  // Center 위젯으로 감싸기
                child: Text(
                  '오늘 뭐 먹지? 오뭐먹?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    //fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0.04,
                  ),
                  textAlign: TextAlign.center,  // 텍스트 정렬 추가
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.12,  // 48/412 ≈ 0.12
              top: screenHeight * 0.79,  // 726/917 ≈ 0.79
              child: Container(
                width: screenWidth * 0.77,  // 316/412 ≈ 0.77
                height: 49,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,  // 가운데 정렬
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/google_logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),  // 로고와 텍스트 사이 간격
                    const Text(
                      '구글 로그인으로 시작하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
           ],
         ),
       ),
     ],
   );
 }
}
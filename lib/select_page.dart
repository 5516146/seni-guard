import 'package:flutter/material.dart';
import 'package:seniguard/chat_bot.dart';
import 'dart:async';

import 'package:seniguard/check_list.dart';
import 'package:seniguard/screens/walking_routes_screen.dart';
import 'package:seniguard/mypage.dart';

void main() {
  runApp(const FigmaToCode_2());
}

class FigmaToCode_2 extends StatelessWidget {
  const FigmaToCode_2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40), // 앱바 높이 지정
          child: AppBar(
            backgroundColor: Color(0xFF53B175), // 앱바 배경색
            title: Text(
              '기본 화면',
              style: TextStyle(
                fontSize: 20, // 앱바의 제목 텍스트 크기
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: ListView(
          children: [
            SelectPage(),
          ],
        ),
      ),
    );
  }
}

class SelectPage extends StatelessWidget {
  final ValueNotifier<String> _currentTimeNotifier =
      ValueNotifier<String>(_getCurrentTime());

  TimeDisplayWidget() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      _currentTimeNotifier.value = _getCurrentTime(); // 시간 갱신
    });
  }

  // 현재 시간을 시:분 형식으로 반환하는 함수
  static String _getCurrentTime() {
    final DateTime now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 폰트 크기를 화면 너비에 따라 조정
    final baseFontSize = screenWidth * 0.05;

    return Column(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.067,
                top: screenHeight * 0.03,
                child: SizedBox(
                  width: screenWidth * 0.48,
                  child: Text(
                    '오늘 하루는 어떠신가요 ?',
                    style: TextStyle(
                      color: Color(0xFF3F414E),
                      fontSize: baseFontSize * 0.8, // 폰트 크기 조정
                      fontFamily: 'Freesentation',
                      fontWeight: FontWeight.w400,
                      height: 0.02,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.067,
                top: screenHeight * 0.055,
                child: Text(
                  'can choose what you want to do:',
                  style: TextStyle(
                    color: Color(0xFFA1A4B2),
                    fontSize: baseFontSize * 0.6, // 폰트 크기 조정
                    fontFamily: 'Freesentation',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),

              // 실시간 시계
              Positioned(
                left: screenWidth * 0.79,
                top: screenHeight * 0.042,
                child: ValueListenableBuilder<String>(
                  valueListenable: _currentTimeNotifier,
                  builder: (context, currentTime, child) {
                    return SizedBox(
                      width: screenWidth * 0.158,
                      child: Text(
                        currentTime, // 실시간으로 업데이트되는 시간 표시
                        style: TextStyle(
                          color: Color(0xFF3F414E),
                          fontSize: baseFontSize * 1.15, // 폰트 크기 조정
                          fontFamily: 'Freesentation',
                          fontWeight: FontWeight.w400,
                          height: 0.02,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 실시간 시계

              // 백그라운드 이미지
              Positioned(
                left: 0, // 화면에 맞게 위치 설정
                bottom: 0,
                right: 0,
                child: Container(
                  width: screenWidth, // 화면 너비에 맞게 설정
                  height: screenHeight * 0.5, // 화면 높이에 맞게 설정
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/select_page_back_image.png"),
                      fit: BoxFit.cover, // 이미지를 화면에 맞게 커버
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0, // 화면의 왼쪽에 맞춤
                right: 0,
                bottom: 0, // 하단에 배치
                child: Container(
                  width: screenWidth, // 화면 전체 너비 사용
                  height: screenHeight * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/flowers.png"), // 이미지 경로
                      fit: BoxFit.cover, // 이미지를 컨테이너 크기에 맞춤
                    ),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.7, // 화면의 왼쪽에 맞춤
                right: screenWidth * 0.1,
                top: screenHeight * 0.73,
                child: GestureDetector(
                  onTap: () {
                    // 네비게이션 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Page_Setting(), // 이동할 페이지
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.1, // 화면 전체 너비 사용
                    height: screenHeight * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/mypage_button.png"), // 이미지 경로
                        fit: BoxFit.fitWidth, // 이미지를 컨테이너 크기에 맞춤
                      ),
                    ),
                  ),
                ),
              ),
              // 백그라운드 이미지

              // 산책 이동 버튼
              Positioned(
                left: screenWidth * 0.068,
                top: screenHeight * 0.492,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalkingRoutesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.423,
                    height: screenHeight * 0.316,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: screenWidth * 0.423,
                            height: screenHeight * 0.316,
                            decoration: ShapeDecoration(
                              color: Color(0xFFEFCEFE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),

                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.015, // 화면에 맞게 위치 설정
                          top: screenHeight * 0.01, // 상단 여백을 계산하여 위치 설정
                          right: screenWidth * 0.015,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            decoration: ShapeDecoration(
                              color: Color.fromARGB(255, 247, 246, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.005, // 화면에 맞게 위치 설정
                          top: screenHeight * 0.01, // 상단 여백을 계산하여 위치 설정
                          right: screenWidth * 0.005,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth, // 화면 너비에 맞게 설정
                            height: screenHeight * 0.2, // 화면 높이에 맞게 설정
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/warking_button.png"),
                                fit: BoxFit.fitHeight, // 이미지를 화면에 맞게 커버
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.088,
                          top: screenHeight * 0.235,
                          child: SizedBox(
                            width: screenWidth * 0.261,
                            height: screenHeight * 0.048,
                            child: Text(
                              '산책하기',
                              style: TextStyle(
                                color: const Color(0xFFFDF9F3),
                                fontSize: baseFontSize * 1.0,
                                fontFamily: 'Freesentation',
                                fontWeight: FontWeight.w600,
                                height: 1.2, // 줄 간격 조정
                              ),
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 산책 이동 버튼

              // 챗봇 이동 버튼
              Positioned(
                left: screenWidth * 0.069,
                top: screenHeight * 0.098,
                child: GestureDetector(
                  onTap: () {
                    // 네비게이션 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FigmaToCode_3()),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.423,
                    height: screenHeight * 0.316,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: screenWidth * 0.423,
                            height: screenHeight * 0.316,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF05D48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.015, // 화면에 맞게 위치 설정
                          top: screenHeight * 0.01, // 상단 여백을 계산하여 위치 설정
                          right: screenWidth * 0.015,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            decoration: ShapeDecoration(
                              color: Color.fromARGB(255, 247, 246, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.005, // 화면에 맞게 위치 설정
                          top: screenHeight * 0.01, // 상단 여백을 계산하여 위치 설정
                          right: screenWidth * 0.005,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth, // 화면 너비에 맞게 설정
                            height: screenHeight * 0.2, // 화면 높이에 맞게 설정
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/chatbot_button.png"),
                                fit: BoxFit.fitHeight, // 이미지를 화면에 맞게 커버
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.088,
                          top: screenHeight * 0.235,
                          child: SizedBox(
                            width: screenWidth * 0.261,
                            height: screenHeight * 0.048,
                            child: Text(
                              '시니와 대화',
                              style: TextStyle(
                                color: const Color(0xFFFDF9F3),
                                fontSize: baseFontSize * 1.0,
                                fontFamily: 'Freesentation',
                                fontWeight: FontWeight.w600,
                                height: 1.2, // 줄 간격 조정
                              ),
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 체봇 이동 버튼

              // 체크리스트 버튼
              Positioned(
                left: screenWidth * 0.54,
                top: screenHeight * 0.098,
                child: GestureDetector(
                  onTap: () {
                    // 네비게이션 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page_CheckList()),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.423,
                    height: screenHeight * 0.316,
                    child: Stack(
                      children: [
                        // 첫 번째 배경
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: screenWidth * 0.423,
                            height: screenHeight * 0.316,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF9CF88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // 두 번째 배경
                        Positioned(
                          left: screenWidth * 0.015,
                          top: screenHeight * 0.01,
                          right: screenWidth * 0.015,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            decoration: ShapeDecoration(
                              color: const Color.fromARGB(255, 232, 203, 173),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // 버튼 이미지
                        Positioned(
                          left: screenWidth * 0.005,
                          top: screenHeight * 0.01,
                          right: screenWidth * 0.005,
                          bottom: screenHeight * 0.1,
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * 0.2,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("images/checklist_button.png"),
                                fit: BoxFit.fitHeight, // 이미지를 높이에 맞게 조정
                              ),
                            ),
                          ),
                        ),
                        // 버튼 텍스트
                        Positioned(
                          left: screenWidth * 0.088,
                          top: screenHeight * 0.235,
                          child: SizedBox(
                            width: screenWidth * 0.261,
                            height: screenHeight * 0.048,
                            child: Text(
                              '오늘의 할일',
                              style: TextStyle(
                                color: const Color(0xFFFDF9F3),
                                fontSize: baseFontSize * 1.0,
                                fontFamily: 'Freesentation',
                                fontWeight: FontWeight.w600,
                                height: 1.2, // 줄 간격 조정
                              ),
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // 체크리스트

              // 알람
              Positioned(
                left: screenWidth * 0.54,
                top: screenHeight * 0.442,
                child: Container(
                  width: screenWidth * 0.423,
                  height: screenHeight * 0.316,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF9CF88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03), // 좌우 여백 추가
                    child: Center(
                      // 텍스트를 중앙에 배치
                      child: Text(
                        '오늘 아침에 \n멀미약을 복용하셨나요?', // 여기에 넣을 텍스트 작성
                        style: TextStyle(
                          color: Colors.black, // 텍스트 색상
                          fontSize: screenWidth * 0.05, // 상대적인 글꼴 크기
                          fontWeight: FontWeight.bold, // 굵은 글꼴
                        ),
                        textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      ),
                    ),
                  ),
                ),
              ),
              // 알람
            ],
          ),
        ),
      ],
    );
  }
}

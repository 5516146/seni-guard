import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:seniguard/login_platform.dart';

import 'package:seniguard/select_page.dart';

void main() {
  runApp(const FigmaToCode_1());
}

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
class FigmaToCode_1 extends StatelessWidget {
  const FigmaToCode_1({super.key});

  @override
  Widget build(BuildContext context) {
    print('로그인 페이지 진입!');
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          LoginPage(),
        ]),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

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
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/login_page_image.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Positioned Widget
              Positioned(
                left: screenWidth * 0.08,
                top: screenHeight * 0.89,
                child: SizedBox(
                  width: screenWidth * 0.84, // 버튼의 너비
                  child: _loginButton(
                    onTap: signInWithKakao, // 카카오 로그인 함수 호출
                  ),
                ),
              ),
              // Text Stack
              Positioned(
                left: screenWidth * 0.15,
                top: screenHeight * 0.5,
                child: SizedBox(
                  width: screenWidth * 0.7,
                  child: Column(
                    children: [
                      Text(
                        '더나은 삶을 위한 한걸음',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF53B175),
                          fontSize: screenWidth * 0.05, // Relative font size
                          fontFamily: 'Freesentation',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        '행복을 위한\n당신의 한걸음',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF53B175),
                          fontSize: screenWidth * 0.1, // Relative font size
                          fontFamily: 'Freesentation',
                          fontWeight: FontWeight.w800,
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

  Widget _loginButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0, // 고정 높이
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("images/kakao_login_medium_narrow.png"), // 버튼 이미지
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(13.0), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 효과
              offset: const Offset(0, 4),
              blurRadius: 6.0,
            ),
          ],
        ),
      ),
    );
  }

  void signInWithKakao() async {
    try {
      print('start login');
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url_for_kakao = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response_for_kakao = await http.get(
        url_for_kakao,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response_for_kakao.body);

      print('Kakao_user_data : ' + profileInfo.toString());
      print('Kakao_user_Access_Token : Bearer ' +
          token.accessToken); // 넘겨야 할 토큰 값

      final String accToken = 'Bearer ' + token.accessToken; // 토큰 값을 따로 저장
      const String baseUrl = 'http://34.64.182.238:8100/user/auth/kakao';

      // 요청할 URL 생성
      final Uri url_for_capstone = Uri.parse(baseUrl);

      // 헤더에 포함할 데이터
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'kakaoAccessToken': '$accToken', // 예: 인증 토큰
      };
      final response_for_capstone =
          await http.get(url_for_capstone, headers: headers);

      // 서버 응답이 성공적(200 OK)인지 확인
      if (response_for_capstone.statusCode == 200) {
        // JSON 데이터 파싱
        final data = json.decode(response_for_capstone.body);
        print('Response data: $data');

        final String dataAccToken =
            data['access_token']; // 카카오 토큰을 사용해 발급한 캡스톤 유저 토큰
        print('Capstone_AccessToken : $dataAccToken');
      } else {
        print(
            'Request failed with status: ${response_for_capstone.statusCode}');
      }

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
      print('카카오톡 로그인 성공');

      // 로그인 성공 후 새로운 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => FigmaToCode_2()), // HomePage로 이동
      );
    } catch (error) {
      // print(await KakaoSdk.origin); 키 해시 확인용
      print('카카오톡으로 로그인 실패 $error');
    }
  }
}

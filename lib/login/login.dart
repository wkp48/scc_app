import 'package:flutter/material.dart';
import '../signup/signup_class.dart';
import '../find/find_id.dart';
import '../find/find_pw.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EB), // 베이지색 배경
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 섹션
              _buildLogoSection(),
              // 제목 텍스트 (로고와 겹치게 하기 위해 아래로 내림)
              Transform.translate(
                offset: const Offset(0, -40),
                child: _buildTitleText(),
              ),
              
              const SizedBox(height: 20),
              
              // 입력 필드들
              _buildInputFields(),
              
              const SizedBox(height: 30),
              
              // 로그인 버튼
              _buildLoginButton(),
              
              const SizedBox(height: 20),
              
              // 하단 링크들
              _buildBottomLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Image.asset(
      'assets/logo/MainLogo.png',
      width: 300,
      height: 300,

    );
  }

  Widget _buildTitleText() {
    return  Column(
      children: [
        Text(
          '세종충북',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF8942E),
          ),
        ),
        Text(
          '도박문제예방치유센터',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF8942E),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // ID 입력 필드
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _idController,
            decoration: const InputDecoration(
              hintText: 'Id',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Password 입력 필드
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // 로그인 로직 구현
          print('로그인 시도: ${_idController.text}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF09E89E),
          //경계선 둥글게 하기 위해 30으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),        
        ),
        child: const Text(
          '로그인',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // 회원가입 페이지로 이동
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignupClassScreen(),
              ),
            );
          },
          child: const Text(
            '회원가입',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // 아이디 찾기 페이지로 이동
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindIdScreen(),
                  ),
                );
              },
              child: const Text(
                '아이디 찾기',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              ' / ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                // 비밀번호 찾기 페이지로 이동
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindPwScreen(),
                  ),
                );
              },
              child: const Text(
                '비밀번호 찾기',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

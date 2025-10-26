import 'package:flutter/material.dart';
import '../signup/signup_class.dart';
import '../find/find_id.dart';
import '../find/find_pw.dart';
import '../services/api_service.dart';
import 'login_complete_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
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
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Image.asset(
      'assets/logo/MainLogo.png',
      width: 250,
      height: 250,
    );
  }

  Widget _buildTitleText() {
    return Column(
      children: [
        Text(
          '세종충북',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF8942E),
          ),
        ),
        Text(
          '도박문제예방치유센터',
          style: TextStyle(
            fontSize: 26,
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

  Future<void> _handleLogin() async {
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('입력 오류', '아이디와 비밀번호를 입력해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('=== 로그인 시도 시작 ===');
      print('아이디: ${_idController.text}');
      print('비밀번호: ${_passwordController.text}');
      
      final response = await ApiService.login(
        _idController.text,
        _passwordController.text,
      );

      print('=== API 응답 받음 ===');
      print('응답 데이터: $response');

      setState(() {
        _isLoading = false;
      });

      if (response['success'] == true) {
        print('=== 로그인 성공 ===');
        print('사용자 데이터: ${response['data']}');
        
        _showSuccessDialog('로그인 성공!', '환영합니다, ${response['data']['username']}님!');
        
        // 2초 후 완료 화면으로 이동
        await Future.delayed(const Duration(seconds: 2));
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginCompleteScreen(
              userData: response['data'],
            ),
          ),
        );
      } else {
        print('=== 로그인 실패 ===');
        print('실패 메시지: ${response['message']}');
        
        _showErrorDialog(
          '로그인 실패', 
          response['message'] ?? '로그인에 실패했습니다.\n\n자세한 정보:\n${response.toString()}'
        );
      }
    } catch (e) {
      print('=== 로그인 오류 발생 ===');
      print('오류 타입: ${e.runtimeType}');
      print('오류 메시지: $e');
      
      setState(() {
        _isLoading = false;
      });
      
      _showErrorDialog(
        '네트워크 오류', 
        '로그인 중 오류가 발생했습니다.\n\n오류 상세:\n$e'
      );
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF09E89E),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[600],
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF09E89E),
          //경계선 둥글게 하기 위해 30으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),        
        ),
        child: _isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : const Text(
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

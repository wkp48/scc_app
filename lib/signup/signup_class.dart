import 'package:flutter/material.dart';
import 'signup_fam.dart';
import 'signup_sub.dart';

class SignupClassScreen extends StatelessWidget {
  const SignupClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0), // 베이지색 배경
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.grey,
            size: 32,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            children: [
              const SizedBox(height: 180),
              
              // 회원가입 제목
              const Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 80),
              
              // 선택 버튼들
              Row(
                children: [
                  // 대상자 버튼
                  Expanded(
                    child: _buildSelectionButton(
                      title: '대상자',
                      icon: Icons.person,
                      backgroundColor: const Color(0xFF09E89E),
                      onTap: () {
                        // 대상자 회원가입 페이지로 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupSubScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // 가족 버튼
                  Expanded(
                    child: _buildSelectionButton(
                      title: '가족',
                      icon: Icons.diversity_1,
                      backgroundColor: const Color(0xFFFF9999),
                      onTap: () {
                        // 가족 회원가입 페이지로 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupFamScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            
            const SizedBox(height: 15),
            
            // 텍스트
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

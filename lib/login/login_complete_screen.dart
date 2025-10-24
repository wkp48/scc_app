import 'package:flutter/material.dart';

class LoginCompleteScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const LoginCompleteScreen({
    super.key,
    required this.userData,
  });

  @override
  State<LoginCompleteScreen> createState() => _LoginCompleteScreenState();
}

class _LoginCompleteScreenState extends State<LoginCompleteScreen> {
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
              // 성공 아이콘
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF09E89E),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 성공 메시지
              const Text(
                '로그인 성공!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                '${widget.userData['username']}님, 환영합니다!',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 사용자 정보 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사용자 정보',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildInfoRow('사용자 타입', _getUserTypeText(widget.userData['userType'])),
                    _buildInfoRow('아이디', widget.userData['userid']),
                    _buildInfoRow('이름', widget.userData['username']),
                    _buildInfoRow('이메일', widget.userData['email']),
                    
                    if (widget.userData['userType'] == 'SUBJECT') ...[
                      if (widget.userData['teacherName'] != null)
                        _buildInfoRow('담당선생님', widget.userData['teacherName']),
                    ] else if (widget.userData['userType'] == 'FAMILY') ...[
                      if (widget.userData['relationship'] != null)
                        _buildInfoRow('관계', widget.userData['relationship']),
                      if (widget.userData['subjectUserid'] != null)
                        _buildInfoRow('연결된 대상자', widget.userData['subjectUserid']),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 메인 화면으로 이동 버튼 (임시)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('메인 화면으로 이동합니다 (구현 예정)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09E89E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '메인 화면으로 이동',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 로그아웃 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF09E89E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF09E89E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getUserTypeText(String userType) {
    switch (userType) {
      case 'SUBJECT':
        return '대상자';
      case 'FAMILY':
        return '가족';
      case 'TEACHER':
        return '선생님';
      default:
        return userType;
    }
  }
}

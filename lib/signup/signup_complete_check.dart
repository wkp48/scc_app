import 'package:flutter/material.dart';

class SignupCompleteCheckScreen extends StatefulWidget {
  final String userName;
  final String userType; // '대상자' 또는 '가족'
  final String userid;
  final String email;
  final String birthDate;
  final String teacherName;

  const SignupCompleteCheckScreen({
    super.key,
    required this.userName,
    required this.userType,
    required this.userid,
    required this.email,
    required this.birthDate,
    required this.teacherName,
  });

  @override
  State<SignupCompleteCheckScreen> createState() => _SignupCompleteCheckScreenState();
}

class _SignupCompleteCheckScreenState extends State<SignupCompleteCheckScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 원형 컨테이너 스케일 애니메이션
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    // 체크마크 그리기 애니메이션
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    // 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0), // 베이지색 배경
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목
                const Text(
                  '회원가입 완료',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // 체크마크 아이콘 (애니메이션)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF09E89E),
                            width: 3,
                          ),
                        ),
                        child: CustomPaint(
                          painter: CheckMarkPainter(
                            progress: _checkAnimation.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // 완료 메시지
                Text(
                  '${widget.userName}님의\n${widget.userType} 회원가입이 완료되었습니다.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 화면으로 이동
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF09E89E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckMarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckMarkPainter({
    required this.progress,
    this.color = const Color(0xFF09E89E),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // 체크마크 경로 정의
    final startX = size.width * 0.25;
    final startY = size.height * 0.5;
    final middleX = size.width * 0.45;
    final middleY = size.height * 0.65;
    final endX = size.width * 0.75;
    final endY = size.height * 0.35;

    // 첫 번째 선 (아래쪽에서 중간으로)
    path.moveTo(startX, startY);
    path.lineTo(middleX, middleY);
    
    // 두 번째 선 (중간에서 위쪽으로)
    path.lineTo(endX, endY);

    // 애니메이션에 따라 경로 그리기
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(CheckMarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

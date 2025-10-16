import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  
  final String _fullText = '세종충북\n도박문제예방치유센터';
  final List<AnimationController> _charControllers = [];
  final List<Animation<double>> _charAnimations = [];
  final List<Animation<double>> _charOpacityAnimations = [];

  @override
  void initState() {
    super.initState();

    // 로고 애니메이션 컨트롤러 (0.8초)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 로고 페이드인 애니메이션
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    // 로고 스케일 애니메이션 (0.8배에서 1배로)
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // 각 글자마다 애니메이션 컨트롤러 생성
    for (int i = 0; i < _fullText.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      _charControllers.add(controller);

      // 아래에서 위로 튀어오르는 애니메이션
      final animation = Tween<double>(
        begin: 30.0, // 아래에서 시작
        end: 0.0,    // 원래 위치로
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut, // 탄력있는 효과
      ));
      _charAnimations.add(animation);

      // 투명도 애니메이션
      final opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ));
      _charOpacityAnimations.add(opacityAnimation);
    }

    // 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    // 로고 애니메이션 시작
    await _logoController.forward();
    
    // 로고 애니메이션이 끝난 후 0.2초 후에 글자 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 200));
    
    // 각 글자를 순차적으로 애니메이션
    for (int i = 0; i < _charControllers.length; i++) {
      if (mounted) {
        _charControllers[i].forward();
        // 각 글자마다 80ms 간격
        await Future.delayed(const Duration(milliseconds: 80));
      }
    }

    // 모든 애니메이션이 끝난 후 1초 더 보여주고 다음 화면으로 이동
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if (mounted) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const MainScreen()),
    //   );
    // }
  }

  @override
  void dispose() {
    _logoController.dispose();
    for (var controller in _charControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Widget> _buildAnimatedTextLines() {
    final lines = _fullText.split('\n');
    final List<Widget> lineWidgets = [];
    int charIndex = 0;

    for (final line in lines) {
      final List<Widget> charWidgets = [];
      
      for (int i = 0; i < line.length; i++) {
        final currentCharIndex = charIndex;
        charWidgets.add(
          AnimatedBuilder(
            animation: _charControllers[currentCharIndex],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _charAnimations[currentCharIndex].value),
                child: Opacity(
                  opacity: _charOpacityAnimations[currentCharIndex].value,
                  child: Text(
                    line[i],
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                ),
              );
            },
          ),
        );
        charIndex++;
      }

      lineWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: charWidgets,
        ),
      );
      
      // 줄바꿈 문자도 카운트
      if (charIndex < _fullText.length) {
        charIndex++; // \n 문자 건너뛰기
      }
    }

    return lineWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 애니메이션
            Transform.translate(
              offset: const Offset(0, -100),
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/logo/MainLogo.png',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            // 글자 애니메이션 (파도 효과)
            Transform.translate(
              offset: const Offset(0, -120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildAnimatedTextLines(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


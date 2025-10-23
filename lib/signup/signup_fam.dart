import 'package:flutter/material.dart';
import 'signup_complete_check.dart';

class SignupFamScreen extends StatefulWidget {
  const SignupFamScreen({super.key});

  @override
  State<SignupFamScreen> createState() => _SignupFamScreenState();
}

class _SignupFamScreenState extends State<SignupFamScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  
  // 생년월일 선택용 변수들
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;
  final TextEditingController _teacherController = TextEditingController();

  bool _isIdAvailable = false;
  bool _isEmailVerified = false;
  
  // 폼 검증을 위한 변수들
  String? _nameError;
  String? _idError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _birthError;
  String? _teacherError;

  @override
  void initState() {
    super.initState();
    _updateBirthText(); // 초기값 설정
  }

  void _updateBirthText() {
    _birthController.text = "${_selectedYear}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}";
  }

  // 폼 검증 함수들
  bool _validateName(String name) {
    if (name.isEmpty) {
      _nameError = "이름을 입력해주세요";
      return false;
    } else if (name.length < 2) {
      _nameError = "이름은 2자 이상 입력해주세요";
      return false;
    }
    _nameError = null;
    return true;
  }

  bool _validateId(String id) {
    if (id.isEmpty) {
      _idError = "아이디를 입력해주세요";
      return false;
    } else if (id.length < 4) {
      _idError = "아이디는 4자 이상 입력해주세요";
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id)) {
      _idError = "아이디는 영문과 숫자만 사용 가능합니다";
      return false;
    }
    _idError = null;
    return true;
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = "이메일을 입력해주세요";
      return false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = "올바른 이메일 형식을 입력해주세요";
      return false;
    }
    _emailError = null;
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      _passwordError = "비밀번호를 입력해주세요";
      return false;
    } else if (password.length < 4 || password.length > 16) {
      _passwordError = "비밀번호는 4~16자리로 입력해주세요";
      return false;
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+$').hasMatch(password)) {
      _passwordError = "영문과 숫자를 조합해주세요";
      return false;
    }
    _passwordError = null;
    return true;
  }

  bool _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = "비밀번호 확인을 입력해주세요";
      return false;
    } else if (confirmPassword != _passwordController.text) {
      _confirmPasswordError = "비밀번호가 일치하지 않습니다";
      return false;
    }
    _confirmPasswordError = null;
    return true;
  }

  bool _validateBirth() {
    DateTime birthDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (birthDate.isAfter(now)) {
      _birthError = "미래 날짜는 선택할 수 없습니다";
      return false;
    } else if (age < 10) {
      _birthError = "10세 이상만 가입 가능합니다";
      return false;
    }
    _birthError = null;
    return true;
  }

  bool _validateTeacher(String teacher) {
    if (teacher.isEmpty) {
      _teacherError = "담당 선생님을 입력해주세요";
      return false;
    }
    _teacherError = null;
    return true;
  }

  bool _validateForm() {
    bool isValid = true;
    
    isValid &= _validateName(_nameController.text);
    isValid &= _validateId(_idController.text);
    isValid &= _validateEmail(_emailController.text);
    isValid &= _validatePassword(_passwordController.text);
    isValid &= _validateConfirmPassword(_confirmPasswordController.text);
    isValid &= _validateBirth();
    isValid &= _validateTeacher(_teacherController.text);
    isValid &= _isIdAvailable;
    isValid &= _isEmailVerified;
    
    setState(() {});
    return isValid;
  }


  void _showDateSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 상단 바
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // 제목
              const Text(
                '생년월일 선택',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              
              // 날짜 선택기
              Expanded(
                child: Row(
                  children: [
                    // 년도 선택
                    Expanded(
                      child: _buildScrollSelector(
                        items: List.generate(100, (index) => 1924 + index),
                        selectedValue: _selectedYear,
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                            _updateBirthText();
                          });
                        },
                        label: '년',
                      ),
                    ),
                    
                    // 월 선택
                    Expanded(
                      child: _buildScrollSelector(
                        items: List.generate(12, (index) => index + 1),
                        selectedValue: _selectedMonth,
                        onChanged: (value) {
                          setState(() {
                            _selectedMonth = value;
                            _updateBirthText();
                          });
                        },
                        label: '월',
                      ),
                    ),
                    
                    // 일 선택
                    Expanded(
                      child: _buildScrollSelector(
                        items: _getDaysInMonth(_selectedYear, _selectedMonth),
                        selectedValue: _selectedDay,
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value;
                            _updateBirthText();
                          });
                        },
                        label: '일',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 확인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF09E89E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }

  List<int> _getDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  Widget _buildScrollSelector({
    required List<int> items,
    required int selectedValue,
    required Function(int) onChanged,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(items[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                final isSelected = items[index] == selectedValue;
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    items[index].toString(),
                    style: TextStyle(
                      fontSize: isSelected ? 20 : 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF09E89E) : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _verificationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

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
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // 메인 폼 컨테이너
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름 입력
                    _buildInputField('이름', _nameController, errorText: _nameError),
                    
                    const SizedBox(height: 20),
                    
                    // 아이디 입력
                    _buildIdField(),
                    
                    const SizedBox(height: 20),
                    
                    // 이메일 입력
                    _buildEmailField(),
                    
                    const SizedBox(height: 20),
                    
                    // 인증번호 입력
                    _buildVerificationField(),
                    
                    const SizedBox(height: 20),
                    
                    // 비밀번호 입력
                    _buildPasswordField(),
                    
                    const SizedBox(height: 20),
                    
                    // 비밀번호 확인 입력
                    _buildInputField('비밀번호 확인', _confirmPasswordController, errorText: _confirmPasswordError, obscureText: true),
                    
                    const SizedBox(height: 20),
                    
                    // 생년월일 입력
                    _buildBirthField(),
                    
                    const SizedBox(height: 20),
                    
                    // 담당 선생님 입력
                    _buildInputField('담당 선생님', _teacherController, errorText: _teacherError),
                    
                    const SizedBox(height: 30),
                    
                    // 회원가입 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_validateForm()) {
                            // 회원가입 성공 처리 - 바로 완료 화면으로 이동
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignupCompleteCheckScreen(
                                  userName: _nameController.text,
                                  userType: '가족',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09E89E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? errorText, TextInputType? keyboardType, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: errorText != null ? Border.all(color: Colors.red, width: 1) : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: (value) {
              // 실시간 검증
              if (label == '이름') _validateName(value);
              else if (label == '비밀번호 확인') _validateConfirmPassword(value);
              else if (label == '담당 선생님') _validateTeacher(value);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '아이디',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child:         Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: _idError != null ? Border.all(color: Colors.red, width: 1) : null,
          ),
          child: TextField(
            controller: _idController,
            onChanged: (value) => _validateId(value),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isIdAvailable = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09E89E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '중복확인',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isIdAvailable) ...[
          const SizedBox(height: 8),
          const Text(
            '사용 가능한 아이디 입니다',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ] else if (_idError != null) ...[
          const SizedBox(height: 8),
          Text(
            _idError!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '이메일',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: _emailError != null ? Border.all(color: Colors.red, width: 1) : null,
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _validateEmail(value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // 이메일 인증 로직
                  print('이메일 인증 요청');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09E89E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '인증받기',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_emailError != null) ...[
          const SizedBox(height: 8),
          Text(
            _emailError!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVerificationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '인증번호',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _verificationController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEmailVerified = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09E89E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '인증하기',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isEmailVerified) ...[
          const SizedBox(height: 8),
          const Text(
            '인증이 완료되었습니다',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '비밀번호',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: _passwordError != null ? Border.all(color: Colors.red, width: 1) : null,
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) => _validatePassword(value),
            decoration: const InputDecoration(
              hintText: '4 ~ 16자리 영문, 숫자 조합',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        if (_passwordError != null) ...[
          const SizedBox(height: 4),
          Text(
            _passwordError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '생년월일',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showDateSelector,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: _birthError != null ? Border.all(color: Colors.red, width: 1) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _birthController.text.isEmpty 
                          ? '생년월일을 선택해주세요' 
                          : _birthController.text,
                      style: TextStyle(
                        color: _birthController.text.isEmpty 
                            ? Colors.grey 
                            : Colors.black,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_birthError != null) ...[
          const SizedBox(height: 4),
          Text(
            _birthError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

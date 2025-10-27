import 'package:flutter/material.dart';
import 'signup_complete_check.dart';
import '../services/api_service.dart';

class SignupSubScreen extends StatefulWidget {
  const SignupSubScreen({super.key});

  @override
  State<SignupSubScreen> createState() => _SignupSubScreenState();
}

class _SignupSubScreenState extends State<SignupSubScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isIdAvailable = false;
  bool _isEmailVerified = false;
  bool _isLoading = false;
  bool _isIdChecked = false; // 아이디 중복 확인 여부
  bool _isIdDuplicate = false; // 아이디 중복 여부
  bool _isEmailChecked = false; // 이메일 중복 확인 여부
  bool _isEmailDuplicate = false; // 이메일 중복 여부
  
  // 폼 검증을 위한 변수들
  String? _nameError;
  String? _idError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _birthError;
  String? _teacherError;
  String? _phoneError;

  // 생년월일 선택용 변수들
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    _updateBirthText(); // 초기값 설정
    
    // 전화번호 자동 포맷팅 리스너 추가
    _phoneController.addListener(() {
      _formatPhoneNumber();
    });
  }

  void _updateBirthText() {
    _birthController.text = "${_selectedYear}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}";
  }

  // 전화번호 자동 포맷팅 함수
  void _formatPhoneNumber() {
    final text = _phoneController.text;
    final cleanedText = text.replaceAll(RegExp(r'[^\d]'), ''); // 숫자만 남기기
    
    if (cleanedText.length <= 3) {
      _phoneController.value = TextEditingValue(
        text: cleanedText,
        selection: TextSelection.collapsed(offset: cleanedText.length),
      );
    } else if (cleanedText.length <= 7) {
      _phoneController.value = TextEditingValue(
        text: '${cleanedText.substring(0, 3)}-${cleanedText.substring(3)}',
        selection: TextSelection.collapsed(offset: cleanedText.length + 1),
      );
    } else {
      _phoneController.value = TextEditingValue(
        text: '${cleanedText.substring(0, 3)}-${cleanedText.substring(3, 7)}-${cleanedText.substring(7, 11)}',
        selection: TextSelection.collapsed(offset: cleanedText.length + 2),
      );
    }
  }

  bool _validatePhone(String phone) {
    if (phone.isEmpty) {
      _phoneError = "전화번호를 입력해주세요";
      return false;
    }
    // 하이픈 제거 후 숫자만 검사
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedPhone.length < 10 || cleanedPhone.length > 11) {
      _phoneError = "올바른 전화번호를 입력해주세요";
      return false;
    }
    _phoneError = null;
    return true;
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
    isValid &= _validatePhone(_phoneController.text);
    isValid &= _isIdAvailable;
    isValid &= _isEmailVerified && !_isEmailDuplicate;
    
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
    _phoneController.dispose();
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
                    
                    // 전화번호 입력
                    _buildPhoneField(),
                    
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
                        onPressed: (_isIdAvailable && _isEmailVerified) ? () async {
                          if (_validateForm()) {
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              
                              // 회원가입 API 호출
                              final response = await ApiService.signupSubject(
                                name: _nameController.text,
                                userid: _idController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                birthDate: _birthController.text,
                                teacherName: _teacherController.text,
                                phoneNumber: _phoneController.text,
                              );
                              
                              setState(() {
                                _isLoading = false;
                              });
                              
                              if (response['success'] == true) {
                                // 회원가입 성공 - 완료 화면으로 이동
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => SignupCompleteCheckScreen(
                                      userName: _nameController.text,
                                      userType: '대상자',
                                      userid: _idController.text,
                                      email: _emailController.text,
                                      birthDate: _birthController.text,
                                      teacherName: _teacherController.text,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'] ?? '회원가입에 실패했습니다')),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('회원가입 중 오류가 발생했습니다: $e')),
                              );
                            }
                          }
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_isIdAvailable && _isEmailVerified) 
                              ? const Color(0xFF09E89E) 
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
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
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: _idError != null ? Border.all(color: Colors.red, width: 1) : null,
                ),
                child: TextField(
                  controller: _idController,
                  onChanged: (value) {
                    _validateId(value);
                    // 아이디가 변경되면 중복 확인 상태 초기화
                    if (_isIdChecked) {
                      setState(() {
                        _isIdChecked = false;
                        _isIdAvailable = false;
                        _isIdDuplicate = false;
                      });
                    }
                  },
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
                onPressed: () async {
                  if (_idController.text.isNotEmpty && _validateId(_idController.text)) {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      // 아이디 중복 확인 API 호출
                      final response = await ApiService.checkUserId(_idController.text);
                      
                      setState(() {
                        _isLoading = false;
                        _isIdChecked = true;
                        if (response['success'] == true && response['data'] == true) {
                          _isIdAvailable = true;
                          _isIdDuplicate = false;
                        } else {
                          _isIdAvailable = false;
                          _isIdDuplicate = true;
                        }
                      });
                      
                      // SnackBar는 제거하고 UI에서 직접 표시
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('아이디 확인 중 오류가 발생했습니다: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('올바른 아이디를 입력해주세요')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09E89E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
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
        if (_isIdChecked) ...[
          const SizedBox(height: 8),
          if (_isIdAvailable) ...[
            const Text(
              '사용 가능한 아이디입니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ] else if (_isIdDuplicate) ...[
            const Text(
              '이미 사용 중인 아이디입니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                  onChanged: (value) {
                    _validateEmail(value);
                    // 이메일이 변경되면 중복 확인 상태 초기화
                    if (_isEmailChecked) {
                      setState(() {
                        _isEmailChecked = false;
                        _isEmailVerified = false;
                        _isEmailDuplicate = false;
                      });
                    }
                  },
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
                onPressed: () async {
                  if (_emailController.text.isNotEmpty && _validateEmail(_emailController.text)) {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      // 이메일 중복 확인 API 호출
                      final response = await ApiService.checkEmail(_emailController.text);
                      
                      setState(() {
                        _isLoading = false;
                        _isEmailChecked = true;
                        if (response['success'] == true && response['data'] == true) {
                          _isEmailVerified = true;
                          _isEmailDuplicate = false;
                        } else {
                          _isEmailVerified = false;
                          _isEmailDuplicate = true;
                        }
                      });
                      
                      // SnackBar는 제거하고 UI에서 직접 표시
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이메일 확인 중 오류가 발생했습니다: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('올바른 이메일을 입력해주세요')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF09E89E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
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
        const SizedBox(height: 8),
        if (_isEmailChecked) ...[
          if (_isEmailVerified) ...[
            const Text(
              '사용 가능한 이메일입니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ] else if (_isEmailDuplicate) ...[
            const Text(
              '이미 사용 중인 이메일입니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ] else if (_emailError != null) ...[
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

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '전화번호',
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
            border: _phoneError != null ? Border.all(color: Colors.red, width: 1) : null,
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (value) => _validatePhone(value),
            decoration: const InputDecoration(
              hintText: '010-1234-5678',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        if (_phoneError != null) ...[
          const SizedBox(height: 4),
          Text(
            _phoneError!,
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

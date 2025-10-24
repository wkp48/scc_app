import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.35:8080/api';
  
  // 아이디 중복 확인
  static Future<Map<String, dynamic>> checkUserId(String userid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/signup/check/userid?userid=$userid'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('아이디 확인 응답 상태: ${response.statusCode}');
      print('아이디 확인 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': false
          };
        }
      } else {
        return {
          'success': false,
          'message': '아이디 확인 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
          'data': false
        };
      }
    } catch (e) {
      print('아이디 확인 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': false
      };
    }
  }
  
  // 이메일 중복 확인
  static Future<Map<String, dynamic>> checkEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/signup/check/email?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('이메일 확인 응답 상태: ${response.statusCode}');
      print('이메일 확인 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': false
          };
        }
      } else {
        return {
          'success': false,
          'message': '이메일 확인 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
          'data': false
        };
      }
    } catch (e) {
      print('이메일 확인 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': false
      };
    }
  }
  
  // 대상자 회원가입
  static Future<Map<String, dynamic>> signupSubject({
    required String name,
    required String userid,
    required String email,
    required String password,
    required String birthDate,
    required String teacherName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup/subject'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'userid': userid,
          'email': email,
          'password': password,
          'birthDate': birthDate,
          'teacherName': teacherName,
        }),
      );
      
      print('회원가입 응답 상태: ${response.statusCode}');
      print('회원가입 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '회원가입 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '회원가입 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '회원가입 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('회원가입 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }
  
  // 대상자 정보 조회
  static Future<Map<String, dynamic>> checkSubjectInfo(String userid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/signup/subject/info?userid=$userid'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('대상자 정보 조회 응답 상태: ${response.statusCode}');
      print('대상자 정보 조회 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '대상자 정보 조회 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '대상자 정보 조회 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '대상자 정보 조회 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('대상자 정보 조회 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }

  // 가족 회원가입
  static Future<Map<String, dynamic>> signupFamily(String name, String userid, String email,
      String password, String relationship, String? subjectUserid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup/family'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'name': name,
          'userid': userid,
          'email': email,
          'password': password,
          'relationship': relationship,
          if (subjectUserid != null) 'subjectUserid': subjectUserid,
        },
      );

      print('가족 회원가입 응답 상태: ${response.statusCode}');
      print('가족 회원가입 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '가족 회원가입 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '가족 회원가입 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '가족 회원가입 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('가족 회원가입 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }

  // 비밀번호 찾기 (본인 확인)
  static Future<Map<String, dynamic>> findPassword(String name, String userid, String birthDate, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/find/password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'userid': userid,
          'birthDate': birthDate,
          'email': email,
        }),
      );

      print('비밀번호 찾기 응답 상태: ${response.statusCode}');
      print('비밀번호 찾기 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '비밀번호 찾기 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '비밀번호 찾기 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '비밀번호 찾기 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('비밀번호 찾기 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }

  // 비밀번호 재설정
  static Future<Map<String, dynamic>> resetPassword(String userid, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/find/password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userid': userid,
          'newPassword': newPassword,
        }),
      );

      print('비밀번호 재설정 응답 상태: ${response.statusCode}');
      print('비밀번호 재설정 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '비밀번호 재설정 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '비밀번호 재설정 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '비밀번호 재설정 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('비밀번호 재설정 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }

  // 아이디 찾기
  static Future<Map<String, dynamic>> findUserId(String name, String birthDate, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/find/id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'birthDate': birthDate,
          'email': email,
        }),
      );

      print('아이디 찾기 응답 상태: ${response.statusCode}');
      print('아이디 찾기 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '아이디 찾기 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '아이디 찾기 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '아이디 찾기 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('아이디 찾기 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }

  // 로그인
  static Future<Map<String, dynamic>> login(String userid, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userid': userid,
          'password': password,
        }),
      );

      print('로그인 응답 상태: ${response.statusCode}');
      print('로그인 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {
            'success': false,
            'message': '서버에서 빈 응답을 받았습니다',
            'data': null
          };
        }
      } else {
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            return {
              'success': false,
              'message': errorData['message'] ?? '로그인 중 오류가 발생했습니다',
              'data': null
            };
          } catch (e) {
            return {
              'success': false,
              'message': '로그인 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
              'data': null
            };
          }
        } else {
          return {
            'success': false,
            'message': '로그인 중 오류가 발생했습니다 (상태코드: ${response.statusCode})',
            'data': null
          };
        }
      }
    } catch (e) {
      print('로그인 오류: $e');
      return {
        'success': false,
        'message': '네트워크 오류가 발생했습니다: $e',
        'data': null
      };
    }
  }
}

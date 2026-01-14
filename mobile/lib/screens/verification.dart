import 'package:eco_kitchen/backend/fastapi.dart'; // API Servisi
import 'package:eco_kitchen/core/services/api_service.dart'; // Dio Servisi
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:eco_kitchen/screens/home.dart';
import 'package:eco_kitchen/screens/register_screen.dart';

// ConsumerStatefulWidget kullanıyoruz çünkü API çağrısı yapacağız
class VerificationScreen extends ConsumerStatefulWidget {
  final String email;
  // Şifreyi de alıyoruz ki doğrulama sonrası otomatik giriş yapabilelim
  final String? password;

  const VerificationScreen({
    Key? key,
    required this.email,
    this.password
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
        (index) => FocusNode(),
  );
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _verificationCode {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isCodeComplete {
    return _verificationCode.length == 4;
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyPressed(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    // Şimdilik herhangi bir kod girilmesine izin veriyoruz (Backend OTP yok)
    if (!_isCodeComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the 4-digit code")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Backend'de doğrulama endpoint'i olmadığı için
      // 1 saniye bekleyip, eğer elimizde şifre varsa direkt giriş yapıyoruz.
      await Future.delayed(Duration(seconds: 1));

      if (widget.password != null) {
        // Otomatik Giriş Yap
        final dio = ref.read(apiServiceProvider);
        final api = FastAPI(dio);

        await api.login(widget.email, widget.password!);
      }

      if (mounted) {
        // Başarılı -> Ana Sayfaya
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu, lütfen giriş yapın.")),
        );
        // Hata olsa bile giriş sayfasına yönlendir
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    // TODO: Backend resend code API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("The verification code was sent again."),
        backgroundColor: Color(0xFF9DB67B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      "Verification Email",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Subtitle
                    Text(
                      "Please enter the code we just sent to email",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),

                    // Email
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Code Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 64,
                          height: 64,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (event) => _onKeyPressed(event, index),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                  BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color(0xFF9DB67B), width: 2),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) =>
                                  _onCodeChanged(value, index),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24),

                    // Resend Code
                    RichText(
                      text: TextSpan(
                        text: "If you didn't receive a code? ",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              color: Color(0xFF9DB67B),
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _resendCode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9DB67B),
                      disabledBackgroundColor:
                      Color(0xFF9DB67B).withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}
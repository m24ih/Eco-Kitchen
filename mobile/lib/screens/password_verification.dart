import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_kitchen/screens/new_password.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);

class PasswordVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const PasswordVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _PasswordVerificationScreenState createState() => _PasswordVerificationScreenState();
}

class _PasswordVerificationScreenState extends ConsumerState<PasswordVerificationScreen> {
  List<String> _code = ['', '', '', ''];
  int _currentIndex = 0;

  void _onNumberPressed(String number) {
    if (_currentIndex < 4) {
      setState(() {
        _code[_currentIndex] = number;
        _currentIndex++;
      });
    }
  }

  void _onBackspacePressed() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _code[_currentIndex] = '';
      });
    }
  }

  Future<void> _onContinue() async {
    String fullCode = _code.join();
    if (fullCode.length == 4) {
      // TODO: Backend API Doğrulama
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code verified successfully!'), backgroundColor: primaryGreen),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPasswordScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the complete code'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Verification Code', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 12),
            Text('Please enter the code we just sent to email', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            SizedBox(height: 4),
            Text(widget.email, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _code[index].isNotEmpty ? secondaryGreen.withOpacity(0.3) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _currentIndex == index ? primaryGreen : Colors.grey[300]!, width: _currentIndex == index ? 2 : 1),
                    ),
                    child: Center(
                      child: Text(_code[index], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  );
                }),
              ),
            ),
            Spacer(),
            _buildNumberPad(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          _buildNumberRow(['1', '2', '3']),
          SizedBox(height: 16),
          _buildNumberRow(['4', '5', '6']),
          SizedBox(height: 16),
          _buildNumberRow(['7', '8', '9']),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 70), // Boşluk
              _buildNumberButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((n) => _buildNumberButton(n)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 70,
        height: 52,
        child: Center(child: Text(number, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500))),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: Container(
        width: 70,
        height: 52,
        child: Center(child: Icon(Icons.backspace_outlined, size: 24)),
      ),
    );
  }
}
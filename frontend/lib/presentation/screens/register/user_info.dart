import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_fe/core/constants/colors.dart';

class UserInfoPage extends StatefulWidget {
  final Function(Map<String, String>) onInfoSubmitted;

  const UserInfoPage({super.key, required this.onInfoSubmitted});

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'password': TextEditingController(),
    'hoten': TextEditingController(),
    'gioitinh': TextEditingController(),
    'diachi': TextEditingController(),
    'dienthoai': TextEditingController(),
    'ngaysinh': TextEditingController(),
    'cmnd': TextEditingController(),
  };

  String? _selectedGender;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('username', Icons.person),
            _buildPasswordField(),
            _buildTextField('hoten', Icons.badge, capitalized: true),
            _buildGenderDropdown(),
            _buildTextField('diachi', Icons.home, maxLines: 2),
            _buildTextField('dienthoai', Icons.phone,
                keyboardType: TextInputType.phone),
            _buildDatePicker(),
            _buildTextField('cmnd', Icons.credit_card,
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Tiếp tục', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String key, IconData icon,
      {bool capitalized = false,
      int maxLines = 1,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: key.capitalize(),
          floatingLabelStyle: const TextStyle(
            color: CustomColor.secondBlue,
          ),
          prefixIcon: Icon(icon, color: CustomColor.secondBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: CustomColor.primaryBlue, width: 2),
          ),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        textCapitalization:
            capitalized ? TextCapitalization.words : TextCapitalization.none,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập ${key.capitalize()}';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers['password'],
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Mật khẩu',
          floatingLabelStyle: const TextStyle(
            color: CustomColor.secondBlue,
          ),
          prefixIcon: const Icon(Icons.lock, color: CustomColor.secondBlue),
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: CustomColor.primaryBlue, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập mật khẩu';
          } else if (value.length < 8) {
            return 'Mật khẩu phải có ít nhất 8 ký tự';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Giới tính',
          floatingLabelStyle: const TextStyle(
            color: CustomColor.secondBlue,
          ),
          prefixIcon: const Icon(Icons.people, color: CustomColor.secondBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: CustomColor.primaryBlue, width: 2),
          ),
        ),
        items: ['Nam', 'Nữ', 'Khác'].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
            _controllers['gioitinh']?.text = newValue ?? '';
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn giới tính';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers['ngaysinh'],
        decoration: InputDecoration(
          labelText: 'Ngày sinh',
          floatingLabelStyle: const TextStyle(
            color: CustomColor.secondBlue,
          ),
          prefixIcon:
              const Icon(Icons.calendar_today, color: CustomColor.secondBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: CustomColor.primaryBlue, width: 2),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
            setState(() {
              _controllers['ngaysinh']!.text = formattedDate;
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn ngày sinh';
          }
          return null;
        },
      ),
    );
  }

  void _submitInfo() {
    if (_formKey.currentState!.validate()) {
      final userInfo =
          _controllers.map((key, value) => MapEntry(key, value.text));
      widget.onInfoSubmitted(userInfo);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

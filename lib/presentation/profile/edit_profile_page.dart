import 'package:flutter/material.dart';

import '../../core/components/primary_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/auth_session.dart';
import '../auth/widgets/auth_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _phone = TextEditingController(text: '+62 812-3456-7890');
  final _bio = TextEditingController(
      text: 'Loves discovering quality everyday essentials.');
  String _gender = 'Male';
  DateTime _dob = DateTime(1996, 7, 12);

  @override
  void initState() {
    super.initState();
    final u = AuthSession.instance.user;
    _name = TextEditingController(text: u?.name ?? '');
    _email = TextEditingController(text: u?.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }
    AuthSession.instance.signIn(
      name: _name.text.trim(),
      email: _email.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 44),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _Label('Full name'),
          AuthField(
            controller: _name,
            hint: 'Your name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          const _Label('Email'),
          AuthField(
            controller: _email,
            hint: 'Email address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          const _Label('Phone'),
          AuthField(
            controller: _phone,
            hint: 'Phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          const _Label('Date of birth'),
          GestureDetector(
            onTap: _pickDob,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cake_outlined,
                      size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 12),
                  Text(
                    '${_dob.day.toString().padLeft(2, '0')} / ${_dob.month.toString().padLeft(2, '0')} / ${_dob.year}',
                    style: AppTextStyles.body,
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _Label('Gender'),
          Row(
            children: ['Male', 'Female', 'Other']
                .map((g) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _gender = g),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _gender == g
                                  ? AppColors.accentSoft
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _gender == g
                                    ? AppColors.primary
                                    : AppColors.borderSoft,
                                width: _gender == g ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _gender == g
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),
          const _Label('Bio'),
          TextField(
            controller: _bio,
            maxLines: 3,
            maxLength: 200,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Tell us about yourself...',
              hintStyle: AppTextStyles.bodyMuted,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderSoft),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Save Changes',
            onPressed: _save,
            height: 49,
            borderRadius: 24.5,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.sectionTitle),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _bioController;
  late int _selectedAvatarIndex;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    _nicknameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _selectedAvatarIndex = user?.iconIndex ?? 0;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  bool get _isNicknameValid {
    final value = _nicknameController.text.trim();
    return value.length >= 4 && value.length <= 16;
  }

  bool get _isBioValid {
    final value = _bioController.text.trim();
    return value.length >= 4 && value.length <= 16;
  }

  void _showAvatarPicker() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Choose Profile Icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AuthService.avatarOptions.asMap().entries.map((entry) {
              final option = entry.value;
              final index = entry.key;
              final bool selected = _selectedAvatarIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAvatarIndex = index);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 98,
                  height: 98,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryAccent
                          : AppColors.transparent,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      option,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final nickname = _nicknameController.text.trim();
    final bio = _bioController.text.trim();

    if (!_isNicknameValid || !_isBioValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nickname and bio must be 4 to 16 characters.'),
        ),
      );
      return;
    }

    final success = await AuthService.updateProfile(
      username: nickname,
      bio: bio,
      iconIndex: _selectedAvatarIndex,
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to save profile.')));
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accentDark, width: 2),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accentDark, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryAccent,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryAccent,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: AppColors.primaryAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryAccent,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AuthService.avatarAssetForIndex(_selectedAvatarIndex),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _showAvatarPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Edit Nickname',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nicknameController,
                maxLength: 16,
                decoration: _inputDecoration('Enter new nickname'),
                cursorColor: AppColors.accentDark,
              ),
              const SizedBox(height: 24),
              const Text(
                'Edit Bio',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioController,
                maxLength: 16,
                decoration: _inputDecoration('Enter bio'),
                cursorColor: AppColors.accentDark,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

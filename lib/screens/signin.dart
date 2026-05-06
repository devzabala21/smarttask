import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../core/app_colors.dart';
import '../core/app_themes.dart';
import '../router/app_router.dart';
import '../screens/eula.dart';
import '../widgets/app_btn_custom.dart';
import '../widgets/app_logo_custom.dart';
import '../widgets/app_textfield_custom.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  bool _isAccepted = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppThemes.mainBackground),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    minHeight: constraints.maxHeight,
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(),
                        const SizedBox(height: 35),
                        const AppLogoCustom(size: 150),
                        const Spacer(),

                        SizedBox(
                          height: 350,
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            children: [
                              _buildProfileStep(),
                              _buildSecurityStep(),
                            ],
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(height: 40),
                        _buildBranding(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppTxtFldCustom(label: 'Username'),
        const SizedBox(height: 16),
        const AppTxtFldCustom(label: 'Email'),
        const SizedBox(height: 16),
        const AppTxtFldCustom(label: 'Contact Number'),
        const SizedBox(height: 24),
        AppBtnCustom(
          label: 'Next',
          color: AppColors.primaryAccent,
          onPressed: _nextPage,
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.black),
            children: [
              const TextSpan(text: "Already have an account? "),
              TextSpan(
                text: "Login",
                style: const TextStyle(
                  color: AppColors.secondaryAccent,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, AppRouter.login);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppTxtFldCustom(label: 'Password', obscureText: true,),
        const SizedBox(height: 16),
        const AppTxtFldCustom(label: 'Confirm Password', obscureText: true,),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 28),
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _isAccepted,
                activeColor: AppColors.primaryAccent,
                onChanged: (bool? value) {
                  setState(() {
                    _isAccepted = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey, 
                    fontSize: 12, 
                    fontFamily: 'Inter',
                  ),
                  children: [
                    const TextSpan(text: "I agree to the "),
                    TextSpan(
                      text: "Terms & Conditions",
                      style: const TextStyle(
                        color: AppColors.secondaryAccent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          
                          Navigator.pushNamed(
                            context, 
                            AppRouter.eula, 
                            arguments: AppLegalContent.terms,
                          );
                        },
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Policy",
                      style: const TextStyle(
                        color: AppColors.secondaryAccent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          
                          Navigator.pushNamed(
                            context, 
                            AppRouter.eula, 
                            arguments: AppLegalContent.policy,
                          );
                        },
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        
        AppBtnCustom(
          label: 'Create Account',
          color: _isAccepted ? AppColors.primaryAccent : Colors.grey,
          onPressed: _isAccepted 
            ? () {
                print("Created Account!");
              }: null,
        ),

        const SizedBox(height: 16),
        
        TextButton(
          onPressed: _previousPage,
          child: const Text("Go back to profile", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildBranding() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(fontFamily: 'Aclonica', fontSize: 16, color: AppColors.primaryAccent),
        children: [
          TextSpan(text: "Smart"),
          TextSpan(text: "Task", style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../core/app_colors.dart';
import '../core/app_themes.dart';
import '../router/app_router.dart';
import '../widgets/app_btn_custom.dart';
import '../widgets/app_logo_custom.dart';
import '../widgets/app_textfield_custom.dart';
import '../core/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      setState(() => _emailError = null);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _emailError = "Incorrect Credentials";
      });
    }
  }

  void _handleLogin() {

    bool isSuccess = AuthService.login(
      _emailController.text, 
      _passwordController.text
    );

    if (isSuccess) {
      setState(() => _passwordError = null);
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    } else {
      setState(() {
        _passwordError = "Incorrect Password";
      });
    }
  }

  void _previousPage() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
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
                        const SizedBox(height: 40),
                        const Text(
                          "Welcome Back!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'GreatVibes', fontSize: 50),
                        ),
                        const SizedBox(height: 30),
                        const AppLogoCustom(size: 150),
                        
                        const Spacer(),

                        SizedBox(
                          height: 380,
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildEmailStep(),
                              _buildPasswordStep(),
                            ],
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(height: 40),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontFamily: 'Aclonica', fontSize: 16, color: AppColors.primaryAccent),
                            children: [
                              TextSpan(text: "Smart"),
                              TextSpan(text: "Task", style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
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

  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTxtFldCustom(
          label: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 16),
        Text(
          _emailError ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        AppBtnCustom(
          label: 'Continue',
          onPressed: _handleContinue,
        ),
        const SizedBox(height: 16),
        _buildDivider(),
        const SizedBox(height: 16),
        AppBtnCustom(
          label: 'Continue with Google',
          color: Colors.white,
          textColor: Colors.black,
          iconPath: 'assets/icons/icon_google.svg',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        AppBtnCustom(
          label: 'Continue with Facebook',
          color: Colors.white,
          textColor: Colors.black,
          iconPath: 'assets/icons/icon_facebook.svg',
          onPressed: () {},
        ),
        const SizedBox(height: 24),
        _buildSignUpLink(),
      ],
    );
  }

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTxtFldCustom(
          label: 'Password', 
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 16),
        Text(
          _passwordError ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 23),
        AppBtnCustom(
          label: 'Login',
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _previousPage,
          child: const Text("Use a different email", style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 16),
        const Text(
          "Forgot Password?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondaryAccent,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("or", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.black),
        children: [
          const TextSpan(text: "New here? "),
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(color: AppColors.secondaryAccent, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, AppRouter.signin),
          ),
        ],
      ),
    );
  }
}
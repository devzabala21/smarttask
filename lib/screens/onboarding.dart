import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_themes.dart';
import '../router/app_router.dart';
import '../widgets/app_btn_custom.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppThemes.secondaryBackground,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Visibility(
                    visible: _currentPage > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 38,
                        color: AppColors.primaryAccent,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildPageContent(
                      imagePath: 'assets/img/img_ob1.png',
                      title: 'Stay on track,\none task at a time.',
                      subtitle: 'Plan your schoolwork and daily tasks with ease.',
                      isSecondPage: false,
                    ),
                    _buildPageContent(
                      imagePath: 'assets/img/img_ob2.png',
                      title: 'Organize. Focus. Finish.',
                      subtitle: 'Create to-do lists and manage tasks anytime,\nanywhere.',
                      isSecondPage: true,
                    ),
                  ],
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent({
    required String imagePath,
    required String title,
    required String subtitle,
    required bool isSecondPage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: isSecondPage ? 0.7 : 0.9,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 26,
              height: 1.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Lora',
              fontSize: 16,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page Indicators
              Row(
                children: List.generate(_numPages, (index) => _buildDot(index)),
              ),

              // Seamless Animated Button Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: _currentPage == 0 ? 120 : 180, 
                child: AppBtnCustom(
                  label: _currentPage == 0 ? 'Next' : 'Get Started',
                  color: AppColors.primaryAccent,
                  onPressed: () {
                    if (_currentPage < _numPages - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, AppRouter.home);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildBranding(),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primaryAccent : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBranding() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'Aclonica',
          fontSize: 16,
          color: AppColors.primaryAccent,
        ),
        children: [
          TextSpan(text: "Smart"),
          TextSpan(text: "Task", style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
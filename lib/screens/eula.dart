import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class EulaContent {
  final String title;
  final String content;

  const EulaContent({required this.title, required this.content});
}

class EulaScreen extends StatelessWidget {
  final EulaContent? data;

  const EulaScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final content =
        data ??
        const EulaContent(
          title: 'Terms and Conditions',
          content: '''
Terms and Conditions

1. Introduction
Welcome to Smart Task. By using our app, you agree to these terms.

2. Use of Service
You may use the app for personal task management.

3. Privacy
We respect your privacy and do not share personal data.

4. Changes
We may update these terms at any time.

5. Contact
For questions, contact support@smarttask.com.
''',
        );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.primary),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 38,
                    color: AppColors.primaryAccent,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Center(
                // Add this
                child: Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Inter',
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 72.0),
                  child: Column(
                    children: [
                      Text(
                        content.content,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 45),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Aclonica',
                        fontSize: 18,
                        color: AppColors.primaryAccent,
                      ),
                      children: [
                        TextSpan(text: "Smart"),
                        TextSpan(
                          text: "Task",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
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

class AppLegalContent {
  static const EulaContent terms = EulaContent(
    title: "Terms & Conditions",
    content: """
Welcome to SmartTask. By accessing or using our application, you agree to be bound by these terms. 

1. User Responsibilities
You are responsible for maintaining the security of your account and any activities that occur under your username. You must notify us immediately of any unauthorized use.

2. Intellectual Property
The service and its original content, features, and functionality are and will remain the exclusive property of SmartTask and its licensors.

3. Limitation of Liability
In no event shall SmartTask be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.

4. Governing Law
These Terms shall be governed and construed in accordance with the laws of your jurisdiction, without regard to its conflict of law provisions.

5. Changes
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. What constitutes a material change will be determined at our sole discretion.
    """,
  );

  static const EulaContent policy = EulaContent(
    title: "Privacy Policy",
    content: """
Your privacy is important to us. It is SmartTask's policy to respect your privacy regarding any information we may collect from you across our app.

1. Information We Collect
We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. 

2. Use of Information
We use the information we collect in various ways, including to provide, operate, and maintain our app, and to improve and personalize your experience.

3. Data Security
We store your data using commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use, or modification.

4. Third-Party Services
Our app may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites.

5. Consent
By using our app, you hereby consent to our Privacy Policy and agree to its terms.
    """,
  );
}

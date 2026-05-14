import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';
import '../core/auth_service.dart';
import '../router/app_router.dart';
import '../screens/edit_profile.dart';
import '../screens/settings.dart';

class SideMenuOverlay extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onClose;
  final VoidCallback onArchiveTap;
  final VoidCallback onProfileUpdated;

  const SideMenuOverlay({
    super.key,
    required this.animation,
    required this.onClose,
    required this.onArchiveTap,
    required this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final String username = AuthService.currentUser?.username ?? "Guest";
    final String email = AuthService.currentUser?.email ?? "No Email Provided";
    final String avatar = AuthService.currentUser != null
        ? AuthService.avatarAssetForIndex(AuthService.currentUser!.iconIndex)
        : AuthService.avatarOptions.first;
    final EdgeInsets systemPadding = MediaQuery.of(context).padding;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: animation.value == 0,
          child: Stack(
            children: [
              GestureDetector(
                onTap: onClose,
                child: Container(
                  color: AppColors.black.withValues(alpha: animation.value * 0.3),
                ),
              ),

              //Sliding Menu Panel
              Align(
                alignment: Alignment.centerRight,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      ),
                  child: RepaintBoundary(
                    child: GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: systemPadding.top,
                          bottom: systemPadding.bottom,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(-5, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                //Header
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundColor: AppColors.black,
                                            backgroundImage: AssetImage(avatar),
                                          ),
                                          const SizedBox(width: 12),

                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                username,
                                                style: const TextStyle(
                                                  fontFamily: 'Aclonica',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Text(
                                                email,
                                                style: const TextStyle(
                                                  fontFamily: 'Aclonica',
                                                  color: AppColors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: onClose,
                                        icon: const Icon(
                                          Icons.close,
                                          color: AppColors.primaryAccent,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),

                                //Settings Menu Items
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    children: [
                                      _buildMenuItem(
                                        "Edit Profile",
                                        "assets/icons/icon_profile.svg",
                                        onTap: () async {
                                          onClose();
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const EditProfileScreen(),
                                            ),
                                          );
                                          onProfileUpdated();
                                        },
                                      ),
                                      _buildMenuItem(
                                        "Labels",
                                        "assets/icons/icon_label.svg",
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          AppRouter.label,
                                        ),
                                      ),
                                      _buildMenuItem(
                                        "Archive Cards",
                                        "assets/icons/icon_archive.svg",
                                        onTap: () {
                                          onClose();
                                          onArchiveTap();
                                        },
                                      ),
                                      _buildMenuItem(
                                        "About",
                                        "assets/icons/icon_about.svg",
                                        onTap: () {},
                                      ),
                                      _buildMenuItem(
                                        "Settings",
                                        "assets/icons/icon_settings.svg",
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingsScreen(),
                                          ),
                                        ),
                                      ),
                                      _buildMenuItem(
                                        "Logout",
                                        "assets/icons/icon_logout.svg",
                                        onTap: () {
                                          onClose();
                                          AuthService.currentUser = null;
                                          Navigator.of(
                                            context,
                                          ).pushNamedAndRemoveUntil(
                                            AppRouter.login,
                                            (route) => false,
                                          );
                                        },
                                        isLogout: true,
                                      ),
                                    ],
                                  ),
                                ),

                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                      top: 10.0,
                                    ),
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
                                            style: TextStyle(
                                              color: AppColors.black,
                                            ),
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
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    String title,
    String iconPath, {
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      leading: SvgPicture.asset(
        iconPath,
        width: 30,
        height: 30,
        // ignore: deprecated_member_use
        color: AppColors.primaryAccent,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Lora',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}

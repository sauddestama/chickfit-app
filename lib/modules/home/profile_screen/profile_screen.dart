import 'dart:io';

import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      body: SingleChildScrollView(
        child: FarmStatisticsWidget(),
      ),
    );
  }
}

class FarmStatisticsWidget extends StatelessWidget {
  const FarmStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return _Header(
              user: state.data!,
            );
          },
        ),
        Gap.height(16),
        Padding(
          padding: ThemePadding.phLG,
          child: _buildStatistikPeternakan(),
        ),
        Gap.height(16),

        // Tindakan Cepat Section
        Padding(
          padding: ThemePadding.phLG,
          child: _buildTindakanCepat(),
        ),
        Gap.height(16),

        // Pengaturan Section
        Padding(
          padding: ThemePadding.phLG,
          child: _buildPengaturan(context),
        ),
        const SizedBox(
          height: kToolbarHeight,
        )
      ],
    );
  }

  Widget _buildStatistikPeternakan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Peternakan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AssetColors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Total Ayam Card
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AssetColors.primary20,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Ayam',
                        style: TextStyle(
                          fontSize: 14,
                          color: AssetColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1,250',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Kandang Card
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AssetColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Kandang',
                        style: TextStyle(
                          fontSize: 14,
                          color: AssetColors.black.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.primaryMain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTindakanCepat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tindakan Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AssetColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon placeholder - replace with your SVG
                      Icon(
                        Icons.bar_chart,
                        color: AssetColors.primaryMain,
                        size: 48,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Laporan\nKesehatan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AssetColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: AssetColors.primaryMain,
                        size: 48,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Jadwal\nVaksinasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AssetColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPengaturan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AssetColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProfileMenuItem(
              title: 'Data Kandang',
              icon: Icon(
                Symbols.storage,
                color: AssetColors.primaryMain,
                size: 32,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ProfileMenuItem(
              title: 'Bantuan',
              icon: Icon(
                Symbols.help_outline,
                color: AssetColors.primaryMain,
                size: 32,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ProfileMenuItem(
              title: 'Keluar',
              icon: Icon(
                Symbols.exit_to_app_rounded,
                color: AssetColors.dangerMain,
                size: 32,
              ),
              onTap: () {
                context.read<AppCubit>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MyRouteName.loginPage, (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkPressableBase(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )
      ],
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AssetColors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AssetColors.black.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserProfile user;

  const _Header({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.ds,
        right: 16.ds,
        top: SizeUtil.getStatusBarHeight,
      ),
      decoration: BoxDecoration(
        color: AssetColors.primaryMain,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.ds),
          bottomRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.ds,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Spacer(),
              SvgPicture.asset(
                "assets/icons/edit.svg",
                width: 28,
                height: 28,
              ),
              SizedBox(height: 4.ds),
              SvgPicture.asset(
                "assets/icons/notif.svg",
                width: 28,
                height: 28,
              )
            ],
          ),
          Gap.height(12),
          Center(
            child: _AvatarWithEditButton(user: user),
          ),
          Gap.height(8),
          Center(
            child: Text(
              user.name ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.ds,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.location_on,
                color: AssetColors.white,
                size: 20,
              ),
              Text(
                'Peternakan Sukses Makmur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.ds,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          Gap.height(12),
        ],
      ),
    );
  }
}

class _AvatarWithEditButton extends StatelessWidget {
  final UserProfile user;

  const _AvatarWithEditButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final bool isLoading =
            state.uploadStatus == AuthenticationStatus.loading;

        return Stack(
          children: [
            if (user.avatarUrl == null)
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xff4BB88D),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : Text(user.initials,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
              )
            else
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xff4BB88D),
                backgroundImage:
                    isLoading ? null : NetworkImage(user.avatarUrl!),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      )
                    : null,
              ),
            if (!isLoading)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AssetColors.primaryMain,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: InkWell(
                    onTap: () => _showImagePickerOptions(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt,
                    color: AssetColors.primaryMain),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AssetColors.primaryMain),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext appContext, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null && appContext.mounted) {
        final File imageFile = File(image.path);
        final success =
            await appContext.read<AppCubit>().updateProfilePicture(imageFile);

        if (success) {
          if (appContext.mounted) {
            ScaffoldMessenger.of(appContext).showSnackBar(
              const SnackBar(
                content: Text('Profile picture updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (appContext.mounted) {
            ScaffoldMessenger.of(appContext).showSnackBar(
              const SnackBar(
                content: Text('Failed to update profile picture'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
      // If image is null, user cancelled the picker - no need to show error
    } catch (e) {
      if (appContext.mounted) {
        ScaffoldMessenger.of(appContext).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

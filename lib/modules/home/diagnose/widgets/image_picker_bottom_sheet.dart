import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Gap.height(24),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Pilih Gambar',
              style: TextStyle(
                fontSize: 16.ds,
                fontWeight: FontWeight.w600,
                color: AssetColors.textPrimary,
              ),
            ),
          ),
          Gap.height(24),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Camera option
                _buildOptionTile(
                  context,
                  icon: Icons.camera_alt_outlined,
                  title: 'Ambil Foto',
                  subtitle: 'Gunakan kamera untuk mengambil foto',
                  onTap: () {
                    context.read<DiagnoseFormCubit>().pickImageFromCamera();
                    Navigator.pop(context);
                  },
                ),
                Gap.height(16),

                // Gallery option
                _buildOptionTile(
                  context,
                  icon: Icons.photo_library_outlined,
                  title: 'Pilih dari Galeri',
                  subtitle: 'Pilih foto dari galeri',
                  onTap: () {
                    context.read<DiagnoseFormCubit>().pickImageFromGallery();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Gap.height(32),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AssetColors.primaryMain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AssetColors.primaryMain,
                size: 24,
              ),
            ),
            Gap.width(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.ds,
                      fontWeight: FontWeight.w600,
                      color: AssetColors.textPrimary,
                    ),
                  ),
                  Gap.height(4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.ds,
                      color: AssetColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AssetColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

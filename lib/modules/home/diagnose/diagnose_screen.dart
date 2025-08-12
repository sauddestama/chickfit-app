import 'dart:io';

import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/core/utils/size_config.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/utils/toast_util.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/loading_ring.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/chat_cubit.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_form_cubit.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_histories_cubit.dart';
import 'package:chickfit/modules/home/diagnose/widgets/image_picker_bottom_sheet.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sections/diagnose_histories_section.dart';

class DiagnoseScreen extends StatefulWidget {
  const DiagnoseScreen({Key? key}) : super(key: key);

  @override
  State<DiagnoseScreen> createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  @override
  void initState() {
    final userId = context.read<AppCubit>().state.data!.id;
    context.read<DiagnoseHistoriesCubit>().fetchDiagnoseHistories(
          userId: userId?.toString() ?? "",
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<DiagnoseHistoriesCubit>()
              .fetchDiagnoseHistories(userId: "1"); // TODO: Get actual user ID
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Gap.height(12),
            Expanded(child: DiagnoseTabBarView()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.ds,
        right: 16.ds,
        top: SizeUtil.getStatusBarHeight,
      ),
      height: kToolbarHeight + SizeUtil.getStatusBarHeight,
      decoration: BoxDecoration(
        color: AssetColors.primaryMain,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.ds),
          bottomRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkPressableBase(
                child: BackIconWidget(
                  onTap: () {
                    context.read<HomeCubit>().setActiveHomePageIndex(0);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Diagnosis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.ds,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DiagnoseTabBarView extends StatefulWidget {
  const DiagnoseTabBarView({super.key});

  @override
  State<DiagnoseTabBarView> createState() => _DiagnoseTabBarViewState();
}

class _DiagnoseTabBarViewState extends State<DiagnoseTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AssetColors.primaryMain,
            labelColor: AssetColors.primaryMain,
            unselectedLabelColor: AssetColors.textSecondary,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_camera_outlined),
                    SizedBox(width: 8),
                    Text('Diagnosis'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text('Riwayat'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              DiagnoseFormWidget(
                tabController: _tabController,
              ),
              DiagnoseHistoriesSection(
                tabController: _tabController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiagnoseFormWidget extends StatelessWidget {
  final TabController tabController;
  const DiagnoseFormWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiagnoseFormCubit, DiagnoseFormState>(
      listener: (context, state) async {
        if (state.status == DiagnoseFormStatus.success &&
            state.diagnosisResult != null) {
          // Navigate to result page with the diagnosis data
          final result = await Navigator.of(context).pushNamed(
            MyRouteName.diagnoseResultPage,
            arguments: {
              'diagnosisData': state.diagnosisResult,
              "image": state.selectedImage,
            },
          );
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          if (context.mounted) {
            context.read<DiagnoseFormCubit>().resetStatus();
            final userId = context.read<AppCubit>().state.data!.id;
            context
                .read<DiagnoseHistoriesCubit>()
                .fetchDiagnoseHistories(userId: userId.toString());
          }
          LogUtil.info("TESS aja dulu disini $result ");
          if (result != null && result == "konsultasi") {
            context.read<HomeCubit>().setActiveHomePageIndex(3);
            context.read<ChatCubit>().toggleShowBottomSheetDoctor(true);
            LogUtil.info("TESS aja dulu disini 1 ");
          }
        } else if (state.status == DiagnoseFormStatus.error &&
            state.errorMessage != null) {
          // Show error message
          MessageUtil.showErrorSnackBar(state.errorMessage!);
          // Reset the status
          context.read<DiagnoseFormCubit>().resetStatus();
        }
      },
      child: BlocBuilder<DiagnoseFormCubit, DiagnoseFormState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Info Box
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AssetColors.primaryMain),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Upload foto dengan pencahayaan yang baik",
                            style: TextStyle(
                                fontSize: 14, color: AssetColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Image Container
                BlocBuilder<DiagnoseFormCubit, DiagnoseFormState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        InkPressableBase(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _showImagePickerBottomSheet(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: state.selectedImage != null
                                ? _buildImagePreview(
                                    context, state.selectedImage!)
                                : _buildDottedBorder(),
                          ),
                        ),
                        if (state.status == DiagnoseFormStatus.loading)
                          Container(
                            width: SizeConfig.screenWidth,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black12.withOpacity(0.7),
                            ),
                            child: const SpinKitRing(
                              color: AssetColors.colorPrimaryShades,
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Diagnosis Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ButtonPrimary(
                    text: state.status == DiagnoseFormStatus.loading
                        ? "Processing..."
                        : "Mulai Diagnosis",
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    onPressed: state.selectedImage != null &&
                            state.status != DiagnoseFormStatus.loading
                        ? () {
                            context
                                .read<DiagnoseFormCubit>()
                                .postDiagnoseImage();
                          }
                        : () {},
                    enabled: state.selectedImage != null &&
                        state.status != DiagnoseFormStatus.loading,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, File imageFile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Image.file(
            imageFile,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  context.read<DiagnoseFormCubit>().clearSelectedImage();
                  context.read<DiagnoseFormCubit>().clearSelectedImage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedBorder() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      color: Colors.grey,
      dashPattern: const [8, 4],
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_camera_outlined, size: 40, color: Colors.grey),
            SizedBox(height: 12),
            Text("Tampak fases ayam", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
          value: context.read<DiagnoseFormCubit>(),
          child: const ImagePickerBottomSheet()),
    );
  }
}

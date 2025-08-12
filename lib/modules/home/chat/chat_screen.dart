import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/utils/toast_util.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/consultation/consultation_chat_page_args.dart';
import 'package:chickfit/modules/home/bloc/dashboard_cubit.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/chat_cubit.dart';
import 'package:chickfit/modules/home/chat/sections/resep_list_section.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_histories_cubit.dart';
import 'package:chickfit/modules/home/doctors/bloc/start_consultation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/enum/enum_data_status.dart';
import '../../../data/source/network/responses/get_diagnose_histories_response.dart';
import '../../../models/user_profile.dart';
import 'bloc/consultation_cubit.dart';
import 'sections/consul_histories_section.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          //   TODO on refresh page
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<ChatCubit, ChatState>(
                builder: (context, state) {
                  return _Header(
                    onTapAdd: () {
                      if (state.activeIndex == 0) {
                        _showDoctorSelectionBottomSheet(context);
                      } else {
                        _showDiagnosisHistoryBottomSheet(context);
                      }
                    },
                  );
                },
                listenWhen: (previous, current) =>
                    previous.showBottomSheetDoctor !=
                        current.showBottomSheetDoctor &&
                    previous.showBottomSheetDoctor == false &&
                    current.showBottomSheetDoctor == true,
                listener: (context, state) {
                  if (state.showBottomSheetDoctor) {
                    context
                        .read<ChatCubit>()
                        .toggleShowBottomSheetDoctor(false);
                    _showDoctorSelectionBottomSheet(context);
                  }
                },
              ),
              Gap.height(16),
              Expanded(child: _ChatScreenTabs()),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiagnosisHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<DiagnoseHistoriesCubit>(),
        child: _DiagnosisHistoryBottomSheet(),
      ),
    );
  }

  void _showDoctorSelectionBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<DashboardCubit>(),
        child: _DoctorSelectionBottomSheet(),
      ),
    );
    if (result != null && result is bool && context.mounted) {
      context.read<ConsultationsCubit>().fetchConsultations();
    }
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onTapAdd;

  const _Header({
    Key? key,
    required this.onTapAdd,
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
      height: kToolbarHeight + SizeUtil.getStatusBarHeight,
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
                    "Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.ds,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              InkPressableBase(
                onTap: onTapAdd,
                child: SvgPicture.asset(
                  "assets/icons/add-circle.svg",
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatScreenTabs extends StatefulWidget {
  final ValueNotifier<int> tabIndex = ValueNotifier(0);

  _ChatScreenTabs({
    super.key,
  });

  @override
  State<_ChatScreenTabs> createState() => _ChatScreenTabsState();
}

class _ChatScreenTabsState extends State<_ChatScreenTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabListener);
    super.initState();
  }

  void _tabListener() {
    widget.tabIndex.value = _tabController.index;
    context.read<ChatCubit>().setActiveChatPageIndex(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    widget.tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs
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
                    ValueListenableBuilder<int>(
                      valueListenable: widget.tabIndex,
                      builder: (BuildContext context, value, child) {
                        return SvgPicture.asset(
                          "assets/icons/diagnose_chat.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            value == 0
                                ? AssetColors.primaryMain
                                : AssetColors.textSecondary,
                            BlendMode.srcIn,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Konsultasi',
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: widget.tabIndex,
                      builder: (BuildContext context, value, child) {
                        return SvgPicture.asset(
                          "assets/icons/resep.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            value == 1
                                ? AssetColors.primaryMain
                                : AssetColors.textSecondary,
                            BlendMode.srcIn,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Text('Resep'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tab Contents
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ConsulHistoriesSection(),
              ResepListSection(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DoctorSelectionBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AssetColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.ds),
          topRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.ds),
            width: 40.ds,
            height: 4.ds,
            decoration: BoxDecoration(
              color: AssetColors.grey300,
              borderRadius: BorderRadius.circular(2.ds),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(24.ds),
            child: Row(
              children: [
                Text(
                  'Pilih Dokter',
                  style: TextStyle(
                    fontSize: 16.ds,
                    fontWeight: FontWeight.bold,
                    color: AssetColors.grey900,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AssetColors.grey500,
                    size: 24.ds,
                  ),
                ),
              ],
            ),
          ),

          // Doctor list
          Expanded(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state.dashboardDataStatus == DataStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AssetColors.primaryMain,
                      ),
                    ),
                  );
                }

                if (state.dashboardDataStatus == DataStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.ds,
                          color: AssetColors.grey500,
                        ),
                        SizedBox(height: 16.ds),
                        Text(
                          'Gagal memuat data dokter',
                          style: TextStyle(
                            color: AssetColors.grey500,
                            fontSize: 16.ds,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final veterinarians = state.veterinarians ?? [];

                if (veterinarians.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48.ds,
                          color: AssetColors.grey500,
                        ),
                        SizedBox(height: 16.ds),
                        Text(
                          'Tidak ada dokter tersedia',
                          style: TextStyle(
                            color: AssetColors.grey500,
                            fontSize: 16.ds,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.ds),
                  itemCount: veterinarians.length,
                  itemBuilder: (context, index) {
                    final doctor = veterinarians[index];
                    return _DoctorSelectionCard(doctor: doctor);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorSelectionCard extends StatelessWidget {
  final dynamic doctor; // Using dynamic to avoid import issues

  const _DoctorSelectionCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.ds),
      decoration: BoxDecoration(
        color: AssetColors.white,
        borderRadius: BorderRadius.circular(12.ds),
        border: Border.all(
          color: AssetColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: BlocProvider(
        create: (context) => StartConsultationCubit(
          consultationRepository: locator(),
        ),
        child: BlocConsumer<StartConsultationCubit, StartConsultationState>(
          listener: (context, state) {
            if (state.status == StartConsultationStatus.success) {
              Navigator.pop(context, true);
              Navigator.of(context).pushNamed(
                MyRouteName.consultationChat,
                arguments: ConsultationChatPageArgs(
                  doctorId: doctor.id ?? 0,
                  doctorName: doctor.name ?? "",
                  doctorSpecialist: doctor.specialization ?? "",
                  consultationId: state.consultationId.toString(),
                ),
              );
              context.read<StartConsultationCubit>().reset();
            } else if (state.status == StartConsultationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(state.errorMessage ?? 'Gagal memulai konsultasi'),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<StartConsultationCubit>().reset();
            }
          },
          builder: (context, state) {
            final isLoading = state.status == StartConsultationStatus.loading;

            return InkWell(
              onTap: (doctor.isAvailable == 1 && !isLoading)
                  ? () {
                      context.read<StartConsultationCubit>().startConsultation(
                            doctor.id ?? 0,
                          );
                    }
                  : null,
              borderRadius: BorderRadius.circular(12.ds),
              child: Padding(
                padding: EdgeInsets.all(16.ds),
                child: Row(
                  children: [
                    // Doctor Avatar
                    Container(
                      width: 50.ds,
                      height: 50.ds,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AssetColors.primaryMain.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: doctor.avatarUrl != null &&
                                doctor.avatarUrl!.isNotEmpty
                            ? Image.network(
                                doctor.avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildAvatarFallback();
                                },
                              )
                            : _buildAvatarFallback(),
                      ),
                    ),

                    SizedBox(width: 16.ds),

                    // Doctor Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name ?? 'Unknown Doctor',
                            style: TextStyle(
                              fontSize: 16.ds,
                              fontWeight: FontWeight.w600,
                              color: AssetColors.grey900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 4.ds),

                          Text(
                            doctor.specialization ?? 'Veterinarian',
                            style: TextStyle(
                              fontSize: 14.ds,
                              color: AssetColors.grey500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 8.ds),

                          // Rating and Status Row
                          Row(
                            children: [
                              // Rating
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.ds,
                                  vertical: 4.ds,
                                ),
                                decoration: BoxDecoration(
                                  color: AssetColors.warning60.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.ds),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 12.ds,
                                    ),
                                    SizedBox(width: 4.ds),
                                    Text(
                                      (doctor.rating ?? 0).toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 12.ds,
                                        fontWeight: FontWeight.w600,
                                        color: AssetColors.grey900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8.ds),

                              // Availability Status
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.ds,
                                  vertical: 4.ds,
                                ),
                                decoration: BoxDecoration(
                                  color: (doctor.isAvailable == 1)
                                      ? AssetColors.success50.withOpacity(0.1)
                                      : AssetColors.dangerMain.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.ds),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6.ds,
                                      height: 6.ds,
                                      decoration: BoxDecoration(
                                        color: (doctor.isAvailable == 1)
                                            ? AssetColors.success50
                                            : AssetColors.dangerMain,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4.ds),
                                    Text(
                                      (doctor.isAvailable == 1)
                                          ? 'Available'
                                          : 'Busy',
                                      style: TextStyle(
                                        fontSize: 10.ds,
                                        fontWeight: FontWeight.w600,
                                        color: (doctor.isAvailable == 1)
                                            ? AssetColors.successMain
                                            : AssetColors.dangerMain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action Button
                    if (isLoading)
                      SizedBox(
                        width: 20.ds,
                        height: 20.ds,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AssetColors.primaryMain,
                          ),
                        ),
                      )
                    else if (doctor.isAvailable == 1)
                      Container(
                        padding: EdgeInsets.all(8.ds),
                        decoration: BoxDecoration(
                          color: AssetColors.primaryMain,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: AssetColors.white,
                          size: 16.ds,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      decoration: BoxDecoration(
        color: AssetColors.primaryMain.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          doctor.initials ?? 'DR',
          style: TextStyle(
            fontSize: 18.ds,
            fontWeight: FontWeight.bold,
            color: AssetColors.primaryMain,
          ),
        ),
      ),
    );
  }
}

class _DiagnosisHistoryBottomSheet extends StatefulWidget {
  @override
  State<_DiagnosisHistoryBottomSheet> createState() =>
      _DiagnosisHistoryBottomSheetState();
}

class _DiagnosisHistoryBottomSheetState
    extends State<_DiagnosisHistoryBottomSheet> {
  late DiagnoseHistoriesCubit _diagnoseHistoriesCubit;
  UserProfile? _currentUser;

  @override
  void initState() {
    super.initState();
    _diagnoseHistoriesCubit = context.read<DiagnoseHistoriesCubit>();
  }

  Future<void> _requestPrescription(int diagnosisId) async {
    final success =
        await _diagnoseHistoriesCubit.requestPrescription(diagnosisId);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        MessageUtil.showInfoToast("Resep berhasil diminta");
      } else {
        Navigator.pop(context);
        final state = _diagnoseHistoriesCubit.state;
        MessageUtil.showErrorSnackBar(
            state.prescriptionRequestMessage ?? 'Gagal meminta resep');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AssetColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.ds),
          topRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.ds),
            width: 40.ds,
            height: 4.ds,
            decoration: BoxDecoration(
              color: AssetColors.grey300,
              borderRadius: BorderRadius.circular(2.ds),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(24.ds),
            child: Row(
              children: [
                Text(
                  'Riwayat Diagnosis',
                  style: TextStyle(
                    fontSize: 16.ds,
                    fontWeight: FontWeight.bold,
                    color: AssetColors.grey900,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AssetColors.grey500,
                    size: 24.ds,
                  ),
                ),
              ],
            ),
          ),

          // Diagnosis history list
          Expanded(
            child: BlocBuilder<DiagnoseHistoriesCubit, DiagnoseHistoriesState>(
              builder: (context, state) {
                if (state.prescriptionRequestStatus == DataStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AssetColors.primaryMain,
                      ),
                    ),
                  );
                }

                if (state.diagnoseHistoriesDataStatus == DataStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.ds,
                          color: AssetColors.grey500,
                        ),
                        SizedBox(height: 16.ds),
                        Text(
                          'Gagal memuat riwayat diagnosis',
                          style: TextStyle(
                            color: AssetColors.grey500,
                            fontSize: 16.ds,
                          ),
                        ),
                        SizedBox(height: 16.ds),
                      ],
                    ),
                  );
                }

                final diagnoseHistories = state.diagnoseHistories ?? [];

                if (diagnoseHistories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 48.ds,
                          color: AssetColors.grey500,
                        ),
                        SizedBox(height: 16.ds),
                        Text(
                          'Belum ada riwayat diagnosis',
                          style: TextStyle(
                            color: AssetColors.grey500,
                            fontSize: 16.ds,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.ds),
                  itemCount: diagnoseHistories.length,
                  itemBuilder: (context, index) {
                    final diagnosis = diagnoseHistories[index];
                    return _DiagnosisHistoryCard(
                      diagnosis: diagnosis,
                      onRequestPrescription: () {
                        if (diagnosis.id != null) {
                          _requestPrescription(diagnosis.id!);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosisHistoryCard extends StatelessWidget {
  final DiagnoseHistoryItem diagnosis;
  final VoidCallback onRequestPrescription;

  const _DiagnosisHistoryCard({
    required this.diagnosis,
    required this.onRequestPrescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.ds),
      decoration: BoxDecoration(
        color: AssetColors.white,
        borderRadius: BorderRadius.circular(12.ds),
        border: Border.all(
          color: AssetColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.ds),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with image and basic info
            Row(
              children: [
                // Diagnosis image
                if (diagnosis.image?.url != null)
                  Container(
                    width: 60.ds,
                    height: 60.ds,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.ds),
                      border: Border.all(
                        color: AssetColors.grey200,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.ds),
                      child: Image.network(
                        diagnosis.image!.url!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AssetColors.grey100,
                              borderRadius: BorderRadius.circular(8.ds),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: AssetColors.grey500,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60.ds,
                    height: 60.ds,
                    decoration: BoxDecoration(
                      color: AssetColors.grey100,
                      borderRadius: BorderRadius.circular(8.ds),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: AssetColors.grey500,
                    ),
                  ),

                SizedBox(width: 16.ds),

                // Diagnosis info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diagnosis.label ?? 'Unknown Diagnosis',
                        style: TextStyle(
                          fontSize: 16.ds,
                          fontWeight: FontWeight.w600,
                          color: AssetColors.grey900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.ds),
                      Text(
                        'Confidence: ${(diagnosis.confidence ?? 0) * 100}%',
                        style: TextStyle(
                          fontSize: 12.ds,
                          color: AssetColors.grey500,
                        ),
                      ),
                      SizedBox(height: 4.ds),
                      Text(
                        'Date: ${diagnosis.createdAt?.toString().split(' ')[0] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12.ds,
                          color: AssetColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.ds),

            // Verification status
            if (diagnosis.verified == true)
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.ds,
                      vertical: 4.ds,
                    ),
                    decoration: BoxDecoration(
                      color: AssetColors.success50.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.ds),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: AssetColors.successMain,
                          size: 12.ds,
                        ),
                        SizedBox(width: 4.ds),
                        Text(
                          "Verified",
                          style: TextStyle(
                            fontSize: 10.ds,
                            fontWeight: FontWeight.w600,
                            color: AssetColors.successMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            SizedBox(height: 16.ds),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRequestPrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AssetColors.primaryMain,
                  foregroundColor: AssetColors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.ds),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.ds),
                  ),
                ),
                child: Text(
                  'Minta Resep',
                  style: TextStyle(
                    fontSize: 12.ds,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

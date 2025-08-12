import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/shimmer_box.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/data/source/network/responses/get_diagnose_histories_response.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/chat_cubit.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_histories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiagnoseHistoriesSection extends StatelessWidget {
  final TabController tabController;
  const DiagnoseHistoriesSection({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AppCubit>().state.data!.id;
        context
            .read<DiagnoseHistoriesCubit>()
            .fetchDiagnoseHistories(userId: userId.toString());
      },
      child: BlocBuilder<DiagnoseHistoriesCubit, DiagnoseHistoriesState>(
        builder: (context, state) {
          if (state.diagnoseHistoriesDataStatus == DataStatus.loading ||
              state.diagnoseHistoriesDataStatus == DataStatus.initial) {
            // Loading state using shimmer placeholders for diagnose history cards
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) =>
                  const _DiagnoseHistoryCardShimmer(),
            );
          }
          if (state.diagnoseHistoriesDataStatus != DataStatus.success) {
            // Error state
            return ErrorListWidget(
              pullToRefresh: false,
            );
          }
          if (state.diagnoseHistories?.length == 0) {
            return ListView(
              children: [
                EmptyListWidget(text: "Belum ada riwayat diagnosis"),
              ],
            );
          }
          return ListView.separated(
            padding: ThemePadding.pv4,
            itemCount: state.diagnoseHistories?.length ?? 0,
            itemBuilder: (context, idx) {
              final diagnoseHistory = state.diagnoseHistories![idx];
              return _DiagnoseHistoryCard(
                diagnoseHistory: diagnoseHistory,
                onTap: () async {
                  final result = await Navigator.of(context).pushNamed(
                    MyRouteName.diagnoseResultPage,
                    arguments: {
                      'id': diagnoseHistory.id!,
                    },
                  );
                  LogUtil.info("TESS aja dulu disini $result ");
                  if (result != null && result == "konsultasi") {
                    context.read<HomeCubit>().setActiveHomePageIndex(3);
                    context.read<ChatCubit>().toggleShowBottomSheetDoctor(true);
                    LogUtil.info("TESS aja dulu disini 1 ");
                  } else if (result != null && result == "diagnosa") {
                    LogUtil.info("TESS aja dulu disini 2 ");
                    tabController.animateTo(0);
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12,
              );
            },
          );
        },
      ),
    );
  }
}

class _DiagnoseHistoryCard extends StatelessWidget {
  final DiagnoseHistoryItem diagnoseHistory;
  final VoidCallback onTap;

  const _DiagnoseHistoryCard({
    required this.diagnoseHistory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkPressableBase(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Title and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Diagnosis #${diagnoseHistory.id ?? 'Unknown'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AssetColors.black),
                      const SizedBox(width: 4),
                      Text(_formatDate(diagnoseHistory.createdAt),
                          style: const TextStyle(
                              color: AssetColors.black, fontSize: 14)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Diagnosis Result
              Row(
                children: [
                  const Text("Hasil: "),
                  Text(
                    "${(diagnoseHistory.confidence! * 100).toStringAsFixed(1)}% ${diagnoseHistory.label ?? 'Unknown Disease'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return "${difference.inDays} hari yang lalu";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} menit yang lalu";
    } else {
      return "Baru saja";
    }
  }
}

class _DiagnoseHistoryCardShimmer extends StatelessWidget {
  const _DiagnoseHistoryCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerBox(height: 16, width: 120, radius: 8),
              Row(
                children: [
                  ShimmerBox(height: 14, width: 14, radius: 7),
                  SizedBox(width: 4),
                  ShimmerBox(height: 14, width: 80, radius: 8),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),

          // Diagnosis Result
          Row(
            children: const [
              ShimmerBox(height: 14, width: 40, radius: 8),
              SizedBox(width: 4),
              ShimmerBox(height: 14, width: 150, radius: 8),
            ],
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child:
                    ShimmerBox(height: 40, width: double.infinity, radius: 12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    ShimmerBox(height: 40, width: double.infinity, radius: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/formatter.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/shimmer_box.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/data/source/network/responses/get_resep_response.dart';
import 'package:chickfit/modules/home/chat/bloc/prescriptions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResepListSection extends StatefulWidget {
  const ResepListSection({Key? key}) : super(key: key);

  @override
  State<ResepListSection> createState() => _ResepListSectionState();
}

class _ResepListSectionState extends State<ResepListSection> {
  @override
  void initState() {
    final userId = context.read<AppCubit>().state.data!.id;
    context.read<PrescriptionsCubit>().fetchPrescriptions(
          userId?.toString() ?? "",
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AppCubit>().state.data!.id;
        context.read<PrescriptionsCubit>().fetchPrescriptions(
              userId?.toString() ?? "",
            );
      },
      child: BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
        builder: (context, state) {
          if (state.dataStatus == DataStatus.loading ||
              state.dataStatus == DataStatus.initial) {
            return ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              padding: ThemePadding.pv4 + ThemePadding.ph16,
              itemCount: 5,
              itemBuilder: (context, index) => const _PrescriptionItemShimmer(),
            );
          }

          if (state.dataStatus != DataStatus.success) {
            return ErrorListWidget(
              pullToRefresh: false,
            );
          }

          if (state.prescriptions == null || state.prescriptions!.isEmpty) {
            return ListView(
              children: [
                EmptyListWidget(
                  text: 'Belum ada resep',
                ),
              ],
            );
          }

          return ListView.separated(
            padding: ThemePadding.pv4 + ThemePadding.ph16,
            itemCount: state.prescriptions!.length,
            itemBuilder: (context, idx) {
              final PrescriptionItemResponse prescription =
                  state.prescriptions![idx];
              return ResepCard(
                prescription: prescription,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
          );
        },
      ),
    );
  }
}

class ResepCard extends StatelessWidget {
  final PrescriptionItemResponse prescription;

  const ResepCard({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resep #${prescription.id ?? 0}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AssetColors.black,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: AssetColors.black.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    prescription.createdAt != null
                        ? Formatter.timeAgo(prescription.createdAt!)
                        : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: AssetColors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk: ${prescription.diagnosisLabel ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14,
                  color: AssetColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dokter: ${prescription.doctorName ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14,
                  color: AssetColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ButtonPrimary(
            width: double.infinity,
            onPressed: () {
              if (prescription.id != null) {
                Navigator.of(context).pushNamed(
                  MyRouteName.resepDetail,
                  arguments: {'resepId': prescription.id},
                );
              }
            },
            text: "Lihat Resep",
          ),
        ],
      ),
    );
  }
}

class _PrescriptionItemShimmer extends StatelessWidget {
  const _PrescriptionItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ThemePadding.pv4,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(
                height: 16,
                width: 80,
                radius: 4,
              ),
              Row(
                children: [
                  ShimmerBox(
                    height: 12,
                    width: 12,
                    radius: 6,
                  ),
                  const SizedBox(width: 4),
                  ShimmerBox(
                    height: 12,
                    width: 60,
                    radius: 4,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                height: 14,
                width: 120,
                radius: 4,
              ),
              const SizedBox(height: 4),
              ShimmerBox(
                height: 14,
                width: 100,
                radius: 4,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Button shimmer
          ShimmerBox(
            height: 48,
            width: double.infinity,
            radius: 8,
          ),
        ],
      ),
    );
  }
}

import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/formatter.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/shimmer_box.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/data/source/network/responses/get_consultations_response.dart';
import 'package:chickfit/modules/consultation/consultation_chat_page_args.dart';
import 'package:chickfit/modules/home/chat/bloc/consultation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsulHistoriesSection extends StatelessWidget {
  const ConsulHistoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ConsultationsCubit>().fetchConsultations();
      },
      child: BlocBuilder<ConsultationsCubit, ConsultationsState>(
        builder: (context, state) {
          if (state.consultationsDataStatus == DataStatus.loading ||
              state.consultationsDataStatus == DataStatus.initial) {
            return ListView.builder(
              padding: ThemePadding.pv4 + ThemePadding.ph16,
              itemCount: 5,
              itemBuilder: (context, index) => const _ConsultationItemShimmer(),
            );
          }

          if (state.consultationsDataStatus != DataStatus.success) {
            return ErrorListWidget(
              pullToRefresh: false,
            );
          }

          if (state.consultations == null || state.consultations!.isEmpty) {
            return ListView(
              children: [
                EmptyListWidget(
                  text: 'Belum ada konsultasi',
                ),
              ],
            );
          }

          return ListView.separated(
            padding: ThemePadding.pv4 + ThemePadding.ph16,
            itemCount: state.consultations!.length,
            itemBuilder: (context, idx) {
              final consultation = state.consultations![idx];
              return _ConsultationItem(
                consultation: consultation,
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

class _ConsultationItem extends StatelessWidget {
  final ConsultationItemResponse consultation;

  const _ConsultationItem({
    required this.consultation,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = consultation.chatWith;
    final lastMessageTime = consultation.lastMessageTime;

    return InkPressableBase(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Navigator.of(context).pushNamed(
          MyRouteName.consultationChat,
          arguments: ConsultationChatPageArgs(
            doctorId: doctor?.id ?? 0,
            doctorName: doctor?.name ?? "",
            doctorSpecialist: doctor?.specialization ?? "",
            consultationId: consultation.id.toString(),
          ),
        );
        context.read<ConsultationsCubit>().fetchConsultations();
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: AssetColors.primary50,
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Doctor Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AssetColors.primary50.withOpacity(0.1),
                backgroundImage: doctor?.avatarUrl != null
                    ? NetworkImage(doctor!.avatarUrl!)
                    : null,
                child: doctor?.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AssetColors.primary50,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doctor?.name ?? 'Dokter',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AssetColors.black,
                          ),
                        ),
                        if (lastMessageTime != null)
                          Text(
                            Formatter.timeAgo(lastMessageTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: AssetColors.black.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      consultation.lastMessage ?? 'Tidak ada pesan',
                      style: TextStyle(
                        fontSize: 14,
                        color: AssetColors.black.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (doctor?.specialization != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        doctor!.specialization!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AssetColors.primary50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsultationItemShimmer extends StatelessWidget {
  const _ConsultationItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ThemePadding.pv4,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: AssetColors.primary50,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar shimmer
            ShimmerBox(
              height: 48,
              width: 48,
              radius: 24,
            ),
            const SizedBox(width: 16),

            // Content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(
                        height: 16,
                        width: 120,
                        radius: 4,
                      ),
                      ShimmerBox(
                        height: 12,
                        width: 80,
                        radius: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ShimmerBox(
                    height: 14,
                    width: double.infinity,
                    radius: 4,
                  ),
                  const SizedBox(height: 8),
                  ShimmerBox(
                    height: 12,
                    width: 100,
                    radius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

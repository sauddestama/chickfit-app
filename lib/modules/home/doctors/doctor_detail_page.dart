import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/data/source/network/responses/veterinarian_item_response.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/consultation/consultation_chat_page_args.dart';
import 'package:chickfit/modules/home/doctors/bloc/start_consultation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorDetailPage extends StatefulWidget {
  final VeterinarianItemResponse doctor;

  static route(settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final doctor = args?['doctor'] as VeterinarianItemResponse;
    LogUtil.info("TES ${doctor}");
    LogUtil.info("TES ${doctor.id}");
    return MyPageRoute(
        BlocProvider(
          create: (context) => StartConsultationCubit(
            consultationRepository: locator(),
          ),
          child: DoctorDetailPage(doctor: doctor),
        ),
        settings);
  }

  const DoctorDetailPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AssetColors.primaryMain,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: AssetColors.grey100,
      appBar: AppBar(
        backgroundColor: AssetColors.primaryMain,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkPressableBase(
              child: BackIconWidget(
                size: 32,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Detail Dokter',
                  style: TextStyle(
                    color: AssetColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Section
            Container(
              width: double.infinity,
              color: AssetColors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Doctor Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AssetColors.primaryMain,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: widget.doctor.avatarUrl != null &&
                              widget.doctor.avatarUrl!.isNotEmpty
                          ? Image.network(
                              widget.doctor.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildAvatarFallback();
                              },
                            )
                          : _buildAvatarFallback(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Doctor Name
                  Text(
                    widget.doctor.name ?? 'Unknown Doctor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AssetColors.grey900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Specialization
                  Text(
                    widget.doctor.specialization ?? 'Veterinarian',
                    style: TextStyle(
                      fontSize: 16,
                      color: AssetColors.grey700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Rating and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AssetColors.warning60.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (widget.doctor.rating ?? 0).toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AssetColors.grey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Availability Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (widget.doctor.isAvailable == 1)
                              ? AssetColors.success50.withOpacity(0.1)
                              : AssetColors.dangerMain.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: (widget.doctor.isAvailable == 1)
                                    ? AssetColors.success50
                                    : AssetColors.dangerMain,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              (widget.doctor.isAvailable == 1)
                                  ? 'Available'
                                  : 'Busy',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: (widget.doctor.isAvailable == 1)
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

            const SizedBox(height: 16),

            // Information Section
            Container(
              width: double.infinity,
              color: AssetColors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Dokter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AssetColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.email_outlined, 'Email',
                      widget.doctor.email ?? '-'),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.medical_services_outlined, 'Spesialisasi',
                      widget.doctor.specialization ?? '-'),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.calendar_today_outlined, 'Bergabung',
                      _formatDate(widget.doctor.createdAt)),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AssetColors.white,
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<StartConsultationCubit, StartConsultationState>(
          listener: (context, state) {
            if (state.status == StartConsultationStatus.success) {
              Navigator.of(context).pushNamed(
                MyRouteName.consultationChat,
                arguments: ConsultationChatPageArgs(
                  doctorId: widget.doctor.id ?? 0,
                  doctorName: widget.doctor.name ?? "",
                  doctorSpecialist: widget.doctor.specialization ?? "",
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

            return ElevatedButton.icon(
              onPressed: (widget.doctor.isAvailable == 1 && !isLoading)
                  ? () {
                      context.read<StartConsultationCubit>().startConsultation(
                            widget.doctor.id ?? 0,
                          );
                    }
                  : null,
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AssetColors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.chat_bubble_outline,
                      color: AssetColors.white,
                    ),
              label: Text(isLoading ? 'Memulai...' : 'Konsultasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AssetColors.primaryMain,
                foregroundColor: AssetColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: AssetColors.grey300,
                disabledForegroundColor: AssetColors.grey500,
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
          widget.doctor.initials,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AssetColors.primaryMain,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AssetColors.grey700,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AssetColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AssetColors.grey900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Updated Doctor Card Widget for Home Page
class DoctorCard extends StatelessWidget {
  final VeterinarianItemResponse doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    Key? key,
    required this.doctor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetailPage(doctor: doctor),
              ),
            );
          },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AssetColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Doctor Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AssetColors.primaryMain.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
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
              const SizedBox(height: 8),

              // Doctor Name
              Text(
                doctor.name ?? 'Unknown Doctor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AssetColors.grey900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              // Specialization
              Text(
                doctor.specialization ?? 'Veterinarian',
                style: TextStyle(
                  fontSize: 10,
                  color: AssetColors.grey500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    (doctor.rating ?? 0).toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AssetColors.grey700,
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

  Widget _buildAvatarFallback() {
    return Container(
      decoration: BoxDecoration(
        color: AssetColors.primaryMain.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          doctor.initials,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AssetColors.primaryMain,
          ),
        ),
      ),
    );
  }
}

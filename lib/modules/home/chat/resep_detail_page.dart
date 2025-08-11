import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/image_loader.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/home/chat/bloc/resep_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResepDetailPage extends StatefulWidget {
  final int resepId;

  static route(settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final resepId = args?['resepId'] as int? ?? 0;
    return MyPageRoute(
      BlocProvider(
        create: (context) => ResepDetailCubit(
          consultationRepository: locator(),
        ),
        child: ResepDetailPage(resepId: resepId),
      ),
      settings,
    );
  }

  const ResepDetailPage({
    Key? key,
    required this.resepId,
  }) : super(key: key);

  @override
  State<ResepDetailPage> createState() => _ResepDetailPageState();
}

class _ResepDetailPageState extends State<ResepDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ResepDetailCubit>().fetchResepDetail(widget.resepId);
  }

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
                  'Detail Resep',
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
      body: BlocBuilder<ResepDetailCubit, ResepDetailState>(
        builder: (context, state) {
          if (state.resepDetailDataStatus == DataStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AssetColors.primaryMain,
                ),
              ),
            );
          }

          if (state.resepDetailDataStatus == DataStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.ds,
                    color: AssetColors.grey500,
                  ),
                  Gap.height(16),
                  Text(
                    state.errorMessage ?? 'Gagal memuat detail resep',
                    style: TextStyle(
                      color: AssetColors.grey500,
                      fontSize: 16.ds,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap.height(16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ResepDetailCubit>()
                          .fetchResepDetail(widget.resepId);
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final prescription = state.prescription;
          if (prescription == null) {
            return Center(
              child: Text(
                'Data resep tidak ditemukan',
                style: TextStyle(
                  color: AssetColors.grey500,
                  fontSize: 16.ds,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prescription Header Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    children: [
                      // Prescription Image
                      if (prescription.image?.url != null)
                        Container(
                          width: 120.ds,
                          height: 120.ds,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.ds),
                            border: Border.all(
                              color: AssetColors.grey200,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.ds),
                            child: ImageLoader(
                              url: prescription.image!.url!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 120.ds,
                          height: 120.ds,
                          decoration: BoxDecoration(
                            color: AssetColors.grey100,
                            borderRadius: BorderRadius.circular(16.ds),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: AssetColors.grey500,
                            size: 48.ds,
                          ),
                        ),

                      Gap.height(16),

                      // Prescription Title
                      Text(
                        'Resep #${prescription.id}',
                        style: TextStyle(
                          fontSize: 20.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),

                      Gap.height(8),

                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.ds,
                          vertical: 6.ds,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(prescription.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.ds),
                        ),
                        child: Text(
                          _getStatusText(prescription.status),
                          style: TextStyle(
                            fontSize: 12.ds,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(prescription.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap.height(16),

                // Diagnosis Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diagnosis',
                        style: TextStyle(
                          fontSize: 18.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),
                      Gap.height(16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Penyakit',
                                  style: TextStyle(
                                    fontSize: 14.ds,
                                    color: AssetColors.grey700,
                                  ),
                                ),
                                Gap.height(4),
                                Text(
                                  prescription.diagnosis?.label ??
                                      'Tidak diketahui',
                                  style: TextStyle(
                                    fontSize: 16.ds,
                                    fontWeight: FontWeight.w600,
                                    color: AssetColors.grey900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Confidence',
                                style: TextStyle(
                                  fontSize: 14.ds,
                                  color: AssetColors.grey700,
                                ),
                              ),
                              Gap.height(4),
                              Text(
                                '${((prescription.diagnosis?.confidence ?? 0) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 16.ds,
                                  fontWeight: FontWeight.w600,
                                  color: AssetColors.primaryMain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gap.height(16),

                // Medicine Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Obat',
                        style: TextStyle(
                          fontSize: 18.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),
                      Gap.height(16),
                      Text(
                        prescription.medicine ?? 'Tidak ada informasi obat',
                        style: TextStyle(
                          fontSize: 16.ds,
                          color: AssetColors.grey900,
                        ),
                      ),
                    ],
                  ),
                ),

                Gap.height(16),

                // Usage Instructions Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cara Penggunaan',
                        style: TextStyle(
                          fontSize: 18.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),
                      Gap.height(16),
                      Text(
                        prescription.usageInstructions ??
                            'Tidak ada instruksi penggunaan',
                        style: TextStyle(
                          fontSize: 16.ds,
                          color: AssetColors.grey900,
                        ),
                      ),
                    ],
                  ),
                ),

                Gap.height(16),

                // Notes Section
                if (prescription.notes != null &&
                    prescription.notes!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    color: AssetColors.white,
                    padding: EdgeInsets.all(24.ds),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan',
                          style: TextStyle(
                            fontSize: 18.ds,
                            fontWeight: FontWeight.bold,
                            color: AssetColors.grey900,
                          ),
                        ),
                        Gap.height(16),
                        Text(
                          prescription.notes!,
                          style: TextStyle(
                            fontSize: 16.ds,
                            color: AssetColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ),

                Gap.height(16),

                // People Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi',
                        style: TextStyle(
                          fontSize: 18.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),
                      Gap.height(16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dokter',
                                  style: TextStyle(
                                    fontSize: 14.ds,
                                    color: AssetColors.grey700,
                                  ),
                                ),
                                Gap.height(4),
                                Text(
                                  prescription.doctorName ?? 'Tidak diketahui',
                                  style: TextStyle(
                                    fontSize: 16.ds,
                                    fontWeight: FontWeight.w600,
                                    color: AssetColors.grey900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Peternak',
                                style: TextStyle(
                                  fontSize: 14.ds,
                                  color: AssetColors.grey700,
                                ),
                              ),
                              Gap.height(4),
                              Text(
                                prescription.farmerName ?? 'Tidak diketahui',
                                style: TextStyle(
                                  fontSize: 16.ds,
                                  fontWeight: FontWeight.w600,
                                  color: AssetColors.grey900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gap.height(16),

                // Date Section
                Container(
                  width: double.infinity,
                  color: AssetColors.white,
                  padding: EdgeInsets.all(24.ds),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Dibuat',
                        style: TextStyle(
                          fontSize: 18.ds,
                          fontWeight: FontWeight.bold,
                          color: AssetColors.grey900,
                        ),
                      ),
                      Gap.height(16),
                      Text(
                        prescription.createdAt != null
                            ? _formatDate(prescription.createdAt!)
                            : 'Tidak diketahui',
                        style: TextStyle(
                          fontSize: 16.ds,
                          color: AssetColors.grey900,
                        ),
                      ),
                    ],
                  ),
                ),

                Gap.height(24),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return AssetColors.successMain;
      case 'pending':
        return AssetColors.warningMain;
      case 'rejected':
        return AssetColors.dangerMain;
      default:
        return AssetColors.grey500;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return 'Disetujui';
      case 'pending':
        return 'Menunggu';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Tidak diketahui';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/utils.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/loading_ring.dart';
import 'package:chickfit/data/source/network/responses/diagnose_result_response.dart';
import 'package:chickfit/modules/diagnose_result/diagnose_result_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiagnosisResultPage extends StatelessWidget {
  static route(settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final diagnosisData = args?['diagnosisData'] as DiagnoseResultResponse?;
    final id = args?['id'] as int?;
    return MyPageRouteRightToLeft(
        BlocProvider(
          create: (context) => DiagnoseResultCubit()
            ..setSelectedImage(args?['image'])
            ..setDiangoseResult(diagnosisData, id),
          child: DiagnosisResultPage(),
        ),
        settings);
  }

  const DiagnosisResultPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration if no data is provided

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AssetColors.primaryMain,
      statusBarIconBrightness: Brightness.light,
    ));
    return BlocBuilder<DiagnoseResultCubit, DiagnoseResultState>(
      builder: (context, state) {
        final data = state.diagnosisResult ?? _getSampleData();
        final prediction = data.prediction;
        final image = data.image;
        final DiagnoseResultResponse? diagnosisData;
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AssetColors.white,
          body: Stack(
            children: [
              SafeArea(
                child: ListView(
                  padding: ThemePadding.pa0,
                  children: [
                    // Header

                    Container(
                      color: Colors.white,
                      child: _Header(
                        content: _buildDiagnosisCard(prediction, image),
                      ),
                    ),

                    // Main content
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Diagnosis Result Card
                          const SizedBox(height: 20),

                          // Symptoms and Recommendations
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Symptoms Section
                                  _buildSymptomsSection(
                                      prediction?.symptomsDetected ?? []),

                                  const SizedBox(height: 30),

                                  // Recommendations Section
                                  _buildRecommendationsSection(
                                      prediction?.recommendations ?? []),

                                  const SizedBox(height: 30),
                                  // Action Buttons
                                  _ActionButton(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<DiagnoseResultCubit, DiagnoseResultState>(
                builder: (context, state) {
                  if (state.status == DiagnoseResultStatus.loading) {
                    return Container(
                      color: Colors.black12.withOpacity(0.7),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: const SpinKitRing(
                        color: AssetColors.colorPrimaryShades,
                      ),
                    );
                  }
                  return Container();
                },
                listener: (BuildContext context, state) {
                  if (state.status == DiagnoseResultStatus.success &&
                      state.diagnosisResult != null) {
                    // Navigate to result page with the diagnosis data

                    // Reset the status
                    context.read<DiagnoseResultCubit>().resetStatus();
                  } else if (state.status == DiagnoseResultStatus.error &&
                      state.errorMessage != null) {
                    // Show error message
                    MessageUtil.showErrorSnackBar(state.errorMessage!);
                    // Reset the status
                    context.read<DiagnoseResultCubit>().resetStatus();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'Hasil Diagnosis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard(
      DiagnoseResultPrediction? prediction, DiagnoseResultImage? image) {
    final label = prediction?.label ?? 'Unknown';
    final confidence = prediction?.confidence ?? 0.0;
    final confidencePercentage = (confidence * 100).toStringAsFixed(1);

    // Get disease name in Indonesian
    String diseaseNameIndonesian = _getDiseaseNameIndonesian(label);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disease name and accuracy
          Text(
            diseaseNameIndonesian,
            style: const TextStyle(
              color: AssetColors.primaryMain,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Akurasi : $confidencePercentage%',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 20),

          // Image and Pie Chart Row
          Row(
            children: [
              // Image
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: image?.url != null
                            ? DecorationImage(
                                image: NetworkImage(image!.url!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey[300],
                      ),
                      child: image?.url == null
                          ? const Icon(Icons.image,
                              size: 50, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$label : $confidencePercentage%',
                      style: const TextStyle(
                        color: AssetColors.primaryMain,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Pie Chart
              Expanded(
                flex: 1,
                child: _buildPieChart(prediction?.allPredictions),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(DiagnoseResultAllPredictions? allPredictions) {
    if (allPredictions == null) return const SizedBox();

    final coccidiosis = (allPredictions.coccidiosis ?? 0.0) * 100;
    final nd = (allPredictions.nd ?? 0.0) * 100;
    final sehat = (allPredictions.sehat ?? 0.0) * 100;

    // Create pie chart sections
    final sections = <PieChartSectionData>[];

    if (coccidiosis > 0) {
      sections.add(
        PieChartSectionData(
          color: AssetColors.primary70,
          value: coccidiosis,
          title: '${coccidiosis.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (nd > 0) {
      sections.add(
        PieChartSectionData(
          color: AssetColors.primary50,
          value: nd,
          title: '${nd.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    if (sehat > 0) {
      sections.add(
        PieChartSectionData(
          color: AssetColors.primary20,
          value: sehat,
          title: '${sehat.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pie Chart
        SizedBox(
          width: 120,
          height: 120,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Legend
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (coccidiosis > 0)
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AssetColors.primary70,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Coccidiosis: ${coccidiosis.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            if (nd > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AssetColors.primary50,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ND: ${nd.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
            if (sehat > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AssetColors.primary20,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sehat: ${sehat.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSymptomsSection(List<String> symptoms) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gejala Terdeteksi',
          style: TextStyle(
            color: AssetColors.primaryMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...symptoms
            .map((symptom) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          symptom,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildRecommendationsSection(List<String> recommendations) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi',
          style: TextStyle(
            color: AssetColors.primaryMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _getDiseaseNameIndonesian(String label) {
    switch (label.toUpperCase()) {
      case 'ND':
        return 'Newcastle Disease';
      case 'COCCIDIOSIS':
        return 'Coccidiosis';
      case 'SEHAT':
        return 'Sehat';
      default:
        return label;
    }
  }

  // Sample data for demonstration
  DiagnoseResultResponse _getSampleData() {
    return DiagnoseResultResponse(
      image: DiagnoseResultImage(
        id: 7,
        filename: "sample_image.jpg",
        url: "https://example.com/sample_image.jpg",
        size: 12908,
        dimensions: Dimensions(width: 224, height: 224),
      ),
      prediction: DiagnoseResultPrediction(
        id: 7,
        label: "ND",
        confidence: 0.942,
        isConfident: true,
        allPredictions: DiagnoseResultAllPredictions(
          coccidiosis: 0.03,
          nd: 0.94,
          sehat: 0.03,
        ),
        modelInfo: DiagnoseResultModelInfo(
          name: "ChickFit CNN Model",
          version: "v1.0",
          accuracy: 0.9535,
          classes: ["Coccidiosis", "ND", "Sehat"],
          inputShape: [224, 224, 3],
          trainedAt: DateTime.parse("2025-07-29T00:22:41"),
          modelSize: 11377936,
        ),
        symptomsDetected: [
          "Bercak Darah",
          "Lendir Berwarna Putih",
          "Konsistensi Encer",
        ],
        recommendations: [
          "Segera isolasi ayam yang terinfeksi",
          "Hubungi dokter jika gejala memburuk",
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Diagnosis Ulang Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<DiagnoseResultCubit>().postDiagnoseImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AssetColors.primaryMain,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Diagnosis Ulang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Konsultasi Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Handle konsultasi
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AssetColors.primary30,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Konsultasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Widget content;

  const _Header({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.ds,
        right: 16.ds,
      ),
      decoration: BoxDecoration(
        color: AssetColors.primaryMain,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.ds),
          bottomRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkPressableBase(
                child: BackIconWidget(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Hasil Diagnosis",
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
          SizedBox(height: 24.ds),
          content,
          SizedBox(height: 24.ds),
        ],
      ),
    );
  }
}

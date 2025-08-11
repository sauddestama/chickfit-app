import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/diagnose_repository.dart';
import 'package:chickfit/data/source/network/responses/diagnose_result_response.dart';
import 'package:chickfit/locator.dart';
import 'package:equatable/equatable.dart';

class DiagnoseResultCubit extends Cubit<DiagnoseResultState> {
  DiagnoseResultCubit() : super(const DiagnoseResultState());

  void setSelectedImage(File? image) {
    emit(state.copyWith(selectedImage: image));
  }

  void setDiangoseResult(
    DiagnoseResultResponse? diagnoseResult,
    int? id,
  ) {
    if (diagnoseResult != null) {
      emit(state.copyWith(
        diagnosisResult: diagnoseResult,
      ));
      return;
    }
    if (id != null) {
      getDiagnoseResult(id);
    }
  }

  Future<void> postDiagnoseImage() async {
    if (state.selectedImage == null) {
      emit(state.copyWith(errorMessage: 'Please select an image first'));
      return;
    }

    emit(state.copyWith(status: DiagnoseResultStatus.loading));

    try {
      final diagnoseRepository = locator.get<DiagnoseRepository>();

      File file = File(state.selectedImage!.path);

      if (!await file.exists()) {
        emit(state.copyWith(
          status: DiagnoseResultStatus.error,
          errorMessage: "Error aja",
        ));
        return;
      }
      LogUtil.info("TES aja ${state.selectedImage}");
      final result =
          await diagnoseRepository.postDiagnoseImage(state.selectedImage!);

      if (result.data != null) {
        emit(state.copyWith(
          status: DiagnoseResultStatus.success,
          diagnosisResult: result.data,
        ));
      } else {
        emit(state.copyWith(
          status: DiagnoseResultStatus.error,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to diagnose image',
        ));
      }
    } catch (e) {
      LogUtil.error("Error submitting diagnose: $e");
      emit(state.copyWith(
        status: DiagnoseResultStatus.error,
        errorMessage: 'An error occurred while processing the image',
      ));
    }
  }

  Future<void> getDiagnoseResult(int id) async {
    emit(state.copyWith(status: DiagnoseResultStatus.loading));

    try {
      final diagnoseRepository = locator.get<DiagnoseRepository>();

      final result = await diagnoseRepository.getDiagnoseDetail(id);

      if (result.data != null) {
        emit(state.copyWith(
          status: DiagnoseResultStatus.success,
          diagnosisResult: result.data,
        ));
      } else {
        emit(state.copyWith(
          status: DiagnoseResultStatus.error,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to diagnose image',
        ));
      }
    } catch (e) {
      LogUtil.error("Error submitting diagnose: $e");
      emit(state.copyWith(
        status: DiagnoseResultStatus.error,
        errorMessage: 'An error occurred while processing the image',
      ));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: DiagnoseResultStatus.initial));
  }
}

enum DiagnoseResultStatus { initial, loading, success, error }

class DiagnoseResultState extends Equatable {
  final File? selectedImage;
  final String? errorMessage;
  final DiagnoseResultStatus status;
  final DiagnoseResultResponse? diagnosisResult;

  const DiagnoseResultState({
    this.selectedImage,
    this.errorMessage,
    this.status = DiagnoseResultStatus.initial,
    this.diagnosisResult,
  });

  DiagnoseResultState copyWith({
    File? selectedImage,
    String? errorMessage,
    DiagnoseResultStatus? status,
    DiagnoseResultResponse? diagnosisResult,
  }) {
    return DiagnoseResultState(
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      diagnosisResult: diagnosisResult ?? this.diagnosisResult,
    );
  }

  @override
  List<Object?> get props => [
        selectedImage,
        errorMessage,
        status,
        diagnosisResult,
      ];

  DiagnoseResultState copyWithNullImage() {
    return DiagnoseResultState(
      selectedImage: null,
      status: DiagnoseResultStatus.initial,
      diagnosisResult: diagnosisResult,
    );
  }
}

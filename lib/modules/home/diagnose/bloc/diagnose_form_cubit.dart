import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/data/repositories/diagnose_repository.dart';
import 'package:chickfit/data/source/network/responses/diagnose_result_response.dart';
import 'package:chickfit/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class DiagnoseFormCubit extends Cubit<DiagnoseFormState> {
  DiagnoseFormCubit() : super(const DiagnoseFormState());

  void setSelectedImage(File? image) {
    emit(state.copyWith(selectedImage: image));
  }

  void clearSelectedImage() {
    emit(state.copyWithNullImage());
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        setSelectedImage(File(image.path));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to capture image: $e'));
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setSelectedImage(File(image.path));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to pick image: $e'));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> postDiagnoseImage() async {
    if (state.selectedImage == null) {
      emit(state.copyWith(errorMessage: 'Please select an image first'));
      return;
    }

    emit(state.copyWith(status: DiagnoseFormStatus.loading));

    try {
      final diagnoseRepository = locator.get<DiagnoseRepository>();

      File file = File(state.selectedImage!.path);

      if (!await file.exists()) {
        emit(state.copyWith(
          status: DiagnoseFormStatus.error,
          errorMessage: "Error aja",
        ));
        return;
      }
      LogUtil.info("TES aja ${state.selectedImage}");
      final result =
          await diagnoseRepository.postDiagnoseImage(state.selectedImage!);

      if (result.data != null) {
        emit(state.copyWith(
          status: DiagnoseFormStatus.success,
          diagnosisResult: result.data,
        ));
        // Clear the image after successful submission
        clearSelectedImage();
      } else {
        emit(state.copyWith(
          status: DiagnoseFormStatus.error,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to diagnose image',
        ));
      }
    } catch (e) {
      LogUtil.error("Error submitting diagnose: $e");
      emit(state.copyWith(
        status: DiagnoseFormStatus.error,
        errorMessage: 'An error occurred while processing the image',
      ));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: DiagnoseFormStatus.initial));
  }
}

enum DiagnoseFormStatus { initial, loading, success, error }

class DiagnoseFormState extends Equatable {
  final File? selectedImage;
  final String? errorMessage;
  final DiagnoseFormStatus status;
  final DiagnoseResultResponse? diagnosisResult;

  const DiagnoseFormState({
    this.selectedImage,
    this.errorMessage,
    this.status = DiagnoseFormStatus.initial,
    this.diagnosisResult,
  });

  DiagnoseFormState copyWith({
    File? selectedImage,
    String? errorMessage,
    DiagnoseFormStatus? status,
    DiagnoseResultResponse? diagnosisResult,
  }) {
    return DiagnoseFormState(
      selectedImage: selectedImage ?? this.selectedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      diagnosisResult: diagnosisResult ?? this.diagnosisResult,
    );
  }

  @override
  List<Object?> get props =>
      [selectedImage, errorMessage, status, diagnosisResult];

  DiagnoseFormState copyWithNullImage() {
    return DiagnoseFormState(
      selectedImage: null,
      status: DiagnoseFormStatus.initial,
      diagnosisResult: diagnosisResult,
    );
  }
}

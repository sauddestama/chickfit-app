import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/diagnose_repository.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/source/network/responses/get_diagnose_histories_response.dart';
import 'package:equatable/equatable.dart';

class DiagnoseHistoriesCubit extends Cubit<DiagnoseHistoriesState> {
  final DiagnoseRepository _dataRepository;
  final ConsultationRepository _consultationRepository;

  DiagnoseHistoriesCubit({
    required DiagnoseRepository dataRepository,
    required ConsultationRepository consultationRepository,
  })  : _dataRepository = dataRepository,
        _consultationRepository = consultationRepository,
        super(const DiagnoseHistoriesState(
          diagnoseHistoriesDataStatus: DataStatus.initial,
        ));

  Future<void> fetchDiagnoseHistories({required String userId}) async {
    emit(state.copyWith(
      diagnoseHistoriesDataStatus: DataStatus.loading,
    ));

    final result = await _dataRepository.getDiagnoseHistories(userId: userId);

    if (result.data == null) {
      emit(state.copyWith(diagnoseHistoriesDataStatus: DataStatus.failure));
      return;
    }

    emit(state.copyWith(
      diagnoseHistoriesDataStatus: DataStatus.success,
      diagnoseHistories: result.data as List<DiagnoseHistoryItem>,
    ));
  }

  Future<bool> requestPrescription(int diagnosisId) async {
    emit(state.copyWith(
      prescriptionRequestStatus: DataStatus.loading,
    ));

    try {
      final result = await _consultationRepository.requestPrescription(diagnosisId);
      
      if (result.data == true) {
        emit(state.copyWith(
          prescriptionRequestStatus: DataStatus.success,
          prescriptionRequestMessage: 'Resep berhasil diminta',
        ));
        return true;
      } else {
        emit(state.copyWith(
          prescriptionRequestStatus: DataStatus.failure,
          prescriptionRequestMessage: result.getException?.getErrorMessage() ?? 'Gagal meminta resep',
        ));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        prescriptionRequestStatus: DataStatus.failure,
        prescriptionRequestMessage: 'Terjadi kesalahan: $e',
      ));
      return false;
    }
  }

  void resetPrescriptionRequestStatus() {
    emit(state.copyWith(
      prescriptionRequestStatus: DataStatus.initial,
      prescriptionRequestMessage: null,
    ));
  }
}

class DiagnoseHistoriesState extends Equatable {
  final DataStatus diagnoseHistoriesDataStatus;
  final DataStatus prescriptionRequestStatus;
  final String? message;
  final String? errorMessage;
  final String? prescriptionRequestMessage;
  final List<DiagnoseHistoryItem>? diagnoseHistories;

  const DiagnoseHistoriesState({
    this.message,
    this.errorMessage,
    this.prescriptionRequestMessage,
    required this.diagnoseHistoriesDataStatus,
    this.prescriptionRequestStatus = DataStatus.initial,
    this.diagnoseHistories,
  });

  DiagnoseHistoriesState copyWith({
    String? message,
    String? errorMessage,
    String? prescriptionRequestMessage,
    DataStatus? diagnoseHistoriesDataStatus,
    DataStatus? prescriptionRequestStatus,
    List<DiagnoseHistoryItem>? diagnoseHistories,
  }) {
    return DiagnoseHistoriesState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      prescriptionRequestMessage: prescriptionRequestMessage ?? this.prescriptionRequestMessage,
      diagnoseHistoriesDataStatus:
          diagnoseHistoriesDataStatus ?? this.diagnoseHistoriesDataStatus,
      prescriptionRequestStatus: prescriptionRequestStatus ?? this.prescriptionRequestStatus,
      diagnoseHistories: diagnoseHistories ?? this.diagnoseHistories,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        prescriptionRequestMessage,
        diagnoseHistoriesDataStatus,
        prescriptionRequestStatus,
        diagnoseHistories,
      ];
}

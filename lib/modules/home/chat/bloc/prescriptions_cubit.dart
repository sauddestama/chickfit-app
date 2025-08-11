import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/source/network/responses/get_resep_response.dart';
import 'package:equatable/equatable.dart';

class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  final ConsultationRepository _dataRepository;

  PrescriptionsCubit({required ConsultationRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const PrescriptionsState(
          dataStatus: DataStatus.initial,
        ));

  Future<void> fetchPrescriptions(String userId) async {
    emit(state.copyWith(
      dataStatus: DataStatus.loading,
    ));

    final result = await _dataRepository.getPrescription(userId);

    if (result.data == null) {
      emit(state.copyWith(dataStatus: DataStatus.failure));
      return;
    }

    emit(state.copyWith(
      dataStatus: DataStatus.success,
      prescriptions: result.data,
    ));
  }
}

class PrescriptionsState extends Equatable {
  final DataStatus dataStatus;
  final String? message;
  final String? errorMessage;
  final List<PrescriptionItemResponse>? prescriptions;

  const PrescriptionsState({
    this.message,
    this.errorMessage,
    required this.dataStatus,
    this.prescriptions,
  });

  PrescriptionsState copyWith({
    String? message,
    String? errorMessage,
    DataStatus? dataStatus,
    List<PrescriptionItemResponse>? prescriptions,
  }) {
    return PrescriptionsState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      dataStatus: dataStatus ?? this.dataStatus,
      prescriptions: prescriptions ?? this.prescriptions,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        dataStatus,
        prescriptions,
      ];
}

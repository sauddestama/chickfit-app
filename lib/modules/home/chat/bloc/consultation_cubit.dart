import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/source/network/responses/get_consultations_response.dart';
import 'package:equatable/equatable.dart';

class ConsultationsCubit extends Cubit<ConsultationsState> {
  final ConsultationRepository _dataRepository;

  ConsultationsCubit({required ConsultationRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const ConsultationsState(
          consultationsDataStatus: DataStatus.initial,
        ));

  Future<void> fetchConsultations() async {
    emit(state.copyWith(
      consultationsDataStatus: DataStatus.loading,
    ));

    final result = await _dataRepository.getConsultations();

    if (result.data == null) {
      emit(state.copyWith(consultationsDataStatus: DataStatus.failure));
      return;
    }

    emit(state.copyWith(
      consultationsDataStatus: DataStatus.success,
      consultations: result.data as List<ConsultationItemResponse>,
    ));
  }
}

class ConsultationsState extends Equatable {
  final DataStatus consultationsDataStatus;
  final String? message;
  final String? errorMessage;
  final List<ConsultationItemResponse>? consultations;

  const ConsultationsState({
    this.message,
    this.errorMessage,
    required this.consultationsDataStatus,
    this.consultations,
  });

  ConsultationsState copyWith({
    String? message,
    String? errorMessage,
    DataStatus? consultationsDataStatus,
    List<ConsultationItemResponse>? consultations,
  }) {
    return ConsultationsState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      consultationsDataStatus:
          consultationsDataStatus ?? this.consultationsDataStatus,
      consultations: consultations ?? this.consultations,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        consultationsDataStatus,
        consultations,
      ];
}

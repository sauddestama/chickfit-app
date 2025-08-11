import 'package:bloc/bloc.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:equatable/equatable.dart';

class StartConsultationCubit extends Cubit<StartConsultationState> {
  final ConsultationRepository _consultationRepository;

  StartConsultationCubit({
    required ConsultationRepository consultationRepository,
  })  : _consultationRepository = consultationRepository,
        super(const StartConsultationState());

  Future<void> startConsultation(int veterinarianId) async {
    emit(state.copyWith(status: StartConsultationStatus.loading));

    try {
      final result =
          await _consultationRepository.startConsultation(veterinarianId);

      if (result.data != null) {
        emit(state.copyWith(
          status: StartConsultationStatus.success,
          consultationId: result.data!.consultationId,
        ));
      } else {
        emit(state.copyWith(
          status: StartConsultationStatus.error,
          errorMessage:
              result.getException.toString() ?? 'Gagal memulai konsultasi',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: StartConsultationStatus.error,
        errorMessage: 'Terjadi kesalahan: $e',
      ));
    }
  }

  void reset() {
    emit(const StartConsultationState());
  }
}

enum StartConsultationStatus { initial, loading, success, error }

class StartConsultationState extends Equatable {
  final StartConsultationStatus status;
  final int? consultationId;
  final String? errorMessage;

  const StartConsultationState({
    this.status = StartConsultationStatus.initial,
    this.consultationId,
    this.errorMessage,
  });

  StartConsultationState copyWith({
    StartConsultationStatus? status,
    int? consultationId,
    String? errorMessage,
  }) {
    return StartConsultationState(
      status: status ?? this.status,
      consultationId: consultationId ?? this.consultationId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, consultationId, errorMessage];
}

import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/source/network/responses/reset_detail_response.dart';
import 'package:equatable/equatable.dart';

enum ResepDetailStatus { initial, loading, success, error }

class ResepDetailState extends Equatable {
  final DataStatus resepDetailDataStatus;
  final ResepDetailStatus status;
  final PrescriptionData? prescription;
  final String? errorMessage;

  const ResepDetailState({
    this.resepDetailDataStatus = DataStatus.initial,
    this.status = ResepDetailStatus.initial,
    this.prescription,
    this.errorMessage,
  });

  ResepDetailState copyWith({
    DataStatus? resepDetailDataStatus,
    ResepDetailStatus? status,
    PrescriptionData? prescription,
    String? errorMessage,
  }) {
    return ResepDetailState(
      resepDetailDataStatus: resepDetailDataStatus ?? this.resepDetailDataStatus,
      status: status ?? this.status,
      prescription: prescription ?? this.prescription,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        resepDetailDataStatus,
        status,
        prescription,
        errorMessage,
      ];
}

class ResepDetailCubit extends Cubit<ResepDetailState> {
  final ConsultationRepository _consultationRepository;

  ResepDetailCubit({required ConsultationRepository consultationRepository})
      : _consultationRepository = consultationRepository,
        super(const ResepDetailState());

  Future<void> fetchResepDetail(int resepId) async {
    emit(state.copyWith(
      resepDetailDataStatus: DataStatus.loading,
      status: ResepDetailStatus.loading,
    ));

    try {
      final result = await _consultationRepository.getResepDetail(resepId);

      if (result.isSuccess && result.data != null) {
        emit(state.copyWith(
          resepDetailDataStatus: DataStatus.success,
          status: ResepDetailStatus.success,
          prescription: result.data!.prescription,
        ));
      } else {
        emit(state.copyWith(
          resepDetailDataStatus: DataStatus.failure,
          status: ResepDetailStatus.error,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to load prescription detail',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        resepDetailDataStatus: DataStatus.failure,
        status: ResepDetailStatus.error,
        errorMessage: 'An error occurred while loading prescription detail',
      ));
    }
  }

  void reset() {
    emit(const ResepDetailState());
  }
}

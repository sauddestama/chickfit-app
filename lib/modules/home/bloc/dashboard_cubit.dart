import 'package:bloc/bloc.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/data/repositories/data_repository.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:chickfit/data/source/network/responses/veterinarian_item_response.dart';
import 'package:equatable/equatable.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DataRepository _dataRepository;

  DashboardCubit({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(const DashboardState(
          dashboardDataStatus: DataStatus.initial,
        ));

  Future<void> fetchDashboardData() async {
    emit(state.copyWith(
      dashboardDataStatus: DataStatus.loading,
    ));
    final results = await Future.wait([
      _dataRepository.getVeterinarians(),
      _dataRepository.getPublishedArticle(),
    ]);
    if (results.indexWhere((result) => result.data == null) != -1) {
      emit(state.copyWith(dashboardDataStatus: DataStatus.failure));
      return;
    }
    emit(state.copyWith(
      dashboardDataStatus: DataStatus.success,
      veterinarians: results[0].data as List<VeterinarianItemResponse>,
      articles: results[1].data as List<ArticleItemResponse>,
    ));
  }
}

enum DashboardStatus { initial, loading, success, failed }

class DashboardState extends Equatable {
  final DataStatus dashboardDataStatus;
  final String? message;
  final String? errorMessage;
  final List<VeterinarianItemResponse>? veterinarians;
  final List<ArticleItemResponse>? articles;

  const DashboardState({
    this.message,
    this.errorMessage,
    required this.dashboardDataStatus,
    this.veterinarians,
    this.articles,
  });

  DashboardState copyWith({
    String? message,
    String? errorMessage,
    DataStatus? dashboardDataStatus,
    List<VeterinarianItemResponse>? veterinarians,
    List<ArticleItemResponse>? articles,
  }) {
    return DashboardState(
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      dashboardDataStatus: dashboardDataStatus ?? this.dashboardDataStatus,
      veterinarians: veterinarians ?? this.veterinarians,
      articles: articles ?? this.articles,
    );
  }

  @override
  List<Object?> get props => [
        message,
        errorMessage,
        dashboardDataStatus,
        veterinarians,
        articles,
      ];
}

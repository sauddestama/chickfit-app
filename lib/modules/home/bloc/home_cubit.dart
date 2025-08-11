import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(const HomeState(
          homePageActiveIndex: 0,
          homeStatus: HomeStatus.initial,
        ));

  void setActiveHomePageIndex(int index) {
    emit(state.copyWith(homePageActiveIndex: index));
  }

  void initData({int? initialPageIndex}) async {
    emit(state.copyWith(homePageActiveIndex: initialPageIndex));
  }
}

enum HomeStatus { initial, loading, success, failed }

class HomeState extends Equatable {
  final int homePageActiveIndex;

  final HomeStatus homeStatus;

  final String? message;

  final String? errorMessage;

  const HomeState(
      {required this.homePageActiveIndex,
      required this.homeStatus,
      this.message,
      this.errorMessage});

  HomeState copyWith({
    int? homePageActiveIndex,
    HomeStatus? homeStatus,
    String? message,
    String? errorMessage,
  }) {
    return HomeState(
      homePageActiveIndex: homePageActiveIndex ?? this.homePageActiveIndex,
      homeStatus: homeStatus ?? this.homeStatus,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        homePageActiveIndex,
        homeStatus,
        message,
        errorMessage,
      ];
}

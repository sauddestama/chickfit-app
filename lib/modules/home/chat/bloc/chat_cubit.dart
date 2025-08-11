import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit()
      : super(const ChatState(
          activeIndex: 0,
          homeStatus: ChatStatus.initial,
        ));

  void setActiveChatPageIndex(int index) {
    emit(state.copyWith(activeIndex: index));
  }

  void initData({int? initialPageIndex}) async {
    emit(state.copyWith(activeIndex: initialPageIndex));
  }
}

enum ChatStatus { initial, loading, success, failed }

class ChatState extends Equatable {
  final int activeIndex;

  final ChatStatus homeStatus;

  final String? message;

  final String? errorMessage;

  const ChatState(
      {required this.activeIndex,
      required this.homeStatus,
      this.message,
      this.errorMessage});

  ChatState copyWith({
    int? activeIndex,
    ChatStatus? homeStatus,
    String? message,
    String? errorMessage,
  }) {
    return ChatState(
      activeIndex: activeIndex ?? this.activeIndex,
      homeStatus: homeStatus ?? this.homeStatus,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeIndex,
        homeStatus,
        message,
        errorMessage,
      ];
}

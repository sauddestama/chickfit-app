import 'package:bloc/bloc.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/source/network/responses/get_consul_messages_response.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/consultation/consultation_chat_page_args.dart';
import 'package:equatable/equatable.dart';

class ConsultationChatCubit extends Cubit<ConsultationChatState> {
  final ConsultationChatPageArgs pageArgs;
  final ConsultationRepository _consultationRepository =
      locator<ConsultationRepository>();

  ConsultationChatCubit({
    required this.pageArgs,
  }) : super(const ConsultationChatState()) {
    _loadMessageHistory();
  }

  Future<void> _loadMessageHistory() async {
    emit(state.copyWith(status: ConsultationChatStatus.loading));

    try {
      final consultationId = int.tryParse(pageArgs.consultationId) ?? 0;
      final result =
          await _consultationRepository.getConsulMessage(consultationId);

      if (result.isSuccess) {
        final messages = result.data ?? [];
        emit(state.copyWith(
          status: ConsultationChatStatus.success,
          messages: messages,
          isSending: false,
        ));
      } else {
        emit(state.copyWith(
          status: ConsultationChatStatus.error,
          isSending: false,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to load messages',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConsultationChatStatus.error,
        errorMessage: 'An error occurred while loading messages',
      ));
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add message to local state immediately for optimistic UI
    final consultationId = int.tryParse(pageArgs.consultationId) ?? 0;
    final newMessage = ConsulMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      message: message,
      senderId: 1,
      sentAt: DateTime.now(),
      senderName: 'You',
      senderAvatar: null,
      senderRole: 'farmer',
    );

    final currentMessages = List<ConsulMessage>.from(state.messages);
    currentMessages.add(newMessage);

    emit(state.copyWith(
      isSending: true,
    ));

    try {
      final result = await _consultationRepository.postConsulMessage(
        consultationId,
        message,
      );

      if (result.isSuccess) {
        // Message sent successfully, refresh the message list
        await _loadMessageHistory();
      } else {
        // Remove the optimistic message and show error
        final updatedMessages = List<ConsulMessage>.from(state.messages);
        updatedMessages.removeWhere((msg) => msg.id == newMessage.id);

        emit(state.copyWith(
          messages: updatedMessages,
          isSending: false,
          errorMessage: result.getException?.getErrorMessage() ??
              'Failed to send message',
        ));
      }
    } catch (e) {
      // Remove the optimistic message and show error
      final updatedMessages = List<ConsulMessage>.from(state.messages);
      updatedMessages.removeWhere((msg) => msg.id == newMessage.id);

      emit(state.copyWith(
        messages: updatedMessages,
        isSending: false,
        errorMessage: 'An error occurred while sending message',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void refreshMessages() {
    _loadMessageHistory();
  }
}

enum ConsultationChatStatus { initial, loading, success, error }

class ConsultationChatState extends Equatable {
  final String? errorMessage;
  final ConsultationChatStatus status;
  final List<ConsulMessage> messages;
  final bool isSending;
  final int userId;

  const ConsultationChatState({
    this.errorMessage,
    this.status = ConsultationChatStatus.initial,
    this.messages = const [],
    this.isSending = false,
    this.userId = 0,
  });

  ConsultationChatState copyWith({
    String? errorMessage,
    ConsultationChatStatus? status,
    List<ConsulMessage>? messages,
    bool? isSending,
    int? userId,
  }) {
    return ConsultationChatState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        messages,
        isSending,
        userId,
      ];
}

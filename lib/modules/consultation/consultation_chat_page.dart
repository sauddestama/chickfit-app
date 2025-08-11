import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/data/source/network/responses/get_consul_messages_response.dart';
import 'package:chickfit/modules/consultation/bloc/consultation_chat_cubit.dart';
import 'package:chickfit/modules/consultation/consultation_chat_page_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConsultationChatPage extends StatefulWidget {
  const ConsultationChatPage({super.key});

  static route(settings) {
    final args = settings.arguments as ConsultationChatPageArgs;
    return MyPageRoute(
        BlocProvider(
          create: (context) => ConsultationChatCubit(pageArgs: args),
          child: ConsultationChatPage(),
        ),
        settings);
  }

  @override
  _ConsultationChatPageState createState() => _ConsultationChatPageState();
}

class _ConsultationChatPageState extends State<ConsultationChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Chat with ${context.read<ConsultationChatCubit>().pageArgs.doctorName}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AssetColors.primaryMain,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () =>
                context.read<ConsultationChatCubit>().refreshMessages(),
          ),
        ],
      ),
      body: BlocConsumer<ConsultationChatCubit, ConsultationChatState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<ConsultationChatCubit>().clearError();
          }

          // Scroll to bottom when new messages arrive
          if (state.messages.isNotEmpty) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AssetColors.primaryMain.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: AssetColors.primaryMain,
                        size: 30,
                      ),
                    ),
                    Gap.width(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context
                                .read<ConsultationChatCubit>()
                                .pageArgs
                                .doctorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Gap.height(4),
                          Text(
                            context
                                .read<ConsultationChatCubit>()
                                .pageArgs
                                .doctorSpecialist,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Chat Section
              Expanded(
                child: state.status == ConsultationChatStatus.loading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AssetColors.primaryMain),
                            ),
                            Gap.height(16),
                            Text(
                              'Loading messages...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : state.messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                Gap.height(16),
                                Text(
                                  'No messages yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap.height(8),
                                Text(
                                  'Start the conversation!',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              final isCurrentUser =
                                  message.senderRole == 'farmer';

                              return _buildMessageBubble(
                                  message, isCurrentUser);
                            },
                          ),
              ),

              // Input Chat Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            border: InputBorder.none,
                            suffixIcon: state.isSending
                                ? Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AssetColors.primaryMain),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (text) => _sendMessage(),
                        ),
                      ),
                    ),
                    Gap.width(12),
                    Container(
                      decoration: BoxDecoration(
                        color: AssetColors.primaryMain,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: state.isSending ? null : _sendMessage,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ConsulMessage message, bool isCurrentUser) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: isCurrentUser ? 60 : 0,
        right: isCurrentUser ? 0 : 60,
      ),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            Padding(
              padding: EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.senderName ?? 'Unknown',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isCurrentUser ? AssetColors.primaryMain : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(isCurrentUser ? 18 : 4),
                bottomRight: Radius.circular(isCurrentUser ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.message ?? '',
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
          Gap.height(4),
          Padding(
            padding: EdgeInsets.only(
              left: isCurrentUser ? 0 : 12,
              right: isCurrentUser ? 12 : 0,
            ),
            child: Text(
              _formatTime(message.sentAt),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(dateTime);
    }
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      context.read<ConsultationChatCubit>().sendMessage(message);
      _controller.clear();
    }
  }
}

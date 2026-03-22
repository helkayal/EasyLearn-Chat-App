import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../generated/locale_keys.g.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../model/chat_model.dart';
import '../cubit/chat_info_cubit.dart';
import '../cubit/chat_info_state.dart';
import '../cubit/messages_cubit.dart';
import '../cubit/messages_state.dart';
import '../widgets/add_participants_sheet.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_messages_list.dart';
import '../widgets/group_avatar_widget.dart';
import '../widgets/group_members_sheet.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String fallbackTitle;
  final String? fallbackImageUrl;

  const ChatView({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.fallbackTitle,
    this.fallbackImageUrl,
  });

  @override
  State<ChatView> createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAvatar(ChatModel? chat) {
    if (chat == null) {
      return CustomAvatar(
        imageUrl: widget.fallbackImageUrl ?? '',
        name: widget.fallbackTitle,
        radius: 18,
      );
    }

    if (chat.isGroup) {
      if (chat.groupImage != null && chat.groupImage!.isNotEmpty) {
        return CustomAvatar(
          imageUrl: chat.groupImage!,
          name: chat.groupName ?? LocaleKeys.chat_group.tr(),
          radius: 18,
        );
      }
      return GroupAvatarWidget(participantIds: chat.participantIds, radius: 18);
    }

    return CustomAvatar(
      imageUrl: widget.fallbackImageUrl ?? '',
      name: widget.fallbackTitle,
      radius: 18,
    );
  }

  String _buildTitle(ChatModel? chat) {
    if (chat == null) return widget.fallbackTitle;
    if (chat.isGroup) {
      final count = chat.participantIds.length;
      final name = chat.groupName ?? LocaleKeys.chat_group.tr();
      return LocaleKeys.chat_group_members.tr(args: [name, '$count']);
    }
    return widget.fallbackTitle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ChatInfoCubit, ChatInfoState>(
      builder: (context, chatInfoState) {
        final chat = chatInfoState is ChatInfoLoaded
            ? chatInfoState.chat
            : null;

        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                if (chat != null && chat.isGroup) {
                  GroupMembersSheet.show(
                    context,
                    participantIds: chat.participantIds,
                  );
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  _buildAvatar(chat),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _buildTitle(chat),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (chat != null)
                IconButton(
                  icon: Icon(
                    chat.favoritedByUserIds.contains(widget.currentUserId)
                        ? Icons.star
                        : Icons.star_border,
                    color:
                        chat.favoritedByUserIds.contains(widget.currentUserId)
                        ? theme.colorScheme.surface
                        : theme.colorScheme.onTertiary,
                  ),
                  tooltip: LocaleKeys.chat_favorite_chat.tr(),
                  onPressed: () {
                    context.read<ChatInfoCubit>().toggleFavorite(
                      chatId: widget.chatId,
                      currentUserId: widget.currentUserId,
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.person_add_alt_1),
                tooltip: LocaleKeys.chat_add_participants.tr(),
                onPressed: () => _openAddParticipants(context, chat),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    if (state is MessagesLoading || state is MessagesInitial) {
                      return const CustomLoadingIndicator();
                    }
                    if (state is MessagesError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(state.message),
                        ),
                      );
                    }
                    if (state is MessagesLoaded) {
                      final messages = state.messages;
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            LocaleKeys.chat_no_messages_yet.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ChatMessagesList(
                        state: state,
                        chat: chat,
                        currentUserId: widget.currentUserId,
                        scrollController: _scrollController,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              ChatInput(
                controller: _controller,
                chatId: widget.chatId,
                currentUserId: widget.currentUserId,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAddParticipants(
    BuildContext context,
    ChatModel? chat,
  ) async {
    final participantIds = chat?.participantIds ?? [widget.currentUserId];
    final isGroup = chat?.isGroup ?? false;

    final added = await AddParticipantsSheet.show(
      context,
      chatId: widget.chatId,
      currentParticipantIds: participantIds,
      isGroup: isGroup,
    );

    if (added == true && context.mounted) {
      SnackbarHelper.show(
        context,
        isGroup
            ? LocaleKeys.chat_participants_added.tr()
            : LocaleKeys.chat_group_created_successfully.tr(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/agent_avatar.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../domain/models/legal_agent.dart';
import '../../../routes/app_routes.dart';
import 'chat_controller.dart';

/// Text consultation with an AI agent.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ChatController controller;

  LegalAgent get _agent => Get.arguments as LegalAgent;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController());
  }

  @override
  void dispose() {
    Get.delete<ChatController>();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final LegalAgent agent = _agent;

    return Scaffold(
      appBar: _ChatAppBar(agent: agent),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppDimensions.md),
                itemCount:
                    controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i >= controller.messages.length) {
                    return const _TypingBubble();
                  }
                  final ChatMessage message = controller.messages[i];
                  return _MessageBubble(
                    key: ValueKey('msg-$i'),
                    message: message,
                    agent: agent,
                  );
                },
              ),
            ),
          ),
          _QuickSuggestions(controller: controller),
          _InputBar(
            controller: controller,
            agent: agent,
            onSend: _scrollToBottom,
          ),
        ],
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.agent});

  final LegalAgent agent;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AppBar(
      leadingWidth: 68,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Center(
          child: AgentAvatar(
            agent: agent,
            size: 42,
            showRing: false,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(agent.name, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Row(
            children: [
              const _OnlineDot(),
              const SizedBox(width: 6),
              Text(
                '${AppStrings.online} · ${AppStrings.aiAgent}',
                style: TextStyle(color: c.textSubtle, fontSize: 11.5),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(AppRoutes.videoCall, arguments: agent),
          icon: const Icon(Icons.videocam_rounded),
          tooltip: AppStrings.videoConsult,
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _OnlineDot extends StatefulWidget {
  const _OnlineDot();

  @override
  State<_OnlineDot> createState() => _OnlineDotState();
}

class _OnlineDotState extends State<_OnlineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({super.key, required this.message, required this.agent});

  final ChatMessage message;
  final LegalAgent agent;

  @override
  Widget build(BuildContext context) {
    final bool isAgent = message.isAgent;
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final Widget bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.74,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isAgent
            ? null
            : const LinearGradient(
                colors: [AppColors.slate, AppColors.navy],
              ),
        color: isAgent ? c.surfaceAlt : null,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isAgent ? 6 : 20),
          bottomRight: Radius.circular(isAgent ? 20 : 6),
        ),
        border: isAgent ? Border.all(color: c.divider) : null,
      ),
      child: Text(
        message.text,
        style: TextStyle(
          fontSize: 14.5,
          height: 1.45,
          color: isAgent ? c.text : Colors.white,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isAgent
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAgent) ...[
            AgentAvatar(
              agent: agent,
              size: 30,
              showRing: false,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(child: bubble),
        ],
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.surfaceAlt,
              border: Border.all(color: c.divider),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(color: c.divider),
            ),
            child: const _BouncingDots(),
          ),
        ],
      ),
    );
  }
}

class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final double phase = (_controller.value - i * 0.15).clamp(0.0, 1.0);
            final double scale = 0.55 + 0.45 * (1 - (phase * 2 - 1).abs());
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              transform: Matrix4.diagonal3Values(scale, scale, 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.textSubtle,
              ),
            );
          }),
        );
      },
    );
  }
}

class _QuickSuggestions extends StatelessWidget {
  const _QuickSuggestions({required this.controller});

  final ChatController controller;

  static const List<String> _suggestions = [
    'Do I need a contract for this?',
    'What are my rights here?',
    'Explain my options simply',
    'What documents do I need?',
  ];

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Obx(() {
      if (controller.messages.length > 1 || controller.isTyping.value) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          itemCount: _suggestions.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final String s = _suggestions[i];
            return GestureDetector(
              onTap: () {
                controller.input.text = s;
                controller.sendMessage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: c.divider),
                  color: c.surface,
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: c.text,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.agent,
    required this.onSend,
  });

  final ChatController controller;
  final LegalAgent agent;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final AppPalette c = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.md,
        10,
        AppDimensions.md,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: c.background,
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.input,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                controller.sendMessage();
                onSend();
              },
              decoration: InputDecoration(
                hintText: AppStrings.typeMessage,
                prefixIcon: IconButton(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.videoCall, arguments: agent),
                  icon: const Icon(Icons.videocam_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SendButton(controller: controller, onSend: onSend),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.controller, required this.onSend});

  final ChatController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedScale(
        scale: controller.canSend.value ? 1 : 0.92,
        duration: const Duration(milliseconds: 160),
        child: GradientButton(
          label: '',
          expand: false,
          height: 52,
          gradient: controller.canSend.value
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF4A4A55), Color(0xFF3A3A44)],
                ),
          onPressed: controller.canSend.value
              ? () {
                  controller.sendMessage();
                  onSend();
                }
              : null,
          icon: Icons.send_rounded,
        ),
      ),
    );
  }
}

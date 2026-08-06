import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../domain/models/legal_agent.dart';

/// A single message in a consultation.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isAgent,
    this.time = const Duration(minutes: 0),
  });

  final String text;
  final bool isAgent;
  final Duration time;
}

/// Simulates a text consultation with an AI agent.
///
/// Wire this to your AI backend later — the controller API stays the same:
/// [sendMessage] is the only entry point the UI calls.
class ChatController extends BaseController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool canSend = false.obs;
  final TextEditingController input = TextEditingController();

  static const int _maxMessages = 60;
  int _replyIndex = 0;

  static final List<String> _responses = [
    'Thank you for the details. Based on what you described, the first thing I would assess is whether a written agreement exists and what its governing-law clause says. Let me walk you through the options.',
    'In practice, courts in most jurisdictions weigh three factors here: the parties\' intent, past conduct, and statutory presumptions. Your situation strongly favors the second factor. I would recommend documenting everything from today onward.',
    'There is a relevant precedent from 2021 that aligns closely with your case. Would you like me to summarize the holding and how it maps onto your facts?',
    'Before drafting anything, let\'s clarify the timeline. When did the events you mentioned first occur? That determines whether any limitation period has started to run.',
    'From a risk perspective, I\'d rate this scenario moderate: the exposure is real but mitigable. My recommendation would be to negotiate a settlement agreement that includes a mutual release.',
  ];

  @override
  void onInit() {
    super.onInit();
    input.addListener(() {
      canSend.value = input.text.trim().isNotEmpty;
    });
    _seedGreeting();
  }

  void _seedGreeting() {
    final LegalAgent? agent = Get.arguments as LegalAgent?;
    messages.add(
      ChatMessage(
        isAgent: true,
        text:
            'Hello, I\'m ${agent?.name ?? 'your AI agent'}. I\'m here to help with any legal question — in plain language. How can I assist you today?',
      ),
    );
  }

  void sendMessage() {
    final String text = input.text.trim();
    if (text.isEmpty || isTyping.value) return;

    messages.add(ChatMessage(text: text, isAgent: false));
    input.clear();

    if (messages.length > _maxMessages) {
      messages.removeRange(0, messages.length - _maxMessages);
    }

    _simulateReply();
  }

  Future<void> _simulateReply() async {
    isTyping.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    isTyping.value = false;

    messages.add(
      ChatMessage(
        isAgent: true,
        text: _responses[_replyIndex % _responses.length],
      ),
    );
    _replyIndex++;
  }
}

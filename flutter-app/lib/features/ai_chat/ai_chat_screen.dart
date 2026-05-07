import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_Message>[
    _Message(
      text: 'Hello! I\'m your AI Trading Copilot. I have access to real-time market data, '
          'historical patterns, and current news. How can I help you trade smarter today?',
      isUser: false,
    ),
  ];
  bool _isTyping = false;

  final _suggested = [
    'What is BTC doing right now?',
    'Is now a good time to buy ETH?',
    'Explain the current funding rates',
    'What happened to SOL today?',
    'Show me historical patterns similar to today',
    'Is the market in a bull or bear phase?',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _isTyping = true;
    });
    _controller.clear();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_Message(
            text: _getResponse(text),
            isUser: false,
          ));
        });
      }
    });
  }

  String _getResponse(String query) {
    if (query.toLowerCase().contains('btc') || query.toLowerCase().contains('bitcoin')) {
      return 'Based on current data: BTC is trading at \$97,420 (+2.4%). '
          'The RSI sits at 67 — bullish but not overbought. '
          'Key resistance at \$98,400–\$100,000. Support at \$95,800. '
          'Funding rates are neutral at +0.023%. '
          'My AI analysis suggests a 74% bullish sentiment across all sources. '
          'The market memory engine shows 87% similarity to October 2024 pre-ATH conditions.';
    }
    if (query.toLowerCase().contains('funding')) {
      return 'Current funding rates: BTC +0.023%, ETH +0.018%, SOL -0.008%. '
          'BTC and ETH funding is mildly positive — longs are paying shorts. '
          'This is healthy and suggests organic buying, not overleveraged longs. '
          'SOL has slight negative funding, which could signal short-term bearish bias or upcoming short squeeze.';
    }
    return 'Great question! Based on current market conditions, I\'m analyzing the data. '
        'BTC is showing strong structure with neutral funding and positive ETF flows. '
        'The overall market sentiment is bullish at 72%. '
        'Would you like me to dive deeper into any specific aspect?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Row(
        children: [
          // Chat area
          Expanded(
            child: Column(
              children: [
                _ChatHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _messages.length) return const _TypingIndicator();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ChatMessage(message: _messages[i]),
                      );
                    },
                  ),
                ),
                _ChatInput(controller: _controller, onSend: _sendMessage),
              ],
            ),
          ),

          // Suggested sidebar
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: AppColors.bgSecondary,
              border: Border(left: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: _SuggestedPanel(
              prompts: _suggested,
              onTap: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _Message {
  final String text;
  final bool isUser;
  _Message({required this.text, required this.isUser});
}

class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.gradientGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.black, size: 18),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Trading Copilot', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white,
              )),
              Text('GPT-4 · RAG-powered · News-aware', style: TextStyle(
                fontSize: 10, color: AppColors.textMuted,
              )),
            ],
          ),
          const Spacer(),
          NeonBadge(label: 'Online', color: AppColors.brandGreen, icon: Icons.circle),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final _Message message;
  const _ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isUser) ...[
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.gradientGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.black, size: 15),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: message.isUser
                  ? AppColors.brandGreen.withAlpha(20)
                  : AppColors.bgCard,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(message.isUser ? 12 : 2),
                bottomRight: Radius.circular(message.isUser ? 2 : 12),
              ),
              border: Border.all(
                color: message.isUser
                    ? AppColors.brandGreen.withAlpha(30)
                    : AppColors.borderSubtle,
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 13, color: Color(0xCCFFFFFF), height: 1.6,
              ),
            ),
          ),
        ),
        if (message.isUser) const SizedBox(width: 8),
      ],
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.gradientGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.psychology_rounded, color: Colors.black, size: 15),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => Container(
                width: 6, height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withAlpha(
                    (100 + 100 * ((_c.value + i * 0.3) % 1.0)).toInt(),
                  ),
                  shape: BoxShape.circle,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                onSubmitted: onSend,
                decoration: const InputDecoration(
                  hintText: 'Ask anything about crypto markets...',
                  hintStyle: TextStyle(color: AppColors.textDisabled, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.gradientGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(
                  color: AppColors.brandGreen.withAlpha(80),
                  blurRadius: 12, offset: const Offset(0, 4),
                )],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedPanel extends StatelessWidget {
  final List<String> prompts;
  final ValueChanged<String> onTap;
  const _SuggestedPanel({required this.prompts, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Suggested Prompts', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted,
          )),
        ),
        ...prompts.map((p) => GestureDetector(
          onTap: () => onTap(p),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                Expanded(child: Text(p, style: const TextStyle(
                  fontSize: 12, color: AppColors.textMuted,
                ))),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textDisabled),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

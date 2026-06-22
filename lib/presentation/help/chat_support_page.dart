import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ChatSupportPage extends StatefulWidget {
  const ChatSupportPage({super.key});

  @override
  State<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage> {
  final _controller = TextEditingController();
  final _messages = <_Msg>[
    _Msg(text: 'Hi! I\'m Nova, your support assistant. How can I help today?',
        fromMe: false, time: '09:30'),
    _Msg(text: 'My order has not arrived yet.', fromMe: true, time: '09:31'),
    _Msg(
      text:
          'Could you share your order number? I\'ll check the tracking right away.',
      fromMe: false,
      time: '09:31',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Msg(text: text, fromMe: true, time: _now()));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_Msg(
          text:
              'Thanks for the info. Let me check that for you and I\'ll get back shortly.',
          fromMe: false,
          time: _now(),
        ));
      });
    });
  }

  String _now() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nova Support',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      )),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFF11998E)),
                      SizedBox(width: 4),
                      Text('Online',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _Bubble(msg: _messages[i]),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodyMuted,
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  const _Msg({required this.text, required this.fromMe, required this.time});
  final String text;
  final bool fromMe;
  final String time;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final align = msg.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    final bg = msg.fromMe ? AppColors.primary : Colors.white;
    final fg = msg.fromMe ? Colors.white : AppColors.textPrimary;
    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(msg.fromMe ? 14 : 4),
            bottomRight: Radius.circular(msg.fromMe ? 4 : 14),
          ),
          border: msg.fromMe ? null : Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(fontSize: 13, color: fg, height: 1.45),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 9,
                color: msg.fromMe ? Colors.white70 : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

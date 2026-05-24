import 'package:expense_app/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;
  final userid = Supabase.instance.client.auth.currentUser!.id;

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  //final _formKey = GlobalKey<FormState>();
  //final _msgController = TextEditingController();

  // Future<void> _submit(AppService appService) async {
  //   final text = _msgController.text;

  //   if (text.isEmpty) {
  //     return;
  //   }

  //   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();

  //     await appService.saveMessage(text);

  //     _msgController.text = '';
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    listenToMessages();
  }

  Future<void> fetchMessages() async {
    final data = await supabase
        .from('message')
        .select()
        .order('created_at', ascending: true);
    ;

    setState(() {
      messages = List<Map<String, dynamic>>.from(data);
    });
  }

  void listenToMessages() {
    supabase
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'message',
          callback: (payload) {
            setState(() {
              messages.add(payload.newRecord);
            });
          },
        )
        .subscribe();
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await supabase.from('message').insert({
      'content': text,
      'user_from': userid,
      'user_to': userid,
    });

    _controller.clear();
  }

  void scrollToBottom() {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'CYBER CHAT',
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/share');
            },
            icon: Icon(Icons.close),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['user_from'] == userid ? true : false;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isMe
                                ? Colors.purple.shade900.withOpacity(0.08)
                                : Colors.white.withOpacity(0.04),
                        border: Border.all(
                          color: isMe ? Colors.purple.shade900 : Colors.white54,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        msg['content'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                    scrollToBottom();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
SUPABASE TABLE STRUCTURE (VERY IMPORTANT)

Table: messages

Columns:
- id (uuid, primary key, default: uuid_generate_v4())
- content (text)
- is_me (bool)
- created_at (timestamp, default: now())

Also enable realtime on this table.
*/

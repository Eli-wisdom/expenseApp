import 'package:expense_app/data/message_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final _password = 'PfNNpwyL6infYBz';

  // Future<void> _createUser(int i) async {
  //   final response = await _supabase.auth.signUp('test_$i@test.com', _password);

  //   await _supabase
  //       .from('contact')
  //       .insert({'id': response.user!.id, 'username': 'User $i'}).execute();
  // }

  // Future<void> createUsers() async {
  //   await _createUser(1);
  //   await _createUser(2);
  // }

  // Future<void> signIn(int i) async {
  //   await _supabase.auth.signIn(email: 'test_$i@test.com', password: _password);
  // }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Future<String> _getUserTo() async {
  //   final response = await _supabase
  //       .from('contact')
  //       .select('id')
  //       .not('id', 'eq', getCurrentUserId());

  //   return response.data[0]['id'];
  // }

  Stream<List<Message>> getMessages() {
    return _supabase
        .from('message')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map(
          (maps) =>
              maps
                  .map((item) => Message.fromJson(item, getCurrentUserId()))
                  .toList(),
        );
  }

  Future<void> saveMessage(String content) async {
    //final userTo = await _getUserTo();

    final message = Message.create(
      content: content,
      userFrom: getCurrentUserId(),
    );

    await _supabase.from('message').insert(message.toMap());
  }

  Future<void> markAsRead(String messageId) async {
    await _supabase
        .from('message')
        .update({'mark_as_read': true})
        .eq('id', messageId);
  }

  bool isAuthentificated() => _supabase.auth.currentUser != null;

  String getCurrentUserId() =>
      isAuthentificated() ? _supabase.auth.currentUser!.id : '';

  String getCurrentUserEmail() =>
      isAuthentificated() ? _supabase.auth.currentUser!.email ?? '' : '';
}

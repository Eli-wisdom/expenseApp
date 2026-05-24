import "package:expense_app/data/expense_model.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart" as sql;
import "package:sqflite/sqlite_api.dart";

Future<Database> _mainDatabase() async {
  final sqlpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(sqlpath, 'expensedata.db'),
    version: 2,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS account(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)',
      );
      await db.execute(
        'CREATE TABLE IF NOT EXISTS category(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,account INTEGER,FOREIGN KEY (account) REFERENCES account(id))',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS expense(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,amount INTEGER,category INTEGER,state INTEGER,account INTEGER,datetime DATETIME DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (category) REFERENCES category(id),FOREIGN KEY (account) REFERENCES account(id))',
      );

      await db.insert('account', {'name': 'HOME ACCOUNT'});

      await db.insert('category', {'name': 'DAILY', 'account': 1});

      await db.insert('expense', {
        'title': 'INITIAL',
        'amount': 0,
        'datetime': '2026-04-03 10:45:12',
        'category': 1,
        'state': 1,
        'account': 1,
      });
    },
  );
  //debugPrint('## Database Created');
  return db;
}

class ExpenseNotifier extends StateNotifier<List<Expensemodel>> {
  ExpenseNotifier() : super(const []);

  Future<List<Expensemodel>> loadExpense() async {
    final db = await _mainDatabase();
    final db1 = await db.query('expense');
    final load_data =
        db1
            .map(
              (expense) => Expensemodel(
                id: expense['id'] as int?,
                title: expense['title'] as String? ?? '',
                amount: _parseExpenseAmount(expense['amount']),
                date: _parseExpenseDate(expense['datetime']),
                category: _parseExpenseInt(expense['category']),
                state: expense['state'] as int,
                account: _parseExpenseInt(expense['account']),
              ),
            )
            .toList();

    debugPrint('## Expense Database Loaded');

    state = load_data;
    return load_data;
  }

  Future<List<Expensemodel>> addExpenses(Expensemodel addExpense) async {
    final db = await _mainDatabase();
    await db.insert('expense', {
      'title': addExpense.title,
      'amount': addExpense.amount,
      'category': addExpense.category,
      'state': addExpense.state,
      'account': addExpense.account,
      'datetime': addExpense.date.toIso8601String(),
    });
    debugPrint('## Expense Added');
    state = [addExpense, ...state];
    loadExpense();
    return state;
  }

  Future<void> addExpensesx(Expensemodel addExpense) async {
    final db = await _mainDatabase();
    await db.insert('expense', {
      'title': addExpense.title,
      'amount': addExpense.amount,
      'category': addExpense.category,
      'state': addExpense.state,
      'account': addExpense.account,
      'datetime': addExpense.date.toIso8601String(),
    });
    debugPrint('## Expensex Added');
    loadExpense();
    state = [...state, addExpense];
  }

  Future<void> removeExpense(String id) async {
    final db = await _mainDatabase();
    db.delete('expenseitem.db', where: 'id = ?', whereArgs: [id]);
    //loadExpense();
  }
}

DateTime _parseExpenseDate(Object? raw) {
  if (raw is DateTime) {
    return raw;
  }
  if (raw is String) {
    return DateTime.tryParse(raw) ?? DateTime.now();
  }
  if (raw is int) {
    return DateTime.fromMillisecondsSinceEpoch(raw);
  }
  return DateTime.now();
}

double _parseExpenseAmount(Object? raw) {
  if (raw is num) {
    return raw.toDouble();
  }
  if (raw is String) {
    return double.tryParse(raw) ?? 0;
  }
  return 0;
}

int _parseExpenseInt(Object? raw) {
  if (raw is num) {
    return raw.toInt();
  }
  if (raw is String) {
    return int.tryParse(raw) ?? 0;
  }
  return 0;
}

//Category notifier
class CategoryNotifier extends StateNotifier<List<categoryModel>> {
  CategoryNotifier() : super([]);

  Future<List<categoryModel>> loadCategory() async {
    final db1 = await _mainDatabase();
    final db2 = await db1.query('category');
    final loadedData =
        db2
            .map(
              (category) => categoryModel(
                id: category['id'] as int,
                name: category['name'] as String,
                account: category['account'] as int,
              ),
            )
            .toList();
    debugPrint('## Category Database Loaded');
    state = loadedData;
    return state;
  }

  Future<List<categoryModel>> addCategory(categoryModel addcategory) async {
    final db1 = await _mainDatabase();
    await db1.insert('category', {
      'id': addcategory.id,
      'name': addcategory.name,
      'account': addcategory.account,
    });
    debugPrint('## Category added');
    state = [...state, addcategory];
    loadCategory();
    return state;
  }

  Future<void> addCategoryx(categoryModel addcategory) async {
    final db1 = await _mainDatabase();
    await db1.insert('category', {
      'id': addcategory.id,
      'name': addcategory.name,
      'account': addcategory.account,
    });
    debugPrint('## Categoryx added');
    state = [...state, addcategory];
    //loadCategory();
  }
}

//Account notifier
class AccountNotifier extends StateNotifier<List<AccountModel>> {
  final Ref ref;
  AccountNotifier(this.ref) : super([]);

  Future<List<AccountModel>> loadAccount() async {
    final db1 = await _mainDatabase();
    final db2 = await db1.query('account');
    final loadedData =
        db2
            .map(
              (data) => AccountModel(
                id: data['id'] as int,
                name: data['name'] as String,
              ),
            )
            .toList();
    debugPrint('## Account Database loaded');
    state = loadedData;
    return state;
  }

  Future<List<AccountModel>> addAccount(AccountModel addAccount) async {
    final db1 = await _mainDatabase();
    await db1.insert('account', {'name': addAccount.name});
    state = [...state, addAccount];
    debugPrint('## Account added: ' + addAccount.name);

    return state;
  }

  Future<void> addAccountCatExp(
    AccountModel addAccount,
    categoryModel cat,
    Expensemodel ex,
  ) async {
    final db1 = await _mainDatabase();

    await db1.insert('account', {'name': addAccount.name});
    state = [...state, addAccount];
    await loadAccount();
    // final account = await loadAccount();
    // debugPrint(
    //   '## Accountx length: ' +
    //       account[account.length].id.toString() +
    //       " " +
    //       account[account.length].name,
    // );

    await ref.read(categoryNotifierProvider.notifier).addCategoryx(cat);

    await ref.read(expenseNotifierProvider.notifier).addExpensesx(ex);
    //return state;
  }
}

//statie notifier
class StateiNotifier extends StateNotifier<List<StateModel>> {
  StateiNotifier() : super([]);

  Future<void> loadState() async {
    final db1 = await _mainDatabase();
    final db2 = await db1.query('state');
    final loadedData =
        db2
            .map(
              (statei) => StateModel(
                id: statei['id'] as int,
                stat: statei['stat'] as int,
              ),
            )
            .toList();
    debugPrint('## State Database loaded');
    state = loadedData;
  }

  Future<void> addstate(StateModel addstate) async {
    final db1 = await _mainDatabase();
    await db1.insert('state', {'id': addstate.id, 'stat': addstate.stat});
    state = [...state, addstate];
  }
}

//providers
final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, List<Expensemodel>>(
      (ref) => ExpenseNotifier(),
    );

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, List<categoryModel>>(
      (ref) => CategoryNotifier(),
    );

final accountNotifierProvider =
    StateNotifierProvider<AccountNotifier, List<AccountModel>>(
      (ref) => AccountNotifier(ref),
    );

final stateiNotifierProvider =
    StateNotifierProvider<StateiNotifier, List<StateModel>>(
      (ref) => StateiNotifier(),
    );

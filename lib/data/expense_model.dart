import 'package:expense_app/data/data_parse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Expensemodel {
  Expensemodel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    required this.state,
    required this.account,
  });

  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final int? category;
  final int account;
  final int state;

  String get formattedDate {
    return formatter.format(date);
  }

  String get formattedInEx {
    if (state == true) {
      return "income";
    } else {
      return "expense";
    }
  }
}

class categoryModel {
  categoryModel({this.id, required this.name, required this.account});
  final int? id;
  final String name;
  final int account;
}

class AccountModel {
  AccountModel({this.id, required this.name});
  final int? id;
  final String name;
}

class StateModel {
  StateModel({this.id, required this.stat});
  final int? id;
  final int stat;
}

class DisplayHandler {
  DisplayHandler({
    required this.categoryName,
    required this.categoryTotalAmount,
  });
  final String categoryName;
  final double categoryTotalAmount;
}

class Slice {
  Slice({this.title, required this.value, required this.color});
  final String? title;
  final double value;
  final Color color;

  double ratioValue() {
    return value / TOPcatExpense;
  }
}

class ActionButtonModel {
  ActionButtonModel({required this.Icon, required this.funcx});

  final IconData Icon;
  final VoidCallback funcx;
}

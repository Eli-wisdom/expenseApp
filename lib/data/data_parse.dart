import 'package:expense_app/core/core_color.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:flutter/material.dart';

double TOPcatExpense = 0;

class DataParse {
  //Raw Data
  static late List<Expensemodel> expenseDataMain;
  static late List<categoryModel> categoryDataMain;
  static late List<AccountModel> accountDataMain;

  //Filtered for the account
  static late List<Expensemodel> expenseData;
  static late List<categoryModel> categoryData;
  static late AccountModel accountData;
  static List<Slice> slidData = [];

  //daymonth
  static List<Expensemodel> filteredExpense = [];

  setData(
    List<AccountModel> rawAccount,
    List<categoryModel> rawCategory,
    List<Expensemodel> rawExpense,
    int SelectedAccount,
  ) {
    accountDataMain = rawAccount;
    categoryDataMain = rawCategory;
    expenseDataMain = rawExpense;

    accountData = rawAccount.firstWhere((e) => e.id == SelectedAccount);
    categoryData =
        rawCategory.where((e) => e.account == SelectedAccount).toList();
    expenseData =
        rawExpense.where((e) => e.account == SelectedAccount).toList();
  }

  static setAccountData(int selectedAccount) {
    accountData = accountDataMain.firstWhere((e) => e.id == selectedAccount);
    categoryData =
        categoryDataMain.where((e) => e.account == selectedAccount).toList();
    expenseData =
        expenseDataMain.where((e) => e.account == selectedAccount).toList();
    debugPrint(
      "### Checkxvx setAccountData: ${accountData.name} expenseData: ${expenseData.length}",
    );
  }

  static double totalExpenses() {
    final double total = expenseData
        .where((e) => e.state == 0)
        .toList()
        .fold(0.0, (sum, e) => sum + e.amount);
    return total;
  }

  static bool checkAccountExist(String accName) {
    return accountDataMain.any(
      (e) => e.name.toUpperCase().trim() == accName.toUpperCase().trim(),
    );
  }

  static double totalIncome() {
    final double total = expenseData
        .where((e) => e.state == 1)
        .toList()
        .fold(0.0, (sum, e) => sum + e.amount);
    return total;
  }

  static List<Expensemodel> expenseFilter(int selectedIndex) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfYear = DateTime(now.year, 1, 1);
    late List<Expensemodel> dataout;

    switch (selectedIndex) {
      case 0:
        dataout = expenseData;
        break;
      case 1:
        dataout = expenseData.where((e) => e.date == DateTime.now()).toList();
        break;
      case 2:
        dataout =
            expenseData.where((e) => e.date.isAfter(startOfWeek)).toList();
        break;
      case 3:
        dataout =
            expenseData.where((e) => e.date.isAfter(startOfMonth)).toList();
        break;
      case 4:
        dataout =
            expenseData.where((e) => e.date.isAfter(startOfYear)).toList();
        break;
    }
    filteredExpense = dataout;
    setCategorySlicex();
    debugPrint(
      "### Checkxvx filteredExpense: ${accountData.name} filteredExpense length: ${filteredExpense.length}",
    );
    return dataout;
  }

  static List<Slice> getCategorySlice() {
    int counter = 0;
    double catExpense = 0;
    slidData.clear();
    for (categoryModel cat in categoryData) {
      final double total = expenseData
          .where((e) => e.category == cat.id)
          .toList()
          .fold(0.0, (sum, e) => sum + e.amount);
      if (catExpense < total) {
        catExpense = total;
      }
      slidData.add(
        Slice(title: cat.name, value: total, color: purpleShades[counter]),
      );

      //slidData.add(dataholder);
      counter += 1;
    }
    TOPcatExpense = catExpense;
    return slidData;
  }

  static setCategorySlicex() {
    int counter = 0;
    double catExpense = 0;
    for (Expensemodel filter in filteredExpense) {
      // debugPrint(
      //   "### Checkxvx Just FiteredData ID: " +
      //       filter.id.toString() +
      //       " CATEGORY: " +
      //       filter.category.toString() +
      //       " ACCOUNT: " +
      //       filter.account.toString(),
      // );
    }

    slidData.clear();
    for (categoryModel cat in categoryData) {
      final double total = filteredExpense
          .where((e) => e.category == cat.id)
          .toList()
          .fold(0.0, (sum, e) => sum + e.amount);

      if (catExpense < total) {
        catExpense = total;
      }
      slidData.add(
        Slice(title: cat.name, value: total, color: purpleShades[counter]),
      );

      //slidData.add(dataholder);
      counter += 1;
    }

    TOPcatExpense = catExpense;
    debugPrint(
      "### Checkxvx getCategorySlicex: ${accountData.name} filteredExpense length ${filteredExpense.length} slidData length ${slidData.length}",
    );
  }

  static double totalExpenseFilter() {
    double total = slidData
        .where((e) => e.value != -1)
        .toList()
        .fold(0.0, (sum, e) => sum + e.value);
    debugPrint(
      "### Checkxvx totalExpenseFilter: ${accountData.name} filteredExpense length: ${filteredExpense.length} slidData length: ${slidData.length} totalExpenseFilter $total",
    );
    return total;
  }
}

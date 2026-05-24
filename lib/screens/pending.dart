// bool categoryCreation = false;
//   late List<Expensemodel> _expenseData;
//   late List<categoryModel> _categoryData;
//   late List<AccountModel> _accountData;
//   ProviderSubscription<List<Expensemodel>>? _expenseSub;
//   ProviderSubscription<List<categoryModel>>? _categorySub;
//   ProviderSubscription<List<AccountModel>>? _accountSub;

//   // active
//   late int activeAccount; //
//   late int activeCategory; //
//   late List<Expensemodel> activeExpenseAccount;
//   late double activeAccountBalance;
//   late List<Expensemodel> onlyAccountExpense;
//   late bool _isloading;

//   @override
//   void initState() {
//     super.initState();
//     _isloading = true;
//     _expenseData = ref.read(expenseNotifierProvider);
//     _categoryData = ref.read(categoryNotifierProvider);
//     _accountData = ref.read(accountNotifierProvider);
//     activesVariables();
//     _rebuildAccountsFromProviders();
//     _isloading = false;
//     _expenseSub = ref.listenManual<List<Expensemodel>>(
//       expenseNotifierProvider,
//       (previous, next) {
//         if (!mounted) return;
//         setState(() {
//           _expenseData = next;
//           activesVariables();
//           _rebuildAccountsFromProviders();
//         });
//       },
//     );
//     _categorySub = ref.listenManual<List<categoryModel>>(
//       categoryNotifierProvider,
//       (previous, next) {
//         if (!mounted) return;
//         setState(() {
//           _categoryData = next;
//           _rebuildAccountsFromProviders();
//         });
//       },
//     );
//     _accountSub = ref.listenManual<List<AccountModel>>(
//       accountNotifierProvider,
//       (previous, next) {
//         if (!mounted) return;
//         setState(() {
//           _accountData = next;
//           _rebuildAccountsFromProviders();
//         });
//       },
//     );
//     if (_accountData.isNotEmpty) {
//       debugPrint('## checking account data ' + _accountData[0].name);
//     } else {
//       debugPrint('## checking account data: no accounts yet');
//     }
//   }

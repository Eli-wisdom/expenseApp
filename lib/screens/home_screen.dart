import 'package:expense_app/data/data_parse.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:expense_app/provider/expense_provider.dart';
import 'package:expense_app/widgets/customize_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool categoryCreation = false;
  late List<Expensemodel> _expenseData;
  late List<categoryModel> _categoryData;
  late List<AccountModel> _accountData;
  String? _bootstrapError;

  late AccountModel g_activeAccount;
  late int activeAccountindex = 1;
  //late List<categoryModel> g_activeCategory;
  late List<Expensemodel> g_activeExpenses;
  bool _hasActiveAccount = false;
  List<categoryModel> g_activeCategoryExpenseOnly = [];

  bool initiateAccount = true;
  bool getLatest = false;
  late AccountModel newAccount;
  String? newAccountName;
  bool createLoading = false;

  // List<Padding> actionIcon = [
  //   Padding(
  //     // add account xx
  //     padding: const EdgeInsets.only(right: 4.0),
  //     child: IconButton(
  //       icon: const Icon(Icons.add_circle_outline, color: CyberTheme.primary),
  //       tooltip: 'Create account',
  //       onPressed: _showCreateAccountDialog,
  //     ),
  //   ),
  //   Padding(
  //     // add account xx
  //     padding: const EdgeInsets.only(right: 4.0),
  //     child: IconButton(
  //       icon: const Icon(Icons.add_circle_outline, color: CyberTheme.primary),
  //       tooltip: 'Create account',
  //       onPressed: _showCreateAccountDialog,
  //     ),
  //   ),
  // ];

  // active
  late int activeAccount; //
  late int activeCategory; //
  late List<Expensemodel> activeExpenseAccount;
  late double activeAccountBalance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _activeAccount = 'HOME ACCOUNT';

  int getAccountindex(String accountName) {
    AccountModel accountdata = _accountData.firstWhere(
      (e) => e.name == accountName,
    );
    return accountdata.id!;
  }

  @override
  Widget build(BuildContext context) {
    //getDataFromSql();
    debugPrint("##** Starting App ");
    _accountData = ref.watch(accountNotifierProvider);
    _categoryData = ref.watch(categoryNotifierProvider);
    _expenseData = ref.watch(expenseNotifierProvider);
    bool king = true;
    if (_accountData.isEmpty ||
        _categoryData.isEmpty ||
        _expenseData.isEmpty ||
        createLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      if (initiateAccount) {
        g_activeAccount = _accountData[0];
        activeAccountindex = g_activeAccount.id!;
        debugPrint("## initiateAccount initiated ");
        initiateAccount = false;
      }
      activeAccountindex = g_activeAccount.id!;
      debugPrint("### Check Expense ");
      for (final expense in _expenseData) {
        debugPrint(
          expense.id.toString() +
              " || " +
              expense.title +
              "" +
              expense.account.toString() +
              "" +
              expense.amount.toString(),
        );
      }

      debugPrint(
        "## Latest Account : " + _accountData[_accountData.length - 1].name,
      );
      debugPrint(
        "## Latest Account index : " +
            _accountData[_accountData.length - 1].id.toString(),
      );
      DataParse().setData(
        _accountData,
        _categoryData,
        _expenseData,
        activeAccountindex,
      );

      // g_activeCategory =
      //     _categoryData.where((e) => e.account == activeAccountindex).toList();

      debugPrint('##-- activeAccountindex ' + activeAccountindex.toString());
      //debugPrint('##-- g_activeCategory ' + g_activeCategory.toString());
    }

    if (_bootstrapError != null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Startup error: $_bootstrapError',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_accountData.isEmpty) {
      return const Scaffold(body: Center(child: Text('No accounts yet.')));
    }

    // if (!_hasActiveAccount && _accountData.isNotEmpty) {
    //   g_activeAccount = _accountData[0];
    //   _hasActiveAccount = true;
    // }

    //main activeAccountindex
    // activeAccountindex = _accountData.indexOf(g_activeAccount);

    if (activeAccountindex == -1) {
      activeAccountindex = 0;
    }
    // int checkLength = ref.watch(accountNotifierProvider).length;
    // List<AccountModel> checkaccount = ref.watch(accountNotifierProvider);
    // debugPrint('##  activeAccountindex ' + activeAccountindex.toString());
    // debugPrint('## AccoundData Updated new1 ' + checkLength.toString());
    // debugPrint(
    //   '## AccoundData Updated title ' + checkaccount[checkLength].name,
    // );

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Background handled by ScaffoldWithNavBar
      appBar: CustomizedAppBar(
        ActivePage: 1,
        g_activeAccount: g_activeAccount,
        SubmitSelectedAccount: SubmitSelectedAccount,
        createLoading: loadNewAccount,
      ),
      //AppBar(
      //   titleSpacing: 24.0,
      //   backgroundColor: CyberTheme.surface,
      //   elevation: 0,
      //   toolbarHeight: 64,
      //   automaticallyImplyLeading: false,
      //   shape: Border(
      //     bottom: BorderSide(
      //       color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
      //     ),
      //   ),
      //   title: PopupMenuButton<AccountModel>(
      //     tooltip: 'Switch account',
      //     onSelected:
      //         (value) => setState(() {
      //           g_activeAccount = value;
      //           _hasActiveAccount = true;
      //         }),
      //     color: CyberTheme.surfaceContainerLowest,
      //     surfaceTintColor: Colors.transparent,
      //     offset: const Offset(0, 36),
      //     shape: RoundedRectangleBorder(
      //       side: BorderSide(
      //         color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
      //       ),
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     itemBuilder:
      //         (context) =>
      //             DataParse.accountDataMain
      //                 .map(
      //                   (account) => PopupMenuItem<AccountModel>(
      //                     value: account,
      //                     child: Row(
      //                       children: [
      //                         Icon(
      //                           account == g_activeAccount
      //                               ? Icons.radio_button_checked
      //                               : Icons.radio_button_unchecked,
      //                           size: 14,
      //                           color:
      //                               account == g_activeAccount
      //                                   ? CyberTheme.primary
      //                                   : CyberTheme.onSurfaceVariant,
      //                         ),
      //                         const SizedBox(width: 12),
      //                         Text(
      //                           account.name.toUpperCase(),
      //                           style: GoogleFonts.getFont(
      //                             'Space Grotesk',
      //                             fontSize: 13,
      //                             fontWeight: FontWeight.w600,
      //                             color: CyberTheme.onSurface,
      //                             letterSpacing: 0.5,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     onTap: () {
      //                       setState(() {
      //                         g_activeAccount = account;
      //                         activeAccountindex = g_activeAccount.id!;
      //                       });
      //                     },
      //                   ),
      //                 )
      //                 .toList(),

      //     child: Row(
      //       children: [
      //         const Icon(
      //           Icons.account_balance_wallet,
      //           color: CyberTheme.primary,
      //         ),
      //         const SizedBox(width: 6),
      //         Text(
      //           g_activeAccount.name.toUpperCase(),
      //           style: GoogleFonts.getFont(
      //             'Space Grotesk',
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: CyberTheme.primary,
      //             letterSpacing: -0.5,
      //           ),
      //         ),
      //         const SizedBox(width: 6),
      //         Icon(
      //           Icons.expand_more,
      //           color: CyberTheme.primary.withValues(alpha: 0.8),
      //           size: 20,
      //         ),
      //       ],
      //     ),
      //   ),
      //   actions: [
      //     if (MediaQuery.of(context).size.width > 768)
      //       Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           _buildTopNavText('DASHBOARD', true),
      //           const SizedBox(width: 24),
      //           _buildTopNavText('TERMINAL', false),
      //           const SizedBox(width: 24),
      //           _buildTopNavText('NETWORK', false),
      //           const SizedBox(width: 24),
      //         ],
      //       ),
      //     Padding(
      //       // add account xx
      //       padding: const EdgeInsets.only(right: 4.0),
      //       child: IconButton(
      //         icon: const Icon(
      //           Icons.add_circle_outline,
      //           color: CyberTheme.primary,
      //         ),
      //         tooltip: 'Create account',
      //         onPressed: _showCreateAccountDialog,
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(right: 8.0),
      //       child: IconButton(
      //         icon: const Icon(
      //           Icons.notifications,
      //           color: CyberTheme.onSurfaceVariant,
      //         ),
      //         onPressed: _showNotificationsPanel,
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 4.0,
          bottom: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection().animate().slideY(begin: 0.1, end: 0).fadeIn(),
            const SizedBox(height: 48),
            _buildCategoryAnalytics()
                .animate()
                .slideY(begin: 0.1, end: 0, delay: 100.ms)
                .fadeIn(delay: 100.ms),
            const SizedBox(height: 32),
            _buildQuickActions()
                .animate()
                .slideY(begin: 0.1, end: 0, delay: 200.ms)
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 48),
            _buildLedgerActivity()
                .animate()
                .slideY(begin: 0.1, end: 0, delay: 300.ms)
                .fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavText(String text, bool active) {
    return Text(
      text,
      style: GoogleFonts.getFont(
        'Space Grotesk',
        fontSize: 12,
        letterSpacing: 3.0,
        color: active ? CyberTheme.primary : CyberTheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildHeroSection() {
    double balance = DataParse.totalExpenses() ?? 0;
    final prefix =
        balance < 0
            ? '-\$'
            : '\$'; //TODO: will Change this if the currency is fixed.
    final formatted = _formatCurrency(balance);
    final parts = formatted.split('.');
    final intPart = parts.isNotEmpty ? parts[0] : '0';
    final decPart = parts.length > 1 ? parts[1] : '00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: CyberTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: CyberTheme.primary, blurRadius: 8),
                    ],
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fadeOut(duration: 1.seconds),
            const SizedBox(width: 8),
            Text(
              'EXPENSES: ',
              style: CyberTheme.monoFont(
                fontSize: 10,
                letterSpacing: 2.0,
                color: CyberTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$prefix$intPart.',
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 54,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
                color: CyberTheme.primary,
                shadows: [
                  const BoxShadow(
                    color: CyberTheme.primaryContainer,
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            Text(
              decPart,
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 40,
                color: CyberTheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
        Row(
          children: [
            Text(
              'INCOME:',
              style: CyberTheme.monoFont(
                fontSize: 10,
                letterSpacing: 2.0,
                color: CyberTheme.onSurfaceVariant,
              ),
            ),
            Text(
              " " + DataParse.totalIncome().toString(),
              style: CyberTheme.monoFont(
                fontSize: 10,
                letterSpacing: 2.0,
                color: CyberTheme.onSurface,
              ),
            ),
            Text(
              ' || BALANCE: ',
              style: CyberTheme.monoFont(
                fontSize: 10,
                letterSpacing: 2.0,
                color: CyberTheme.onSurfaceVariant,
              ),
            ),
            Text(
              (DataParse.totalIncome() - DataParse.totalExpenses()).toString(),
              style: CyberTheme.monoFont(
                fontSize: 10,
                letterSpacing: 2.0,
                color: CyberTheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryAnalytics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: CyberTheme.surfaceContainerLowest,
        border: Border(left: BorderSide(color: CyberTheme.primary, width: 2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CATEGORY_ANALYTICS',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 3,
                  color: CyberTheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Material(
                color: CyberTheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: CyberTheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                child: InkWell(
                  onTap: _showAddCategoryDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(
                      Icons.bar_chart,
                      size: 14,
                      color: CyberTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            height: 256,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  DataParse.getCategorySlice().map((cat) {
                    return _buildBar(
                      cat.title!,
                      cat.value.toString(),
                      cat.ratioValue(),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: Text(
              'EXPAND_SECTOR_DATA',
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 10,
                letterSpacing: 3.0,
                color: CyberTheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, String value, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value, //TODO: will change
          style: CyberTheme.monoFont(fontSize: 10, color: CyberTheme.primary),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 192,
          color: CyberTheme.surfaceContainerHighest.withValues(alpha: 0.3),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: heightFactor > 0 ? heightFactor : 0.001,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [CyberTheme.primary, CyberTheme.primaryContainer],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(color: CyberTheme.primaryContainer, blurRadius: 15),
                ],
              ),
            ),
          ).animate().scaleY(
            begin: 0,
            end: 1,
            duration: 800.ms,
            curve: Curves.easeOut,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.getFont(
            'Space Grotesk',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: CyberTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAddDialog(isIncome: true),
            icon: const Icon(Icons.add_circle, size: 14),
            label: const Text('ADD INCOME'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 24),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showAddDialog(isIncome: false),
            icon: const Icon(Icons.remove_circle, size: 14),
            label: const Text('ADD EXPENSES'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLedgerActivity() {
    // final transactions = List<_LedgerEntry>.from(
    //   _accounts[_activeAccount]?.transactions ?? [],
    // )..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // List<Expensemodel> expenseData =
    //     _expenseData.where((e) => e.account == activeAccountindex).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LEDGER_ACTIVITY',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.filter_list, color: CyberTheme.onSurfaceVariant),
                  SizedBox(width: 16),
                  Icon(Icons.download, color: CyberTheme.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 320,
          child:
              DataParse.expenseData.isEmpty
                  ? Container(
                    padding: const EdgeInsets.all(24),
                    color: CyberTheme.surfaceContainerLowest.withValues(
                      alpha: 0.5,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inbox,
                          color: CyberTheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'NO TRANSACTIONS YET',
                          style: CyberTheme.monoFont(
                            fontSize: 12,
                            color: CyberTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: DataParse.expenseData.length,
                    reverse: true,
                    itemBuilder:
                        (ctx, index) =>
                            _buildActivityItem2(DataParse.expenseData[index]),
                  ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(_LedgerEntry entry) {
    final isIncome = entry.type == _LedgerType.income;
    final amount = _formatCurrency(entry.amount);
    final formattedAmount = '${isIncome ? '+' : '-'}\$$amount';
    final status = isIncome ? 'CONFIRMED' : 'SETTLED';
    final title = isIncome ? 'INCOME_ADDED' : 'EXPENSE_ADDED';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      color: CyberTheme.surfaceContainerLowest.withValues(alpha: 0.5),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: CyberTheme.onSurfaceVariant,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'ID: ${entry.note.isEmpty ? 'TXN' : entry.note}${entry.category != null ? ' // ${entry.category}' : ''}',
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIMESTAMP',
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatTimestamp(entry.timestamp),
                  style: CyberTheme.monoFont(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: CyberTheme.monoFont(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? CyberTheme.primary : CyberTheme.onSurface,
                  ),
                ),
                Text(
                  status,
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem2(Expensemodel entry) {
    int isIncome = entry.state;
    final amount = _formatCurrency(entry.amount);
    final formattedAmount = '${isIncome == 1 ? '+' : '-'}\$$amount';
    final status = (isIncome == 1) ? 'CONFIRMED' : 'SETTLED';
    final title = (isIncome == 1) ? 'INCOME_ADDED' : 'EXPENSE_ADDED';

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      color: CyberTheme.surfaceContainerLowest.withValues(alpha: 0.5),
      child: Row(
        children: [
          Icon(
            (isIncome == 1)
                ? Icons.add_circle_outline
                : Icons.remove_circle_outline,
            color: CyberTheme.onSurfaceVariant,
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'ID: ${entry.title.isEmpty ? 'TXN' : entry.title}${entry.category != null ? ' // ${entry.category}' : ''}',
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIMESTAMP',
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatTimestamp(entry.date),
                  style: CyberTheme.monoFont(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: CyberTheme.monoFont(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        (isIncome == 1)
                            ? CyberTheme.primary
                            : CyberTheme.onSurface,
                  ),
                ),
                Text(
                  status,
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime value) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${value.year}.${two(value.month)}.${two(value.day)} '
        '// ${two(value.hour)}:${two(value.minute)}:${two(value.second)}';
  }

  String _formatCurrency(double value) {
    final absValue = value.abs();
    final fixed = absValue.toStringAsFixed(2);
    final parts = fixed.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$intPart.${parts.length > 1 ? parts[1] : '00'}';
  }

  double _safeHeightFactor(double value, double maxValue) {
    if (maxValue <= 0) return 0;
    final normalized = (value.abs() / maxValue);
    if (!normalized.isFinite) return 0;
    if (normalized < 0) return 0;
    if (normalized > 1) return 1;
    return normalized;
  }

  void _showNotificationsPanel() {
    // final transactions = List<_LedgerEntry>.from(
    //   _accounts[_activeAccount]?.transactions ?? [],
    // )..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: CyberTheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOTIFICATIONS',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: CyberTheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 18),
                    color: CyberTheme.onSurfaceVariant,
                    splashRadius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Recent account activity and system pings.',
                style: CyberTheme.monoFont(
                  fontSize: 11,
                  color: CyberTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child:
                    // transactions.isEmpty
                    //     ?
                    _buildEmptyNotifications(),
                // : ListView.separated(
                //   shrinkWrap: true,
                //   itemCount:
                //       transactions.length > 6 ? 6 : transactions.length,
                //   separatorBuilder:
                //       (_, __) => const SizedBox(height: 12),
                //   itemBuilder: (context, index) {
                //     final entry = transactions[index];
                //     return _buildNotificationItem(entry);
                //   },
                // ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'MARK ALL READ',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 11,
                      letterSpacing: 2,
                      color: CyberTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyNotifications() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLowest,
        border: Border.all(
          color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_off,
            color: CyberTheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            'NO NEW ALERTS',
            style: CyberTheme.monoFont(
              fontSize: 11,
              color: CyberTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(_LedgerEntry entry) {
    final isIncome = entry.type == _LedgerType.income;
    final amount = _formatCurrency(entry.amount);
    final prefix = isIncome ? '+' : '-';
    final title = isIncome ? 'INCOME_CONFIRMED' : 'EXPENSE_SETTLED';
    final subtitle =
        '${entry.note.isEmpty ? 'TXN' : entry.note}${entry.category != null ? ' // ${entry.category}' : ''}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: CyberTheme.onSurfaceVariant,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: CyberTheme.monoFont(
                    fontSize: 10,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$prefix\$$amount',
                style: CyberTheme.monoFont(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? CyberTheme.primary : CyberTheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(entry.timestamp),
                style: CyberTheme.monoFont(
                  fontSize: 9,
                  color: CyberTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog({required bool isIncome}) async {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    categoryModel selectedCategory = DataParse.categoryDataMain[0];
    List<categoryModel> laodedCategory = DataParse.categoryData;
    if (!isIncome && laodedCategory.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add a category first.')));
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final List<categoryModel> g_activeCategoryExpenseOnly =
            laodedCategory.where((cat) => cat.name != 'DAILY').toList();

        return AlertDialog(
          backgroundColor: CyberTheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            isIncome ? 'ADD INCOME' : 'ADD EXPENSE',
            style: GoogleFonts.getFont(
              'Space Grotesk',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: CyberTheme.monoFont(fontSize: 14),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),

              if (!isIncome)
                DropdownButtonFormField<categoryModel>(
                  value: DataParse.categoryData[0],
                  dropdownColor: CyberTheme.surfaceContainerLowest,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items:
                      DataParse.categoryData
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat.name,
                                style: CyberTheme.monoFont(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    // debugPrint('chigo ## ShowValue ' + value.toString());
                    setState(() {
                      if (value == null) {
                        value = g_activeCategoryExpenseOnly[0];
                      }

                      selectedCategory = value!;
                    });
                  },
                ),
              if (!isIncome) const SizedBox(height: 16),
              TextField(
                controller: noteController,
                style: CyberTheme.monoFont(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'CANCEL',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final raw = amountController.text.replaceAll(',', '').trim();
                final amount = double.tryParse(raw);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid amount.')),
                  );
                  return;
                }
                if (!isIncome && laodedCategory.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add a category first.')),
                  );
                  return;
                }
                final data = Expensemodel(
                  title: noteController.text,
                  amount: amount,
                  date: DateTime.now(),
                  category: isIncome ? 0 : selectedCategory.id,
                  state: isIncome ? 1 : 0,
                  account: activeAccountindex,
                );

                ref.read(expenseNotifierProvider.notifier).addExpenses(data);
                categoryCreation = false;
                Navigator.of(context).pop(true);
              },
              child: Text(
                'SAVE',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != true) return;
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    final selectedAccount = _activeAccount;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CyberTheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'ADD CATEGORY',
            style: GoogleFonts.getFont(
              'Space Grotesk',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: CyberTheme.monoFont(fontSize: 12),
                decoration: const InputDecoration(labelText: 'Category name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'CANCEL',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ref
                      .read(categoryNotifierProvider.notifier)
                      .addCategory(
                        categoryModel(
                          name: nameController.text.trim(),
                          account: activeAccountindex,
                        ),
                      );

                  ref
                      .read(expenseNotifierProvider.notifier)
                      .addExpenses(
                        Expensemodel(
                          category: _categoryData.length + 1,
                          title: 'Income',
                          amount: 00,
                          date: DateTime.now(),
                          state: 1,
                          account: activeAccountindex,
                        ),
                      );
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'SAVE',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final rawName = nameController.text.trim();
    if (rawName.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a category name.')));
      return;
    }

    final normalized = rawName.toUpperCase();
    // if (_categories.contains(normalized)) {
    //   if (!mounted) return;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Category already exists.')));
    //   return;
    // }
    setState(() {
      final accounts = ref.read(accountNotifierProvider);
      final accountId =
          accounts
              .firstWhere(
                (account) => account.name == selectedAccount,
                orElse: () => AccountModel(id: 0, name: selectedAccount),
              )
              .id ??
          0;
      ref
          .read(categoryNotifierProvider.notifier)
          .addCategory(
            categoryModel(name: normalized, account: activeAccountindex),
          );
    });
  }

  Future<void> submitAccountDetails(String namec, double balancec) async {
    createLoading = true;

    debugPrint('## submitAccountDetails Started ');
    await ref
        .read(accountNotifierProvider.notifier)
        .addAccountCatExp(
          AccountModel(name: namec),
          categoryModel(name: 'DAILY', account: _accountData.length + 1),
          Expensemodel(
            //main error
            title: 'Base Income',
            category: _categoryData.length,
            amount: balancec,
            date: DateTime.now(),
            state: 1,
            account: _accountData.length + 1,
          ),
        );
    g_activeAccount = _accountData[_accountData.length - 1];
    activeAccountindex = g_activeAccount.id!;

    debugPrint('## submitAccountDetails Ended ');
    createLoading = false;
  }

  void SubmitSelectedAccount(AccountModel account) {
    setState(() {
      g_activeAccount = account;
      activeAccountindex = g_activeAccount.id!;
    });
  }

  void loadNewAccount(bool loading) {
    setState(() {
      createLoading = loading;
    });
  }

  Future<void> _showCreateAccountDialog() async {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CyberTheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'CREATE ACCOUNT',
            style: GoogleFonts.getFont(
              'Space Grotesk',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: CyberTheme.monoFont(fontSize: 12),
                decoration: const InputDecoration(labelText: 'Account name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: CyberTheme.monoFont(fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Starting balance (optional)',
                  prefixText: '\$ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                debugPrint('###############################');
                debugPrint('## Opening CreateAccount method');
                final namec = nameController.text.trim();
                // double? balancec =
                //     double.tryParse(balanceController.text.trim()) ?? 0.0;
                final raw = balanceController.text.replaceAll(',', '').trim();
                double balancec = double.tryParse(raw) ?? 0.0;

                if (namec.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter an account name.')),
                  );
                }

                if (DataParse.checkAccountExist(nameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account already exist')),
                  );
                } else {
                  submitAccountDetails(namec, balancec);
                  // setState(() {
                  //   if (!context.mounted) return;
                  //   Navigator.of(context).pop();
                  // });
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Text(
                'CREATE',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AccountData {
  _AccountData({
    required this.name,
    required this.balance,
    required Map<String, double> categoryTotals,
    required List<_LedgerEntry> transactions,
  }) : categoryTotals = categoryTotals,
       transactions = transactions;

  final String name;
  double balance;
  final Map<String, double> categoryTotals;
  final List<_LedgerEntry> transactions;
}

enum _LedgerType { income, expense }

class _LedgerEntry {
  _LedgerEntry({
    required this.type,
    required this.amount,
    required this.timestamp,
    this.category,
    this.note = '',
  });

  final _LedgerType type;
  final double amount;
  final DateTime timestamp;
  final String? category;
  final String note;
}

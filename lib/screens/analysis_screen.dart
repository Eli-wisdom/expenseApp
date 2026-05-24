import 'package:expense_app/core/core_color.dart';
import 'package:expense_app/data/data_parse.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:expense_app/provider/expense_provider.dart';
import 'package:expense_app/widgets/customize_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  //main
  late List<AccountModel> _accountData;
  late List<categoryModel> _categoryData;
  late List<Expensemodel> _expenseData;
  //secondry
  //late AccountModel _activeAccountx;
  late int _activeAccountINdex;
  bool unInitialzedata = true;
  List<Slice> slidData = [];
  double categoryTotal = 0; //the sum of all the expenses in the account
  int filterindex = 0;
  double filterTotal = 0;
  List<Expensemodel> newFilterdExpense = [];

  late AccountModel activeAccount;
  bool initiateApp = true;
  _TimeRange _rangeLeft = _TimeRange.all;
  _TimeRange _rangeTrend = _TimeRange.week;
  _TimeRange _rangeLimits = _TimeRange.week;
  final Map<String, double> _accountTotals = {
    'HOME ACCOUNT': 142850.42,
    'SAVINGS VAULT': 98420.12,
    'TRAVEL FUND': 23640.50,
    'PROJECT OPS': 55320.00,
  };
  final Map<String, Map<String, double>> _accountCategories = {
    'HOME ACCOUNT': {'FOOD': 1240, 'TRANSPORT': 450, 'SHOPPING': 890},
    'SAVINGS VAULT': {'FOOD': 420, 'TRANSPORT': 110, 'SHOPPING': 300},
    'TRAVEL FUND': {'FOOD': 820, 'TRANSPORT': 980, 'SHOPPING': 410},
    'PROJECT OPS': {'FOOD': 320, 'TRANSPORT': 260, 'SHOPPING': 610},
  };

  @override
  Widget build(BuildContext context) {
    // In a real app this would use LayoutBuilder for the grid

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    _accountData = ref.read(accountNotifierProvider);
    // final categoryV = ref.read(categoryNotifierProvider);
    // final expensesV = ref.read(expenseNotifierProvider);

    if (initiateApp) {
      activeAccount = _accountData[0];
      _activeAccountINdex = activeAccount.id!;

      initiateApp = false;
    }

    DataParse.setAccountData(activeAccount.id!);
    DataParse.expenseFilter(filterindex);
    filterTotal = DataParse.totalExpenseFilter();

    //if (_accountData.isNotEmpty) {
    // if (unInitialzedata) {
    //   _activeAccountx = _accountData[0];
    //   unInitialzedata = false;
    // }
    //_activeAccountINdex = _activeAccountx.id!;
    //DataParse.setAccountData(_activeAccountINdex);
    // _categoryData = [];
    // _categoryData =
    //     categoryV
    //         .where(
    //           (e) => e.account == _activeAccountINdex && e.name != 'DAILY',
    //         )
    //         .toList();
    // final _expenseDataIV =
    //     expensesV
    //         .where((e) => e.account == _activeAccountINdex && e.state == 0)
    //         .toList();
    // _expenseData = DataParse.expenseFilter(
    //   filterindex,
    // ); // TODO:correct the filter index
    // newFilterdExpense = _expenseData;

    // int counter = 0;
    // slidData.clear();
    // for (categoryModel cat in _categoryData) {
    //   final double total = _expenseData
    //       .where((e) => e.category == cat.id)
    //       .toList()
    //       .fold(0.0, (sum, e) => sum + e.amount);

    //   slidData.add(
    //     Slice(title: cat.name, value: total, color: purpleShades[counter]),
    //   );
    //   debugPrint(
    //     '## chigo print data total ' + total.toString() + ' ' + cat.name,
    //   );
    //   //slidData.add(dataholder);
    //   counter += 1;
    // }
    // categoryTotal = slidData.fold(0, (sum, e) => sum + e.value);
    // for (Expensemodel ex in _expenseData) {
    //   debugPrint(
    //     'chigo ' + ex.category.toString() + ' ' + ex.amount.toString(),
    //   );
    // }

    // for (categoryModel cat in _categoryData) {
    //   debugPrint(
    //     'chigo Cat ' + cat.id.toString() + ' ' + cat.name.toString(),
    //   );
    // }
    //}

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomizedAppBar(
        ActivePage: 2,
        g_activeAccount: activeAccount,
        SubmitSelectedAccount: SubmitSelectedAccount,
        createLoading: loadNewAccount,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 48.0,
          bottom: 128.0,
        ),
        child:
            isDesktop
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _buildLeftColumn()),
                    const SizedBox(width: 32),
                    Expanded(flex: 8, child: _buildRightColumn()),
                  ],
                )
                : Column(
                  children: [
                    _buildLeftColumn(),
                    const SizedBox(height: 32),
                    _buildRightColumn(),
                  ],
                ),
      ),
    );
  }

  Widget _buildTopNavText(String text, bool active) {
    return Container(
      decoration:
          active
              ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CyberTheme.primary, width: 2),
                ),
              )
              : null,
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: CyberTheme.monoFont(
          fontSize: 14,
          color: active ? CyberTheme.primary : CyberTheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    final total = DataParse.totalExpenses();
    final categoryExpenseTtotal = filterTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: CyberTheme.primaryContainer, width: 2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCOUNT_BREAKDOWN',
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: CyberTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'TOTAL: ${_formatCurrency(total)}',
                style: CyberTheme.monoFont(
                  fontSize: 24,
                  color: CyberTheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32), // dougnut selector
        _buildRangeSelector(
          String: "Hello",
          active: _rangeLeft,
          onChanged: (value) => setState(() => _rangeLeft = value),
        ),
        const SizedBox(height: 16), //doughnut
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CustomPaint(
                    painter: CategoryRingPainter(
                      allcategories: DataParse.slidData,
                      total: DataParse.totalExpenseFilter(),
                      background: CyberTheme.surfaceContainerLow,
                    ),
                  ),
                ).animate().scale(duration: 800.ms, curve: Curves.easeOutCubic),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatCurrency(categoryExpenseTtotal ?? 0.0),
                      style: CyberTheme.monoFont(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CATEGORY_TOTAL',
                      style: GoogleFonts.getFont(
                        'Space Grotesk',
                        fontSize: 10,
                        letterSpacing: 3.0,
                        color: CyberTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        _buildCategoryRow(DataParse.slidData), //category list
      ],
    );
  }

  Widget _buildCategoryRow(List<Slice> data) {
    //category list
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children:
            data
                .map(
                  (e) => Row(
                    children: [
                      Container(width: 8, height: 8, color: e.color),
                      const SizedBox(width: 12),
                      Text(
                        e.title!.toUpperCase(),
                        style: GoogleFonts.getFont(
                          'Space Grotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(width: 220),
                      Spacer(),
                      Text(
                        e.value == 0
                            ? (0.0).toString() + ' %'
                            : ((e.value / filterTotal) * 100).toStringAsFixed(
                                  2,
                                ) +
                                ' %',
                        style: CyberTheme.monoFont(
                          fontSize: 14,
                          color: e.color,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSpendingTrend()
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 48),
        const SizedBox(height: 16),
        _buildCoreLimits()
            .animate()
            .fadeIn(delay: 200.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 48),
        _buildAnomalyDetection()
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.1, end: 0),
        const SizedBox(height: 64),
        _buildGamificationOverlay()
            .animate()
            .fadeIn(delay: 600.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildSpendingTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPENDING_TREND',
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    color: CyberTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'WEEKLY_PULSE',
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: CyberTheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              _rangeLabel(_rangeTrend),
              style: CyberTheme.monoFont(
                fontSize: 12,
                color: CyberTheme.onSurfaceVariant,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 256,
          width: double.infinity,
          decoration: BoxDecoration(
            color: CyberTheme.surfaceContainerLowest,
            border: Border.all(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(size: Size.infinite, painter: PulseGraphPainter()),
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children:
                      ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].map((
                        day,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Text(
                            day,
                            style: CyberTheme.monoFont(
                              fontSize: 10,
                              color: CyberTheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  color: CyberTheme.primary.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    'PEAK: \$240.50',
                    style: CyberTheme.monoFont(
                      fontSize: 12,
                      color: CyberTheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoreLimits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CORE_LIMITS',
          style: GoogleFonts.getFont(
            'Space Grotesk',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
            color: CyberTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildLimitCard(
                'Monthly_Budget',
                '78%',
                0.78,
                CyberTheme.primary,
                'USED: \$3,900',
                'LIMIT: \$5,000',
              ),
            ),
            const SizedBox(width: 24),
            // Expanded(
            //   child: _buildLimitCard('Remaining_Liquidity', '22%', 0.22, CyberTheme.secondary, 'AVAIL: \$1,100', 'STATUS: CRITICAL_LOW'),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitCard(
    String title,
    String percentTxt,
    double percent,
    Color color,
    String leftData,
    String rightData,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLow,
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 12,
                  color: CyberTheme.onSurfaceVariant,
                ),
              ),
              Text(
                percentTxt,
                style: CyberTheme.monoFont(fontSize: 14, color: color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 6,
            width: double.infinity,
            color: CyberTheme.surfaceContainerHighest,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(color: color),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftData,
                style: CyberTheme.monoFont(
                  fontSize: 10,
                  color: CyberTheme.onSecondaryContainer,
                ),
              ),
              Text(
                rightData,
                style: CyberTheme.monoFont(
                  fontSize: 10,
                  color: CyberTheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnomalyDetection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ANOMALY_DETECTION',
          style: GoogleFonts.getFont(
            'Space Grotesk',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
            color: CyberTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        _buildAnomalyItem(
          Icons.warning,
          CyberTheme.error,
          'FUEL_CONSUMPTION_CRITICAL',
          '+15% above baseline. Efficiency drop detected in transport sector.',
          'REF_2930',
        ),
        const SizedBox(height: 16),
        _buildAnomalyItem(
          Icons.check_circle,
          CyberTheme.primary,
          'FOOD_EXPENDITURE',
          'Within optimal range. 3% decrease vs last maintenance cycle.',
          'REF_4412',
        ),
      ],
    );
  }

  Widget _buildAnomalyItem(
    IconData icon,
    Color color,
    String title,
    String desc,
    String ref,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CyberTheme.monoFont(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 14,
                    color: CyberTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(ref, style: CyberTheme.monoFont(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildGamificationOverlay() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: CyberTheme.surfaceContainerHigh,
        border: Border(
          top: BorderSide(color: CyberTheme.primaryContainer, width: 2),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.electric_bolt,
              size: 160,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STREAK_STATUS',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3.0,
                      color: CyberTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '14_DAY_STREAK',
                        style: GoogleFonts.getFont(
                          'Space Grotesk',
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.local_fire_department,
                        color: CyberTheme.primary,
                        size: 40,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Efficiency Multiplier Active',
                    style: CyberTheme.monoFont(
                      fontSize: 10,
                      letterSpacing: 2.0,
                      color: CyberTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color: CyberTheme.primaryContainer,
                    child: Text(
                      'UPGRADE_PROTOCOL',
                      style: GoogleFonts.getFont(
                        'Space Grotesk',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: CyberTheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSelector({
    //selecetor method
    required String,
    required _TimeRange active,
    required ValueChanged<_TimeRange> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLowest,
        border: Border.all(
          color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        children:
            _TimeRange.values.map((range) {
              final isActive = range == active;
              return TextButton(
                onPressed: () {
                  onChanged(range);
                  setState(() {
                    filterindex = range.index;
                    //set
                    debugPrint(
                      "### Check filterindex " + filterindex.toString(),
                    );
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  backgroundColor:
                      isActive
                          ? CyberTheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                  foregroundColor:
                      isActive
                          ? CyberTheme.primary
                          : CyberTheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          isActive
                              ? CyberTheme.primary.withValues(alpha: 0.4)
                              : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  _rangeLabel(range),
                  style: CyberTheme.monoFont(fontSize: 10),
                ),
              );
            }).toList(),
      ),
    );
  }

  String _rangeLabel(_TimeRange range) {
    switch (range) {
      case _TimeRange.all:
        return 'ALL';
      case _TimeRange.day:
        return 'DAY';
      case _TimeRange.week:
        return 'WEEK';
      case _TimeRange.month:
        return 'MONTH';
      case _TimeRange.year:
        return 'YEAR';
    }
  }

  String _formatCurrency(double value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$intPart.${parts.length > 1 ? parts[1] : '00'}';
  }

  String _formatPercent(double value) {
    final pct = (value * 100).toStringAsFixed(1);
    return '$pct%';
  }

  Future<void> _showCreateAccountDialog() async {
    final nameController = TextEditingController();

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
          content: TextField(
            controller: nameController,
            style: CyberTheme.monoFont(fontSize: 12),
            decoration: const InputDecoration(labelText: 'Account name'),
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
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter an account name.')),
                  );
                  return;
                }

                setState(() {
                  // _accounts.add(name);
                  _accountTotals[name] = 0.0;
                  _accountCategories[name] = {
                    'FOOD': 0,
                    'TRANSPORT': 0,
                    'SHOPPING': 0,
                  };
                  //_activeAccount = name;
                });
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

  void SubmitSelectedAccount(AccountModel account) {
    setState(() {
      print("#### data1" + account.name);
      activeAccount = account;
      _activeAccountINdex = activeAccount.id!;
    });
  }

  void loadNewAccount(bool loading) {
    setState(() {
      // createLoading = loading;
    });
  }
}

enum _TimeRange { all, day, week, month, year }

class PulseGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // vertical grid lines
    final gridPaint =
        Paint()
          ..color = CyberTheme.outlineVariant.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 6; i++) {
      double x = size.width * (i / 7.0);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Pulse path
    final path = Path();
    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.2), // peak
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.65),
      Offset(size.width * 0.8, size.height * 0.55),
      Offset(size.width * 0.9, size.height * 0.75),
      Offset(size.width * 1.0, size.height * 0.6),
    ];

    if (points.isEmpty) return;

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint =
        Paint()
          ..color = CyberTheme.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Create fill path for gradient
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CyberTheme.primaryContainer.withValues(alpha: 0.2),
              CyberTheme.primaryContainer.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CategoryRingPainter extends CustomPainter {
  CategoryRingPainter({
    required this.allcategories,
    required this.total,
    required this.background,
  });

  final List<Slice> allcategories;
  final double total;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = background
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * 3.141592653589793, false, basePaint);

    final slices = allcategories;

    double start = -1.5707963267948966;
    for (final slice in slices) {
      if (slice.value <= 0) continue;
      final paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = slice.color
            ..strokeCap = StrokeCap.round;
      final sweep = (slice.value / total) * 2 * 3.141592653589793;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CategoryRingPainter oldDelegate) {
    return allcategories != oldDelegate.allcategories ||
        total != oldDelegate.total;
  }
}

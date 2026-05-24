import 'package:expense_app/core/theme.dart';
import 'package:expense_app/data/data_parse.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:expense_app/provider/expense_provider.dart';
import 'package:expense_app/screens/analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

class CustomizedAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  CustomizedAppBar({
    super.key,
    required this.ActivePage,
    required this.g_activeAccount,
    required this.SubmitSelectedAccount,
    required this.createLoading,
  });
  int ActivePage;
  AccountModel g_activeAccount;
  Function(AccountModel) SubmitSelectedAccount;
  Function(bool) createLoading;

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  ConsumerState<CustomizedAppBar> createState() => _CustomizedAppBarState();
}

class _CustomizedAppBarState extends ConsumerState<CustomizedAppBar> {
  //AccountModel g_activeAccount;
  late List<categoryModel> _categoryData;
  late List<AccountModel> _accountData;

  late List<ActionButtonModel> _activeAction;
  late IconData pageIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accountData = ref.watch(accountNotifierProvider);
    _categoryData = ref.watch(categoryNotifierProvider);

    switch (widget.ActivePage) {
      case 1:
        _activeAction = [
          ActionButtonModel(
            Icon: Icons.add_box_outlined,
            funcx: () => showCreateAccountDialogx(context),
          ),
          ActionButtonModel(
            Icon: Icons.notifications_rounded,
            funcx: () => showCreateAccountDialogx(context),
          ),
        ];

        break;
      case 2:
        _activeAction = [
          ActionButtonModel(
            Icon: Icons.ac_unit_outlined,
            funcx: () => showCreateAccountDialogx(context),
          ),
        ];

        break;
      case 3:
        _activeAction = [
          ActionButtonModel(
            Icon: Icons.settings_input_component,
            funcx: () => showCreateAccountDialogx(context),
          ),
        ];

        break;
      case 4:
        _activeAction = [
          ActionButtonModel(
            Icon: Icons.account_tree,
            funcx: () => showCreateAccountDialogx(context),
          ),
        ];
    }
    switch (widget.ActivePage) {
      case 1:
        pageIcon = Icons.account_balance_wallet;
        break;
      case 2:
        pageIcon = Icons.analytics_outlined;
        break;
      case 3:
        pageIcon = Icons.share;
        break;
      case 4:
        pageIcon = Icons.settings;
        break;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: Container(
          decoration: BoxDecoration(
            color: CyberTheme.surface,
            border: Border(
              bottom: BorderSide(
                color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(pageIcon, color: CyberTheme.primary),
                      const SizedBox(width: 16),
                      PopupMenuButton<AccountModel>(
                        tooltip: 'Switch account',
                        onSelected: (value) {
                          widget.g_activeAccount = value;
                          widget.SubmitSelectedAccount(value);
                        },
                        color: CyberTheme.surfaceContainerLowest,
                        surfaceTintColor: Colors.transparent,
                        offset: const Offset(0, 36),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: CyberTheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) {
                          final items =
                              DataParse.accountDataMain
                                  .map(
                                    (account) => PopupMenuItem<AccountModel>(
                                      onTap: () {
                                        widget.g_activeAccount = account;
                                        widget.SubmitSelectedAccount(account);
                                      },
                                      value: account,
                                      child: Row(
                                        children: [
                                          Icon(
                                            account == widget.g_activeAccount
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            size: 14,
                                            color:
                                                account ==
                                                        widget.g_activeAccount
                                                    ? CyberTheme.primary
                                                    : CyberTheme
                                                        .onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            account.name.toUpperCase(),
                                            style: GoogleFonts.getFont(
                                              'Space Grotesk',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: CyberTheme.onSurface,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();

                          return [...items];
                        },
                        child: Row(
                          children: [
                            Text(
                              widget.g_activeAccount.name.toUpperCase(),
                              style: GoogleFonts.getFont(
                                'Space Grotesk',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CyberTheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.expand_more,
                              color: CyberTheme.primary.withValues(alpha: 0.8),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // if (isDesktop)
                  //   Row(
                  //     children: [
                  //       _buildTopNavText('DATAFEED', false),
                  //       const SizedBox(width: 24),
                  //       _buildTopNavText('ANALYTICS', true),
                  //       const SizedBox(width: 24),
                  //       _buildTopNavText('WALLET', false),
                  //       const SizedBox(width: 24),
                  //       _buildTopNavText('TERMINAL', false),
                  //     ],
                  // ),
                  Spacer(),
                  ..._activeAction
                      .map((ex) => customizedAction(ex.Icon, ex.funcx))
                      .toList(),
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
                  //     ),
                  //   ),
                  //   child: const Icon(
                  //     Icons.add_box_outlined,
                  //     color: CyberTheme.primary,
                  //     size: 22,
                  //   ),
                  // ),
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
                  //     ),
                  //   ),
                  //   child: const Icon(
                  //     Icons.notifications,
                  //     color: CyberTheme.primary,
                  //     size: 22,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCreateAccountDialogx(BuildContext context) async {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    debugPrint("### checking  showCreateAccountDialogx");

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

  Widget customizedAction(IconData ic, Function() fu) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: IconButton(
        icon: Icon(ic, color: CyberTheme.primary),
        tooltip: 'Create account',
        onPressed: fu,
      ),
    );
  }

  Future<void> showCreateAccountDialog(BuildContext context) async {
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

  Future<void> submitAccountDetails(String namec, double balancec) async {
    //createLoading = true;
    widget.createLoading(true);

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
    // g_activeAccount = ;
    //activeAccountindex = widget.g_activeAccount.id!;

    debugPrint('## submitAccountDetails Ended ');
    widget.createLoading(false);
    widget.SubmitSelectedAccount(_accountData[_accountData.length - 1]);
  }

  // void SubmitSelectedAccount(AccountModel account) {
  //   setState(() {
  //     g_activeAccount = account;
  //     activeAccountindex = widget.g_activeAccount.id!;
  //   });
  // }
}

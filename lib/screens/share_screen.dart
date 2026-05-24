import 'package:expense_app/data/data_parse.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:expense_app/screens/account_screen.dart';
import 'package:expense_app/screens/chat_screen.dart';
import 'package:expense_app/screens/login_screen.dart';
import 'package:expense_app/widgets/customize_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/theme.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  //customized appbar Parameters
  late AccountModel g_activeAccount;
  late int activeAccountindex = 1;
  bool createLoading = false;

  static const String _createAccountValue = '__create_account__';
  final List<String> _accounts = [
    'HOME ACCOUNT',
    'SAVINGS VAULT',
    'TRAVEL FUND',
    'PROJECT OPS',
  ];

  String _activeAccount = 'HOME ACCOUNT';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    g_activeAccount = DataParse.accountData;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomizedAppBar(
        ActivePage: 3,
        g_activeAccount: g_activeAccount,
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
                    Expanded(
                      flex: 4,
                      child: _buildLeftAxis()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 8,
                      child: _buildRightAxis(isDesktop)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 200.ms)
                          .slideX(begin: 0.1, end: 0),
                    ),
                  ],
                )
                : Column(
                  children: [
                    _buildLeftAxis()
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 32),
                    _buildRightAxis(isDesktop)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
      ),
    );
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

  Widget _buildLeftAxis() {
    _buildSystemCommands();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                'Verified Entities'.toUpperCase(),
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ACTIVE_NODES: 04',
              style: CyberTheme.monoFont(
                fontSize: 10,
                color: CyberTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildEntityNode(
          Icons.admin_panel_settings,
          'Admin_Root',
          'LVL_0_ACCESS',
          true,
        ),
        _buildEntityNode(Icons.person, 'Entity_01', 'LVL_2_ACCESS', false),
        _buildEntityNode(Icons.person, 'Entity_02', 'LVL_2_ACCESS', false),
        const SizedBox(height: 32),
        const Divider(color: CyberTheme.outlineVariant),
        const SizedBox(height: 32),
        _buildSystemCommands(),
      ],
    );
  }

  Widget _buildEntityNode(
    IconData icon,
    String name,
    String access,
    bool isAdmin,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLowest,
        border:
            isAdmin
                ? const Border(
                  left: BorderSide(
                    color: CyberTheme.primaryContainer,
                    width: 2,
                  ),
                )
                : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CyberTheme.surfaceContainer,
                    border: Border.all(
                      color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isAdmin
                            ? CyberTheme.primary
                            : CyberTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: CyberTheme.monoFont(
                          fontSize: 14,
                          fontWeight:
                              isAdmin ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        access,
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isAdmin
                        ? CyberTheme.primary.withValues(alpha: 0.2)
                        : CyberTheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'PERMISSIONS',
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color:
                    isAdmin ? CyberTheme.primary : CyberTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCommands() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.link, size: 14),
          label: const Text('GENERATE_LINK'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.go('/chat');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('CHAT'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.go('/currencies');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(
                    color: CyberTheme.primary.withValues(alpha: 0.2),
                  ),
                  foregroundColor: CyberTheme.primary,
                ),
                child: const Text('SYNC_NODES\n'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightAxis(bool isDesktop) {
    return Column(
      children: [
        _buildAIStrategist(isDesktop),
        const SizedBox(height: 32),
        _buildSecureChannel(),
      ],
    );
  }

  Widget _buildAIStrategist(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: CyberTheme.surfaceContainerLowest,
        border: Border.all(
          color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [CyberTheme.primaryContainer, CyberTheme.primary],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        color: CyberTheme.onPrimaryContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'SYSTEM_INSIGHT_AI',
                          style: GoogleFonts.getFont(
                            'Space Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: CyberTheme.onPrimaryContainer,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                      'ANALYZING_FLUX...',
                      style: CyberTheme.monoFont(
                        fontSize: 10,
                        color: CyberTheme.onPrimaryContainer.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fadeOut(duration: 800.ms),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isDesktop
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SECTOR OPTIMIZATION',
                                style: CyberTheme.monoFont(
                                  fontSize: 10,
                                  letterSpacing: 2.0,
                                  color: CyberTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.getFont(
                                    'Space Grotesk',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w300,
                                    color: CyberTheme.onSurface,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Optimize Sector: '),
                                    TextSpan(
                                      text: 'Food',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Cross-entity spending on 'Dining' exceeds threshold by 14.2%. Recommend consolidated grocery procurement at Node_Alpha.",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: CyberTheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(child: _buildEnergyEfficiencyCard()),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SECTOR OPTIMIZATION',
                          style: CyberTheme.monoFont(
                            fontSize: 10,
                            letterSpacing: 2.0,
                            color: CyberTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.getFont(
                              'Space Grotesk',
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: CyberTheme.onSurface,
                            ),
                            children: const [
                              TextSpan(text: 'Optimize Sector: '),
                              TextSpan(
                                text: 'Food',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Cross-entity spending on 'Dining' exceeds threshold by 14.2%. Recommend consolidated grocery procurement at Node_Alpha.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: CyberTheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildEnergyEfficiencyCard(),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyEfficiencyCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: CyberTheme.surfaceContainerLow,
            border: Border(
              left: BorderSide(color: CyberTheme.primary, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: CyberTheme.monoFont(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CyberTheme.primary,
                    letterSpacing: -1,
                  ),
                  children: const [
                    TextSpan(text: 'Energy Efficiency '),
                    TextSpan(text: '+12%', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PROJECTED SAVINGS: 420.00 UNITS/MO',
                style: CyberTheme.monoFont(
                  fontSize: 10,
                  color: CyberTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecureChannel() {
    return Container(
      height: 400,
      color: CyberTheme.surfaceContainerLow,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                Row(
                  children: [
                    const Icon(
                      Icons.terminal,
                      color: CyberTheme.onSurfaceVariant,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SECURE_CHANNEL',
                      style: GoogleFonts.getFont(
                        'Space Grotesk',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: CyberTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 8, height: 8, color: CyberTheme.primary),
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      color: CyberTheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 8,
                      height: 8,
                      color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildChatMessage(
                  '[ADMIN_ROOT]',
                  '14:02:21',
                  'Authorized limit increase for Entity_01. Reviewing monthly velocity.',
                  true,
                  CyberTheme.primary,
                ),
                const SizedBox(height: 24),
                _buildChatMessage(
                  '[USER_01]',
                  '14:05:10',
                  'Adjusted grocery budget. Optimization applied.',
                  false,
                  CyberTheme.onSurfaceVariant,
                ),
                const SizedBox(height: 24),
                _buildChatMessage(
                  '[SYSTEM]',
                  '14:10:45',
                  'ALERT: SPENDING_THRESHOLD_REACHED at \'Sector: Energy\'',
                  true,
                  CyberTheme.primary,
                  isAlert: true,
                ),
              ],
            ),
          ),
          Container(
            color: CyberTheme.surfaceContainerLowest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  '>',
                  style: CyberTheme.monoFont(
                    fontSize: 12,
                    color: CyberTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: CyberTheme.monoFont(
                      fontSize: 12,
                      color: CyberTheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'COMMAND_INPUT...',
                      hintStyle: CyberTheme.monoFont(
                        fontSize: 12,
                        color: CyberTheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.send, color: CyberTheme.primary, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(
    String user,
    String time,
    String text,
    bool isLeft,
    Color color, {
    bool isAlert = false,
  }) {
    return Column(
      crossAxisAlignment:
          isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isLeft)
              Text(
                time,
                style: CyberTheme.monoFont(
                  fontSize: 10,
                  color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            if (!isLeft) const SizedBox(width: 8),
            Text(user, style: CyberTheme.monoFont(fontSize: 10, color: color)),
            if (isLeft) const SizedBox(width: 8),
            if (isLeft)
              Text(
                time,
                style: CyberTheme.monoFont(
                  fontSize: 10,
                  color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isLeft
                    ? CyberTheme.surfaceContainerLowest
                    : CyberTheme.surfaceContainer,
            border: Border(
              left:
                  isLeft ? BorderSide(color: color, width: 1) : BorderSide.none,
              right:
                  !isLeft
                      ? BorderSide(
                        color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
                        width: 1,
                      )
                      : BorderSide.none,
              top:
                  !isLeft
                      ? BorderSide(
                        color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
                        width: 1,
                      )
                      : BorderSide.none,
              bottom:
                  !isLeft
                      ? BorderSide(
                        color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
                        width: 1,
                      )
                      : BorderSide.none,
            ),
          ),
          child: Text(
            text,
            style: CyberTheme.monoFont(
              fontSize: 12,
              color: isAlert ? color : CyberTheme.onSurface,
              decoration:
                  !isLeft
                      ? TextDecoration.none
                      : TextDecoration
                          .none, // placeholder for standard text style
            ),
          ),
        ),
      ],
    );
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
                if (_accounts.contains(name)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account already exists.')),
                  );
                  return;
                }

                setState(() {
                  _accounts.add(name);
                  _activeAccount = name;
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
}

import 'package:expense_app/data/data_parse.dart';
import 'package:expense_app/data/expense_model.dart';
import 'package:expense_app/widgets/currencies.dart';
import 'package:expense_app/widgets/currency_tile.dart';
import 'package:expense_app/widgets/customize_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path/path.dart';
import '../core/theme.dart';
import '../data/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //customized appbar Parameters
  late AccountModel g_activeAccount;
  late int activeAccountindex = 1;
  bool createLoading = false;

  Map<String, String>? _selected;
  Map<String, String> currentSelection = kCurrencies[0];

  void _select(int index, BuildContext context) {
    HapticFeedback.selectionClick();
    setState(() {
      currentSelection = kCurrencies[index];
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    g_activeAccount = DataParse.accountData;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomizedAppBar(
        ActivePage: 4,
        g_activeAccount: g_activeAccount,
        SubmitSelectedAccount: SubmitSelectedAccount,
        createLoading: loadNewAccount,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 20.0,
          bottom: 20.0,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 896),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 64),
                _buildSettingsGrid(context),
                const SizedBox(height: 96),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: CyberTheme.surfaceContainerLow,
            border: Border.all(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              Container(color: CyberTheme.primary.withValues(alpha: 0.1)),
              Positioned(
                bottom: -8,
                right: -8, // Actually just attach to bottom right
                child: Container(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ELI',
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: CyberTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: CyberTheme.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: CyberTheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: CyberTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'VERIFIED',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: CyberTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 48,
      mainAxisSpacing: 64,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildSystemParameters(context)
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: 0.1, end: 0),
        _buildSecurityAccess()
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.1, end: 0),
        _buildDataManagement()
            .animate()
            .fadeIn(duration: 400.ms, delay: 300.ms)
            .slideY(begin: 0.1, end: 0),
        _buildAboutSystem()
            .animate()
            .fadeIn(duration: 400.ms, delay: 400.ms)
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.getFont(
              'Space Grotesk',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: CyberTheme.primary,
            ),
          ),
          Text(
            '--',
            style: CyberTheme.monoFont(
              fontSize: 10,
              color: CyberTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemParameters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('System ', '01/04'),
        _buildToggleSetting('Protocols', 'Global', false),
        const SizedBox(height: 20),
        _buildValueSetting(
          context,
          'Base Currency',
          'Transaction denomination',
        ),
        const SizedBox(height: 20),
        _buildToggleSetting('Dark Protocol', 'OLED-optimized interface', true),
      ],
    );
  }

  Widget _buildSecurityAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Security', '02/04'),
        _buildActionSetting(
          'Biometric Lock',
          'authentication',
          Icons.fingerprint,
          false,
        ),
        const SizedBox(height: 24),
        _buildActionSetting(
          'Encryption',
          'AES-256 standard active',
          Icons.lock,
          true,
        ),
        const SizedBox(height: 24),
        _buildActionSetting('Identity keys', 'Manage ', Icons.key, false),
      ],
    );
  }

  Widget _buildDataManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Data Management', '03/04'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CyberTheme.surfaceContainerLow,
            border: Border.all(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPORT LEDGER',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: CyberTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'GENERATE .CSV FORMAT',
                    style: CyberTheme.monoFont(
                      fontSize: 10,
                      color: CyberTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.download, color: CyberTheme.onSurfaceVariant),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: CyberTheme.error.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PURGE LOCAL DATABASE',
                    style: GoogleFonts.getFont(
                      'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: CyberTheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IRREVERSIBLE ACTION',
                    style: CyberTheme.monoFont(
                      fontSize: 10,
                      color: CyberTheme.error.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.delete_forever, color: CyberTheme.error),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSystem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About System', '04/04'),
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              color: CyberTheme.primary,
              child: const Icon(
                Icons.code,
                color: CyberTheme.onPrimary,
                size: 36,
              ),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM VERSION',
                  style: GoogleFonts.getFont(
                    'Space Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: CyberTheme.onSurface,
                  ),
                ),
                Text(
                  'v1.0.42',
                  style: CyberTheme.monoFont(
                    fontSize: 24,
                    color: CyberTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CyberTheme.outlineVariant.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLink('Privacy Disclosure'),
              const SizedBox(height: 12),
              _buildLink('Neural License Agreement'),
              const SizedBox(height: 12),
              _buildLink('Terminal Documentation'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting(String title, String subtitle, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                color: CyberTheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 20,
          decoration:
              isActive
                  ? BoxDecoration(
                    color: CyberTheme.primary.withValues(alpha: 0.2),
                    border: Border.all(
                      color: CyberTheme.primary.withValues(alpha: 0.4),
                    ),
                  )
                  : BoxDecoration(
                    color: CyberTheme.surfaceContainerHighest,
                    border: Border.all(
                      color: CyberTheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
          alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.all(4),
          child: Container(width: 12, height: 12, color: CyberTheme.primary),
        ),
      ],
    );
  }

  Future<String?> openCyberListDialog(BuildContext context) {
    // discurrency

    return showDialog<String>(
      context: context,
      barrierColor: const Color(0xFF080808).withOpacity(0.85),
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF2D2D2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: Color(0xFFBF00FF), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Title
                Text(
                  "Select Currency",
                  style: const TextStyle(
                    color: Color(0xFFBF00FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 List
                SizedBox(
                  height: 360,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: kCurrencies.length,
                    itemBuilder: (context, index) {
                      final c = kCurrencies[index];
                      final bool isactive =
                          currentSelection['code'] == c['code'];
                      final bool isLast = index == kCurrencies.length - 1;

                      return CurrencyTile(
                        index: index,
                        currency: c,
                        isActive: isactive,
                        isLast: isLast,
                        onTap: () => _select(index, context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueSetting(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return InkWell(
      onTap: () {
        openCyberListDialog(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.getFont(
                  'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                  color: CyberTheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          Text(
            currentSelection['code'].toString(),
            style: CyberTheme.monoFont(
              fontSize: 14,
              letterSpacing: 2.0,
              color: CyberTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencySelector() => GestureDetector(
    onTap: () {
      // _openCurrencyDialog(context);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kVoid,
        border: Border.all(color: kNeonDim),
      ),
      child: Row(
        children: [
          Icon(
            Icons.currency_exchange,
            size: 16,
            color: kNeon.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                _selected == null
                    ? Text(
                      'SELECT CURRENCY',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.2),
                        letterSpacing: 1,
                      ),
                    )
                    : Row(
                      children: [
                        Text(
                          _selected!['symbol']!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16,
                            color: kNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _selected!['code']!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${_selected!['name']}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: kNeon.withOpacity(0.6),
            size: 18,
          ),
        ],
      ),
    ),
  );

  Future<void> _openCurrencyDialog(context) async {
    debugPrint("################ check currency ");
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) => CurrencyDialog(currentSelection: _selected),
    );
    if (result != null) setState(() => _selected = result);
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    bool activeIcon,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: GoogleFonts.getFont(
                'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                color: CyberTheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        Icon(
          icon,
          color: activeIcon ? CyberTheme.primary : CyberTheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildLink(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.getFont(
        'Space Grotesk',
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
        color: CyberTheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFooterItem('Uptime', '99.982%'),
          _buildFooterItem('Connection', 'ENCRYPTED_TUNNEL'),
          _buildFooterItem('Latency', '12ms'),
          _buildFooterItem('Last_Sync', '2024.05.21_14:22'),
        ],
      ),
    );
  }

  Widget _buildFooterItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: CyberTheme.monoFont(
            fontSize: 10,
            color: CyberTheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: CyberTheme.monoFont(fontSize: 12, color: CyberTheme.primary),
        ),
      ],
    );
  }

  //Just Functions
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
}

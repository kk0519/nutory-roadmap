import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          const _SectionHeader('目標'),
          _SettingsTile(icon: Icons.local_fire_department, title: 'カロリー目標', subtitle: '2,000 kcal', onTap: () {}),
          _SettingsTile(icon: Icons.fitness_center, title: 'たんぱく質目標', subtitle: '80 g', onTap: () {}),
          const _SectionHeader('アカウント'),
          _SettingsTile(icon: Icons.person_outline, title: 'プロフィール', onTap: () {}),
          _SettingsTile(icon: Icons.link, title: '連携サービス', subtitle: 'PayPay / 楽天ポイント', onTap: () {}),
          const _SectionHeader('その他'),
          const _SettingsTile(icon: Icons.info_outline, title: 'バージョン', subtitle: '0.1.0'),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(title, style: const TextStyle(color: AppTheme.muted, fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.accent),
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: AppTheme.muted)) : null,
    trailing: onTap != null ? const Icon(Icons.chevron_right, color: AppTheme.muted) : null,
    onTap: onTap,
  );
}

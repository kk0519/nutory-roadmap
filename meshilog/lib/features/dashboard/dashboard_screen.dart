import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../utils/theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const caloriesConsumed = 1450.0;
    const caloriesTarget = 2000.0;
    const progress = caloriesConsumed / caloriesTarget;

    return Scaffold(
      appBar: AppBar(title: const Text('今日の記録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _CalorieRing(progress: progress, consumed: caloriesConsumed, target: caloriesTarget),
            const SizedBox(height: 24),
            const _PfcBars(protein: 72, fat: 48, carbs: 180, proteinTarget: 80, fatTarget: 65, carbsTarget: 250),
            const SizedBox(height: 24),
            const _TodayMeals(),
          ],
        ),
      ),
    );
  }
}

class _CalorieRing extends StatelessWidget {
  final double progress;
  final double consumed;
  final double target;

  const _CalorieRing({required this.progress, required this.consumed, required this.target});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: CircularPercentIndicator(
          radius: 90,
          lineWidth: 14,
          percent: progress.clamp(0.0, 1.0),
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${consumed.toInt()}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const Text('kcal', style: TextStyle(color: AppTheme.muted)),
              Text('/ ${target.toInt()}', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
            ],
          ),
          progressColor: AppTheme.accent,
          backgroundColor: AppTheme.background,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ),
    );
  }
}

class _PfcBars extends StatelessWidget {
  final double protein, fat, carbs;
  final double proteinTarget, fatTarget, carbsTarget;

  const _PfcBars({
    required this.protein, required this.fat, required this.carbs,
    required this.proteinTarget, required this.fatTarget, required this.carbsTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _PfcRow('たんぱく質', protein, proteinTarget, AppTheme.accent),
            const SizedBox(height: 12),
            _PfcRow('脂質', fat, fatTarget, AppTheme.orange),
            const SizedBox(height: 12),
            _PfcRow('炭水化物', carbs, carbsTarget, const Color(0xFF60A5FA)),
          ],
        ),
      ),
    );
  }
}

class _PfcRow extends StatelessWidget {
  final String label;
  final double value, target;
  final Color color;

  const _PfcRow(this.label, this.value, this.target, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
            Text('${value.toInt()}g / ${target.toInt()}g', style: const TextStyle(fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (value / target).clamp(0.0, 1.0),
          color: color,
          backgroundColor: AppTheme.background,
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
      ],
    );
  }
}

class _TodayMeals extends StatelessWidget {
  const _TodayMeals();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('今日の食事', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('まだ記録がありません', style: TextStyle(color: AppTheme.muted)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

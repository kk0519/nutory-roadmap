import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('週次レポート')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _WeeklyCalorieChart(),
            SizedBox(height: 16),
            _PfcSummaryCard(),
          ],
        ),
      ),
    );
  }
}

class _WeeklyCalorieChart extends StatelessWidget {
  const _WeeklyCalorieChart();

  static const _days = ['月', '火', '水', '木', '金', '土', '日'];
  static const _data = [1800.0, 2100.0, 1650.0, 1900.0, 2200.0, 1750.0, 1980.0];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('週間カロリー', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 2500,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          _days[v.toInt()],
                          style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                        ),
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    7,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _data[i],
                          color: AppTheme.accent,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PfcSummaryCard extends StatelessWidget {
  const _PfcSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('今週の平均PFC', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PfcChip('P', '75g', AppTheme.accent),
                _PfcChip('F', '55g', AppTheme.orange),
                _PfcChip('C', '220g', Color(0xFF60A5FA)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PfcChip extends StatelessWidget {
  final String label, value;
  final Color color;

  const _PfcChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(
            child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

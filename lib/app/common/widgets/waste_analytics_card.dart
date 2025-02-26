import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class WasteAnalyticsCard extends StatelessWidget {
  final String totalWaste;
  final String weeklyWaste;
  final List<double> weeklyData; // Data 7 hari terakhir
  final VoidCallback? onTap;

  const WasteAnalyticsCard({
    Key? key,
    required this.totalWaste,
    required this.weeklyWaste,
    required this.weeklyData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Bagian summary (Hari ini vs Minggu ini)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Total Waste (Hari Ini)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hari Ini",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      totalWaste,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sampah",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),

                // Divider tipis di tengah (vertikal)
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey.withOpacity(0.4),
                ),

                // Weekly Waste
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Minggu Ini",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weeklyWaste,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sampah",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bagian Chart
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _generateBarData(weeklyData),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            meta.formattedValue,   // atau '${value.toInt()}'
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        // Tampilkan label "Day 1", "Day 2", dst.
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int idx = value.toInt(); // 0..6
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Day ${idx + 1}',
                              style: GoogleFonts.poppins(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat list BarChartGroupData
  List<BarChartGroupData> _generateBarData(List<double> weeklyData) {
    // weeklyData: misal [2.5, 1.0, 3.2, 0.0, 0.5, 2.0, 1.5]
    return List.generate(weeklyData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyData[index],
            width: 16,
            color: const Color(0xFF4CAF50), // warna hijau
          ),
        ],
      );
    });
  }
}

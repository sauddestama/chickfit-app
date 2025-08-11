import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiagnosisHistoryCard extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String resultText;

  const DiagnosisHistoryCard({
    super.key,
    required this.title,
    required this.timeAgo,
    required this.resultText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: AssetColors.black),
                  const SizedBox(width: 4),
                  Text(timeAgo,
                      style: const TextStyle(
                          color: AssetColors.black, fontSize: 14)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),

          // Diagnosis Result
          Row(
            children: [
              const Text("Hasil: "),
              Text(
                resultText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/diagnose_chat.svg",
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Konsultasi'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/resep.svg",
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Resep'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

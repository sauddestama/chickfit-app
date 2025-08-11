import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class ChipSelectionWidget extends StatefulWidget {
  const ChipSelectionWidget({Key? key}) : super(key: key);

  @override
  State<ChipSelectionWidget> createState() => _ChipSelectionWidgetState();
}

class _ChipSelectionWidgetState extends State<ChipSelectionWidget> {
  int selectedIndex = 0;

  final List<String> chipLabels = [
    'Semua',
    'Nutrisi',
    'Kesehatan',
    'Perawatan',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chipLabels.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AssetColors.primaryMain
                      : AssetColors.unselectedChipColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    chipLabels[index],
                    style: TextStyle(
                      color: isSelected ? AssetColors.white : AssetColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Alternative implementation using Flutter's built-in ChoiceChip
class ChipSelectionAlternative extends StatefulWidget {
  const ChipSelectionAlternative({Key? key}) : super(key: key);

  @override
  State<ChipSelectionAlternative> createState() =>
      _ChipSelectionAlternativeState();
}

class _ChipSelectionAlternativeState extends State<ChipSelectionAlternative> {
  int selectedIndex = 0;

  final List<String> chipLabels = [
    'Semua',
    'Nutrisi',
    'Kesehatan',
    'Perawatan',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chipLabels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(
                chipLabels[index],
                style: TextStyle(
                  color: AssetColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = selected ? index : selectedIndex;
                });
              },
              selectedColor: AssetColors.primaryMain,
              backgroundColor: AssetColors.unselectedChipColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }
}

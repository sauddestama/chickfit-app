import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool paidReceipt;
  final double? fontSize;
  const StatusBadge(
      {Key? key,
      required this.status,
      required this.paidReceipt,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: statusColor),
      child: Text(
        statusText,
        style: TextStyle(
            fontSize: fontSize ?? 10,
            color: textColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  String get statusText {
    if (status.toLowerCase() == 'pending') {
      return "Menunggu Konfirmasi";
    }
    if (status.toLowerCase() == 'processed') {
      return "Diproses";
    }
    if (status.toLowerCase() == 'waiting payment' && !paidReceipt) {
      return 'Menunggu Pembayaran';
    }
    if (status.toLowerCase() == 'waiting payment' && paidReceipt) {
      return 'Verifikasi Pembayaran';
    }
    return 'Dikirim';
  }

  Color get statusColor {
    if (status.toLowerCase() == 'pending') {
      return AssetColors.colorYellow;
    }
    if (status.toLowerCase() == 'processed') {
      return AssetColors.colorYellow;
    }
    if (status.toLowerCase() == 'waiting payment' && !paidReceipt) {
      return AssetColors.colorOrange;
    }
    if (status.toLowerCase() == 'waiting payment' && paidReceipt) {
      return AssetColors.colorYellow;
    }
    return AssetColors.colorGreen;
  }

  Color get textColor {
    if (status.toLowerCase() == 'pending') {
      return AssetColors.colorOrange;
    }
    if (status.toLowerCase() == 'processed') {
      return AssetColors.colorOrange;
    }
    if (status.toLowerCase() == 'waiting payment') {
      return Colors.white;
    }
    if (status.toLowerCase() == 'waiting payment' && paidReceipt) {
      return AssetColors.colorOrange;
    }
    return Colors.white;
  }
}

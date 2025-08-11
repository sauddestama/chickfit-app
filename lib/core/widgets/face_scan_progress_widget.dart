import 'dart:math';

import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/utils/logging_util.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:flutter/material.dart';

class FaceScanProgressWidget extends StatelessWidget {
  final int totalProgress;
  final int progress;

  const FaceScanProgressWidget({
    super.key,
    required this.totalProgress,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: (progress + 1) / totalProgress,
        end: progress / totalProgress,
      ),
      duration: const Duration(milliseconds: 500),
      builder: (context, animatedProgress, child) {
        return CustomPaint(
          size: Size(
            SizeUtil.getScreenWidth,
            SizeUtil.getScreenHeight,
          ),
          painter: CircularProgressPainter(
              progress: progress != 0 ? animatedProgress : 0,
              progressColor: AssetColors.primaryMain,
              strokeWidth: 6.ds,
              timerProgress: progress.toDouble()),
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;
  final double timerProgress;
  CircularProgressPainter({
    required this.progress,
    required this.timerProgress,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final circleWidth = size.width / 1.5;

    final double innerRadius =
        circleWidth / 2; // Lingkaran transparan di tengah
    final Offset center = Offset(size.width / 2, size.width / 2);
    final double arcRadius =
        innerRadius + strokeWidth / 2; // Untuk progress arc

    // Step 1: Buat area luar yang akan diwarnai putih
    Path outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Step 2: Buat lubang transparan di tengah
    Path transparentHole = Path()
      ..addOval(Rect.fromCircle(center: center, radius: innerRadius));

    // Step 3: Gabungkan → putih hanya di sekitar lingkaran tengah
    Path clippedPath =
        Path.combine(PathOperation.difference, outerPath, transparentHole);

    // Step 4: Warnai background putih di luar lingkaran transparan
    canvas.save();
    canvas.clipPath(clippedPath);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );
    canvas.restore();

    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = progressColor,
    );

    // Step 5: Gambar progress arc sebagai border luar
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      -pi / 2,
      -2 * pi * progress,
      false,
      progressPaint,
    );

    var text = "";
    LogUtil.info("TES timer $timerProgress");
    if (timerProgress >= 14) {
      text = "Make sure your face is clearly visible.";
    } else if (timerProgress >= 12) {
      text = "Please blink your eyes.";
    } else if (timerProgress >= 10) {
      text = "Please look to your right.";
    } else if (timerProgress >= 7) {
      text = "Please look to your left.";
    } else if (timerProgress >= 4) {
      text = "Please look up.";
    } else if (timerProgress >= 2) {
      text = "Please look down.";
    } else {
      text = "Make sure your face is clearly visible.";
    }

    // Step 6: Draw text below the circle
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final textX = (size.width - textPainter.width) / 2;
    final textY =
        center.dy + innerRadius + 16; // 16 is the padding below circle

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

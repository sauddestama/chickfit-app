import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:flutter/material.dart';

class ArticleCardWidget extends StatelessWidget {
  final double? width;
  final double? imageHeight;
  final EdgeInsetsGeometry? cardMargin;
  const ArticleCardWidget({
    super.key,
    this.width,
    this.imageHeight,
    this.cardMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? SizeUtil.getScreenWidth * 0.8,
      margin: cardMargin ?? EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              'https://www.putraperkasa.co.id/wp-content/uploads/2022/02/Cara-Ternak-Ayam-Potong-dari-Persiapan-Hingga-Panen.jpg',
              height: imageHeight ?? SizeUtil.getScreenWidth * 0.8 * 1 / 3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tips Merawat Ayam Sehat",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  "Panduan lengkap untuk menjaga kesehatan ayam petelur dan broiler",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text("2 jam yang lalu • 5 menit baca",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    SizedBox(
                      height: 36,
                      child: ButtonPrimary(
                        text: "Baca",
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

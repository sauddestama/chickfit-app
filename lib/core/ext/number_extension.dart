import 'package:chickfit/core/resources/asset_sizes.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:intl/intl.dart';

extension NumberX on num {
  double get ds {
    double width = SizeUtil.getScreenWidth;
    double scale = width / AssetSizes.defaultScreenWidth;
    return this * scale;
  }

  String toThousandFormat({
    String separator = '.',
  }) {
    String numStr = toString();
    String formattedStr = '';

    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      formattedStr = numStr[i] + formattedStr;
      if (count % 3 == 0 && i != 0) {
        formattedStr = '$separator$formattedStr';
      }
    }

    return formattedStr;
  }

  String toRupiahFormat({bool isSpaced = false, String? symbol}) {
    final amount = this;

    NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol ?? (isSpaced ? 'Rp ' : 'Rp'),
      decimalDigits: 0,
    );

    return currencyFormat.format(amount);
  }

  bool isLastIndex(List data) => this == data.length - 1;
}

import 'package:intl/intl.dart';

extension CurrencyExt on num {
  /// 299000 → "Rp 299.000"
  String get currencyFormatRp {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }

  /// 299000 → "299.000" (tanpa simbol)
  String get currencyFormat {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(this);
  }
}

extension StringCurrencyExt on String {
  /// "299000.00" (dari API) → "Rp 299.000"
  String get toRupiah {
    final value = double.tryParse(this) ?? 0;
    return value.currencyFormatRp;
  }

  /// "299000.00" → 299000.0
  double get toPrice => double.tryParse(this) ?? 0;
}

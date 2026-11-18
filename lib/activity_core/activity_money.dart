import '../trippl_activities_mobile.dart';

class ActivityAmounts {
  static int power(int decimals) {
    if (decimals < 0 || decimals > 4)
      throw const FormatException('Unsupported currency precision');
    var result = 1;
    for (var i = 0; i < decimals; i++) result *= 10;
    return result;
  }

  /// Parses a decimal amount using an explicit decimal separator. Grouping
  /// separators are not guessed; the provider should supply minor units.
  static ActivityMoney parse(
    String value, {
    required String currency,
    int decimals = 2,
    String separator = '.',
  }) {
    if (!{'.', ','}.contains(separator) || value.length > 30)
      throw const FormatException('Invalid money input');
    final pattern = separator == '.' ? r'^\d+(?:\.\d+)?$' : r'^\d+(?:,\d+)?$';
    if (!RegExp(pattern).hasMatch(value))
      throw const FormatException('Money requires an unsigned decimal amount');
    final parts = value.split(separator),
        fraction = parts.length == 2 ? parts[1] : '';
    if (fraction.length > decimals)
      throw const FormatException('Money has excess fractional precision');
    final whole = int.tryParse(parts[0]);
    if (whole == null)
      throw const FormatException('Money amount exceeds range');
    final result = ActivityMoney(
      currency: currency,
      amountMinor:
          whole * power(decimals) +
          (fraction.isEmpty ? 0 : int.parse(fraction.padRight(decimals, '0'))),
      decimals: decimals,
    );
    ActivityGuard.record(result.validate());
    return result;
  }

  static void compatible(ActivityMoney a, ActivityMoney b) {
    ActivityGuard.record(a.validate());
    ActivityGuard.record(b.validate());
    if (a.currency != b.currency || a.decimals != b.decimals)
      throw const FormatException('Cannot combine currencies or precision');
  }

  static ActivityMoney add(ActivityMoney a, ActivityMoney b) {
    compatible(a, b);
    final next = a.copyWith(amountMinor: a.amountMinor + b.amountMinor);
    ActivityGuard.record(next.validate());
    return next;
  }

  static ActivityMoney multiply(ActivityMoney value, int quantity) {
    ActivityGuard.record(value.validate());
    if (quantity < 0 || quantity > 100)
      throw const FormatException('Invalid money quantity');
    final next = value.copyWith(amountMinor: value.amountMinor * quantity);
    ActivityGuard.record(next.validate());
    return next;
  }

  static ActivityMoney subtract(ActivityMoney a, ActivityMoney b) {
    compatible(a, b);
    if (b.amountMinor > a.amountMinor)
      throw const FormatException('Discount exceeds activity amount');
    return a.copyWith(amountMinor: a.amountMinor - b.amountMinor);
  }

  static ActivityMoney percent(ActivityMoney amount, int basisPoints) {
    ActivityGuard.record(amount.validate());
    if (basisPoints < 0 || basisPoints > 10000)
      throw const FormatException('Invalid refund percentage');
    // Divide first to keep intermediate arithmetic exact on the web runtime.
    final minor =
        (amount.amountMinor ~/ 10000) * basisPoints +
        ((amount.amountMinor % 10000) * basisPoints ~/ 10000);
    return amount.copyWith(amountMinor: minor);
  }

  static String format(ActivityMoney value, {String locale = 'en'}) {
    ActivityGuard.record(value.validate());
    final divisor = power(value.decimals);
    final whole = value.amountMinor ~/ divisor,
        fraction = value.amountMinor % divisor;
    final decimal = value.decimals == 0
        ? ''
        : (locale.startsWith('tr') ? ',' : '.') +
              fraction.toString().padLeft(value.decimals, '0');
    return '$whole$decimal ${value.currency}';
  }

  static String label(
    ActivityMoney? amount, {
    required String basis,
    String locale = 'en',
    bool indicative = true,
  }) {
    final tr = locale.startsWith('tr');
    if (amount == null) return tr ? 'Fiyat bilinmiyor' : 'Price unknown';
    final suffix = switch (basis) {
      'perPerson' => tr ? 'kişi başı' : 'per person',
      'perGroup' => tr ? 'grup başı' : 'per group',
      'perUnit' => tr ? 'birim başı' : 'per unit',
      _ => tr ? 'toplam' : 'total',
    };
    return '${indicative ? (tr ? 'Başlangıç: ' : 'From ') : ''}${format(amount, locale: locale)} / $suffix';
  }
}

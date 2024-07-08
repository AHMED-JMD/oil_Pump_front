import 'package:money_formatter/money_formatter.dart';

String myFormat (int number) {
  double convertedNum = number.toDouble();

  return  MoneyFormatter(
      amount: convertedNum
  ).output.withoutFractionDigits;
}

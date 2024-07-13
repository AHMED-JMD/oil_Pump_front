import 'package:money_formatter/money_formatter.dart';

String numberFormat (number) {
  double convertedNum = number.toDouble();

  return  MoneyFormatter(
      amount: convertedNum
  ).output.withoutFractionDigits;
}

String timeFormat (int number) {
  if(number < 10){
    return '0$number';
  }else{
    return '$number';
  }
}


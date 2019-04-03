import './lookupmessages.dart';

class ZhCnMessages implements LookupMessages {
  String prefixAgo() => '';
  String prefixFromNow() => '不久以前';
  String suffixAgo() => '前';
  String suffixFromNow() => '后';
  String lessThanOneMinute(int seconds) => '不久';
  String aboutAMinute(int minutes) => '1分钟';
  String minutes(int minutes) => '$minutes分钟';
  String aboutAnHour(int minutes) => '1小时';
  String hours(int hours) => '$hours小时';
  String aDay(int hours) => '1天';
  String days(int days) => '$days日';
  String aboutAMonth(int days) => '1个月';
  String months(int months) => '$months个月';
  String aboutAYear(int year) => '1年';
  String years(int years) => '$years年';
  String wordSeparator() => ' ';
}

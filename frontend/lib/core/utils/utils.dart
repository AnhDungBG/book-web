import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return 'Không có ngày xuất bản';
  return DateFormat('dd/MM/yyyy').format(date);
}

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File(r'C:/Users/omar7/.gemini/antigravity-ide/brain/0e025d4a-989a-4ea8-88f4-ed11b89d469b/.system_generated/steps/39/output.txt');
  final content = await file.readAsString();

  // Extract the JSON string from the untrusted data block
  final startToken = '<untrusted-data-e025b042-b038-4811-97d4-1dbf05429b88>\n';
  final endToken = '\n</untrusted-data-e025b042-b038-4811-97d4-1dbf05429b88>';
  
  var jsonStr = '';
  try {
    final parsedMap = jsonDecode(content);
    final resultStr = parsedMap['result'] as String;
    final startIndex = resultStr.indexOf(startToken) + startToken.length;
    final endIndex = resultStr.indexOf(endToken);
    jsonStr = endIndex != -1 ? resultStr.substring(startIndex, endIndex) : resultStr.substring(startIndex);
  } catch (e) {
    print('Error parsing initial JSON wrapper: $e');
    return;
  }

  List<dynamic> rows;
  try {
    rows = jsonDecode(jsonStr);
  } catch (e) {
    print('Error decoding SQL JSON: $e');
    return;
  }

  // Group by table_name
  final tables = <String, List<Map<String, dynamic>>>{};
  for (var row in rows) {
    final tName = row['table_name'] as String;
    if (!tables.containsKey(tName)) {
      tables[tName] = [];
    }
    tables[tName]!.add(row as Map<String, dynamic>);
  }

  final buffer = StringBuffer();
  buffer.writeln('''<html xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:w="urn:schemas-microsoft-com:office:word"
      xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta charset="utf-8">
<style>
  body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; direction: rtl; }
  table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
  th, td { border: 1px solid #000; padding: 8px; text-align: center; }
  th { background-color: #d9d9d9; font-weight: bold; }
  h1, h2, h3 { text-align: right; }
  .table-title { font-weight: bold; font-size: 18px; margin-bottom: 10px; text-align: right; }
</style>
</head>
<body>
<h1 style="text-align: center;">قاموس البيانات (Data Dictionary)</h1>
''');

  String generateDescription(String tableName, String columnName) {
    final lowerCol = columnName.toLowerCase();
    if (lowerCol == 'id' || lowerCol == '${tableName.toLowerCase()}_id') return 'المعرف الفريد (الرقم الأساسي)';
    if (lowerCol.contains('id_') || lowerCol.contains('_id')) return 'معرف مرتبط بجدول آخر (مفتاح أجنبي)';
    if (lowerCol.contains('name')) return 'الاسم';
    if (lowerCol.contains('email')) return 'البريد الإلكتروني';
    if (lowerCol.contains('phone') || lowerCol.contains('num')) return 'رقم الهاتف أو العدد';
    if (lowerCol.contains('date') || lowerCol.contains('created_at') || lowerCol.contains('updated_at')) return 'تاريخ ووقت الإجراء';
    if (lowerCol.contains('isactive') || lowerCol.contains('is_active')) return 'الحالة (نشط/غير نشط)';
    if (lowerCol.contains('status')) return 'حالة العنصر';
    if (lowerCol.contains('password') || lowerCol.contains('pass')) return 'كلمة المرور المشفرة';
    if (lowerCol.contains('image') || lowerCol.contains('url') || lowerCol.contains('pdf') || lowerCol.contains('file')) return 'رابط الملف أو الصورة';
    if (lowerCol.contains('desc')) return 'وصف تفصيلي';
    if (lowerCol.contains('title')) return 'العنوان';
    if (lowerCol.contains('grade') || lowerCol.contains('percentage')) return 'الدرجة أو النسبة المئوية';
    if (lowerCol.contains('note') || lowerCol.contains('comment')) return 'ملاحظات وتوجيهات';
    if (lowerCol.contains('approval')) return 'حالة الاعتماد أو الموافقة';
    if (lowerCol.contains('type')) return 'النوع أو التصنيف';
    if (lowerCol.contains('message') || lowerCol.contains('text') || lowerCol.contains('content')) return 'نص المحتوى أو الرسالة';
    if (lowerCol.contains('progress')) return 'مستوى التقدم والإنجاز';
    if (lowerCol.contains('read')) return 'حالة القراءة (مقروء/غير مقروء)';
    if (lowerCol.contains('archived')) return 'حالة الأرشفة';
    if (lowerCol.contains('username')) return 'اسم المستخدم';
    if (lowerCol.contains('stage')) return 'المرحلة الحالية';
    if (lowerCol.contains('role')) return 'الدور أو الصلاحية';
    
    return 'معلومات عن $columnName';
  }

  // Master Data Dictionary
  buffer.writeln('<h2>قاموس البيانات الشامل</h2>');
  buffer.writeln('<table>');
  buffer.writeln('<tr><th>الرقم</th><th>اسم العنصر</th><th>التوضيح</th><th>النوع</th><th>الحجم</th><th>المصدر</th><th>الحالة</th><th>التخزين</th><th>ملاحظات</th></tr>');
  
  int globalIndex = 1;
  for (var entry in tables.entries) {
    final tName = entry.key;
    for (var col in entry.value) {
      final colName = col['column_name'] ?? '';
      final colDesc = col['column_description'] ?? generateDescription(tName, colName);
      final dataType = col['data_type'] ?? '';
      final charLen = col['character_maximum_length']?.toString() ?? 'متغير';
      final constraint = col['constraint_type'] ?? (col['is_nullable'] == 'NO' ? 'مطلوب' : 'اختياري');
      
      String status = constraint;
      if (constraint == 'PRIMARY KEY') status = 'مفتاح رئيسي';
      if (constraint == 'FOREIGN KEY') status = 'مفتاح ثانوي';

      buffer.writeln('<tr>');
      buffer.writeln('<td>${globalIndex++}</td>');
      buffer.writeln('<td>$colName</td>');
      buffer.writeln('<td>$colDesc</td>');
      buffer.writeln('<td>$dataType</td>');
      buffer.writeln('<td>$charLen</td>');
      buffer.writeln('<td>إدخال / تلقائي</td>');
      buffer.writeln('<td>$status</td>');
      buffer.writeln('<td>في جدول $tName</td>');
      buffer.writeln('<td></td>');
      buffer.writeln('</tr>');
    }
  }
  buffer.writeln('</table><br><br>');

  // Individual Tables
  int tableIndex = 1;
  for (var entry in tables.entries) {
    final tName = entry.key;
    buffer.writeln('<div class="table-title">$tableIndex. جدول ($tName):</div>');
    buffer.writeln('<div style="text-align:center; margin-bottom: 5px;">(الجدول التالي: $tName)</div>');
    buffer.writeln('<table>');
    buffer.writeln('<tr><th>اسم الحقل</th><th>الوصف</th><th>النوع</th><th>القيود</th></tr>');
    
    for (var col in entry.value) {
      final colName = col['column_name'] ?? '';
      final colDesc = col['column_description'] ?? generateDescription(tName, colName);
      final dataType = col['data_type'] ?? '';
      final constraint = col['constraint_type'] ?? (col['is_nullable'] == 'NO' ? 'NOTNULL' : '');
      
      String consStr = constraint;
      if (constraint == 'PRIMARY KEY') consStr = 'PK';
      if (constraint == 'FOREIGN KEY') consStr = 'FK';

      buffer.writeln('<tr>');
      buffer.writeln('<td>$colName</td>');
      buffer.writeln('<td>$colDesc</td>');
      buffer.writeln('<td>$dataType</td>');
      buffer.writeln('<td>$consStr</td>');
      buffer.writeln('</tr>');
    }
    buffer.writeln('</table><br>');
    tableIndex++;
  }

  buffer.writeln('</body></html>');

  final outFile = File('قاموس_البيانات.doc');
  await outFile.writeAsString(buffer.toString());
  print('Doc generated at \${outFile.absolute.path}');
}

// ignore_for_file: avoid_print

import 'package:supabase/supabase.dart';

Future<void> main() async {
  final client = SupabaseClient(
    'https://quakwoghhxoobcgcknsj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1YWt3b2doaHhvb2JjZ2NrbnNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0MjAyNTMsImV4cCI6MjA4MTk5NjI1M30.OYmQVRGhirs7cJDI64rRqQZss6RDnof8kABlZNQDHbA',
  );

  try {
    final response = await client.from('AcademyYear').select('acye_id, acye_year');
    print('AcademyYear data: $response');
    if ((response as List).isNotEmpty) {
      print('acye_id type: ${response[0]['acye_id'].runtimeType}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

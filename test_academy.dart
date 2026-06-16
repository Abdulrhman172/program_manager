// ignore_for_file: avoid_print

import 'package:supabase/supabase.dart';

Future<void> main() async {
  final client = SupabaseClient(
    'https://quakwoghhxoobcgcknsj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1YWt3b2doaHhvb2JjZ2NrbnNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0MjAyNTMsImV4cCI6MjA4MTk5NjI1M30.OYmQVRGhirs7cJDI64rRqQZss6RDnof8kABlZNQDHbA',
  );

  try {
    final response = await client.from('AcademyYear').select('*');
    print('AcademyYear: $response');
    
    // Test the type of id_academy_year
    if ((response as List).isNotEmpty) {
      print('Type of id_academy_year: ${response[0]['id_academy_year'].runtimeType}');
      print('Type of acye_year: ${response[0]['acye_year'].runtimeType}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

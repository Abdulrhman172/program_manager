// ignore_for_file: avoid_print

import 'package:supabase/supabase.dart';

Future<void> main() async {
  final client = SupabaseClient(
    'https://quakwoghhxoobcgcknsj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1YWt3b2doaHhvb2JjZ2NrbnNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0MjAyNTMsImV4cCI6MjA4MTk5NjI1M30.OYmQVRGhirs7cJDI64rRqQZss6RDnof8kABlZNQDHbA',
  );

  try {
    // Fetch supervisors table structure
    final response = await client.from('supervisor').select('*').limit(2);
    print('supervisor data: $response');
  } catch (e) {
    print('supervisor error: $e');
  }
  
  try {
    // Fetch ProgramManager table
    final response = await client.from('ProgramManager').select('*').limit(2);
    print('ProgramManager data: $response');
  } catch (e) {
    print('ProgramManager error: $e');
  }
}

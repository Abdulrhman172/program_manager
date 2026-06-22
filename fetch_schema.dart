// ignore_for_file: avoid_print
import 'package:supabase/supabase.dart';
Future<void> main() async {
  final client = SupabaseClient(
    'https://quakwoghhxoobcgcknsj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1YWt3b2doaHhvb2JjZ2NrbnNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0MjAyNTMsImV4cCI6MjA4MTk5NjI1M30.OYmQVRGhirs7cJDI64rRqQZss6RDnof8kABlZNQDHbA',
  );

  try {
    final groups = await client.from('groups').select('*').limit(1);
    print('groups data: $groups');
    
    final student = await client.from('student').select('*').limit(1);
    print('student data: $student');
    
    final supervisors = await client.from('supervisor').select('*').limit(1);
    print('supervisor data: $supervisors');
  } catch (e) {
    print('error: $e');
  }
}

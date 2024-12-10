


import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static final supabase = Supabase.instance.client;

  static final userService = supabase.from("profiles");
  
  static final serverService = supabase.from("servers_four");

  static final configService = supabase.from("config");

}
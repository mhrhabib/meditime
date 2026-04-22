/// Supabase project credentials.
///
/// Replace these values with your own Supabase project URL and anon key.
/// In production, load these via `--dart-define` so they stay out of source:
///
///   flutter run \
///     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///     --dart-define=SUPABASE_ANON_KEY=eyJ...
///
/// Then read them here with:
///   const _url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://kivsiaooojosyehjdmvh.supabase.co', // ← replace
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpdnNpYW9vb2pvc3llaGpkbXZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NDgyNTYsImV4cCI6MjA5MjQyNDI1Nn0.QtYpELroZhaim-cWA1Yx6s_YWBN1lUfmGl-ErvsEuGc', // ← replace
  );
}

class ApiConstants {
  static const String baseUrl = 'https://abivxrzvdszisfibzlxf.supabase.co';
  static const String publishableKey =
      'sb_publishable_tHLQG7LIyBZaRKiwPDL9lg_AS41HEYI';

  // Auth Endpoints
  static const String register = '/auth/v1/signup';
  static const String login = '/auth/v1/token?grant_type=password';

  // Database & RPC Endpoints
  static const String venues = '/rest/v1/venues';
  static const String bookings = '/rest/v1/bookings';
  static const String getAvailableVenues = '/rest/v1/rpc/get_available_venues';
}

// to avoid hardcode in repo 
// make variables able to change

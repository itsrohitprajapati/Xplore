import 'dart:convert';
import 'package:http/http.dart' as http;

/// A single place result from the Places API.
class NearbyPlace {
  const NearbyPlace({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.address,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? address;

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final displayName = json['displayName'] as Map<String, dynamic>? ?? {};
    return NearbyPlace(
      name: displayName['text'] as String? ?? 'Unnamed place',
      latitude: (location['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (location['longitude'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble(),
      address: json['formattedAddress'] as String?,
    );
  }
}

/// Category filters shown on the map, mapped to Google Places (New)
/// "included type" values. See the full type table here:
/// https://developers.google.com/maps/documentation/places/web-service/place-types
enum PlaceCategory {
  restaurants('Restaurants', ['restaurant', 'cafe']),
  adventure('Adventure', ['tourist_attraction', 'park', 'hiking_area']),
  sightseeing('Sightseeing', ['tourist_attraction', 'historical_landmark', 'museum']);

  const PlaceCategory(this.label, this.includedTypes);
  final String label;
  final List<String> includedTypes;
}

/// Thin wrapper around the Places API (New) `searchNearby` endpoint.
///
/// Setup required:
/// 1. In Google Cloud Console, enable "Places API (New)" for your project.
/// 2. Create/restrict an API key for it (see map_screen_demo.dart header
///    for full Android/iOS setup — the same key is reused for both the
///    map SDK and this REST call).
///
/// Usage:
/// ```dart
/// final service = GooglePlacesService(apiKey: 'YOUR_KEY');
/// final places = await service.searchNearby(
///   latitude: 28.6139,
///   longitude: 77.2090,
///   category: PlaceCategory.restaurants,
///   radiusMeters: 3000,
/// );
/// ```
class GooglePlacesService {
  GooglePlacesService({required this.apiKey});

  final String apiKey;

  static const _endpoint = 'https://places.googleapis.com/v1/places:searchNearby';

  Future<List<NearbyPlace>> searchNearby({
    required double latitude,
    required double longitude,
    required PlaceCategory category,
    double radiusMeters = 3000,
    int maxResults = 20,
  }) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        // Field mask keeps the response (and your bill) small — only ask
        // for what you actually use.
        'X-Goog-FieldMask':
            'places.displayName,places.location,places.rating,places.formattedAddress',
      },
      body: jsonEncode({
        'includedTypes': category.includedTypes,
        'maxResultCount': maxResults,
        'locationRestriction': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': radiusMeters,
          },
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Places API error ${response.statusCode}: ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['places'] as List<dynamic>? ?? [];
    return results
        .map((p) => NearbyPlace.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}

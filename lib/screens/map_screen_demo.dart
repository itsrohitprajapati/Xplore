import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/google_places_service.dart';
import '../widgets/neo_widgets.dart';

/// ---------------------------------------------------------------------
/// PUT YOUR API KEY HERE for the Places nearby-search REST call.
/// This is separate from (but usually the same value as) the key you put
/// in AndroidManifest.xml / AppDelegate.swift for the map tiles themselves
/// — see setup notes below.
/// ---------------------------------------------------------------------
const String _googlePlacesApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

/// Map tab — Google Map centered on the user's current location, with
/// category chips (Restaurants / Adventure / Monuments) that fetch nearby
/// places via the Places API (New) and drop them on the map as markers.
///
/// Add to pubspec.yaml:
/// ```yaml
/// dependencies:
///   google_maps_flutter: ^2.9.0
///   geolocator: ^13.0.1
///   http: ^1.2.2
/// ```
///
/// --- One-time Google Cloud setup ---
/// 1. Create/open a project at https://console.cloud.google.com
/// 2. Enable these APIs: "Maps SDK for Android", "Maps SDK for iOS",
///    "Places API (New)".
/// 3. Create an API key (APIs & Services > Credentials). For production,
///    restrict it: Android key restricted by package name + SHA-1,
///    iOS key restricted by bundle ID.
/// 4. Enable billing on the project — Google Maps/Places requires a
///    billing account even within the free monthly usage tier.
///
/// --- Android setup ---
/// android/app/src/main/AndroidManifest.xml, inside <application>:
/// ```xml
/// <meta-data
///     android:name="com.google.android.geo.API_KEY"
///     android:value="YOUR_GOOGLE_MAPS_API_KEY" />
/// ```
/// Also make sure minSdkVersion is at least 20 in android/app/build.gradle.
///
/// --- iOS setup ---
/// ios/Runner/AppDelegate.swift, add before `return super...`:
/// ```swift
/// import GoogleMaps
/// GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
/// ```
/// (Keep the existing NSLocationWhenInUseUsageDescription entry in
/// Info.plist from the earlier location setup — still required.)
///
/// Usage:
/// ```dart
/// const MapScreenDemo()
/// ```
class MapScreenDemo extends StatefulWidget {
  const MapScreenDemo({super.key});

  @override
  State<MapScreenDemo> createState() => _MapScreenDemoState();
}

enum _LocationStatus { loading, ready, servicesDisabled, permissionDenied, error }

class _MapScreenDemoState extends State<MapScreenDemo> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;
  final _placesService = GooglePlacesService(apiKey: _googlePlacesApiKey);

  _LocationStatus _status = _LocationStatus.loading;
  Position? _position;
  String? _errorMessage;

  PlaceCategory? _selectedCategory;
  bool _loadingPlaces = false;
  Set<Marker> _placeMarkers = {};

  static const double _defaultZoom = 15.5;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    setState(() => _status = _LocationStatus.loading);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _status = _LocationStatus.servicesDisabled);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _status = _LocationStatus.permissionDenied);
      return;
    }

    try {
      // Try a fast last-known position first — usually instant, and good
      // enough to render the map immediately instead of staring at a
      // spinner while waiting for a fresh GPS fix.
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        setState(() {
          _position = lastKnown;
          _status = _LocationStatus.ready;
        });
      }

      // Now get a fresh, accurate fix — but with a hard timeout so this
      // can never hang indefinitely (e.g. indoors with no GPS signal).
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      setState(() {
        _position = position;
        _status = _LocationStatus.ready;
      });
      _startWatching();
    } on TimeoutException {
      if (!mounted) return;
      if (_position != null) {
        // We already have a last-known fix on screen — just start
        // watching for updates in the background instead of erroring out.
        _startWatching();
      } else {
        setState(() {
          _status = _LocationStatus.error;
          _errorMessage =
              'Couldn\'t get a GPS fix in time. Try moving somewhere with '
              'a clearer view of the sky, or check your device\'s location '
              'mode is set to "High accuracy".';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _LocationStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  void _startWatching() {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
  }

  void _recenter() {
    final p = _position;
    if (p == null || _mapController == null) return;
    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(p.latitude, p.longitude), _defaultZoom),
    );
  }

  Future<void> _onCategoryTap(PlaceCategory category) async {
    final p = _position;
    if (p == null) return;

    // Tapping the already-selected chip clears the filter.
    if (_selectedCategory == category) {
      setState(() {
        _selectedCategory = null;
        _placeMarkers = {};
      });
      return;
    }

    setState(() {
      _selectedCategory = category;
      _loadingPlaces = true;
    });

    try {
      final places = await _placesService.searchNearby(
        latitude: p.latitude,
        longitude: p.longitude,
        category: category,
      );

      if (!mounted) return;
      setState(() {
        _placeMarkers = places.map((place) {
          return Marker(
            markerId: MarkerId('${place.name}_${place.latitude}_${place.longitude}'),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.rating != null
                  ? '★ ${place.rating!.toStringAsFixed(1)}${place.address != null ? ' · ${place.address}' : ''}'
                  : place.address,
            ),
          );
        }).toSet();
        _loadingPlaces = false;
      });

      if (places.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No ${category.label.toLowerCase()} found nearby.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingPlaces = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t load ${category.label.toLowerCase()}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMapArea(),

            if (_status == _LocationStatus.ready)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _CategoryChipRow(
                  selected: _selectedCategory,
                  loading: _loadingPlaces,
                  onTap: _onCategoryTap,
                ),
              ),

            if (_status == _LocationStatus.ready)
              Positioned(
                right: 16,
                bottom: 16,
                child: NeoIconButton(
                  icon: Icons.my_location,
                  iconColor: NeoTheme.accentPurple,
                  onTap: _recenter,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    switch (_status) {
      case _LocationStatus.loading:
        return const _CenteredMessage(
          icon: Icons.explore_outlined,
          title: 'Finding you on the map...',
          subtitle: 'Hang tight while we get a location fix.',
          showSpinner: true,
        );

      case _LocationStatus.servicesDisabled:
        return _CenteredMessage(
          icon: Icons.location_off_outlined,
          title: 'Location services are off',
          subtitle: 'Turn on device location to see the map centered on you.',
          actionLabel: 'Open location settings',
          onAction: () async {
            await Geolocator.openLocationSettings();
            _initLocation();
          },
        );

      case _LocationStatus.permissionDenied:
        return _CenteredMessage(
          icon: Icons.pin_drop_outlined,
          title: 'Location permission needed',
          subtitle: 'Xplore needs permission to show nearby places around you.',
          actionLabel: 'Open app settings',
          onAction: () async {
            await Geolocator.openAppSettings();
            _initLocation();
          },
        );

      case _LocationStatus.error:
        return _CenteredMessage(
          icon: Icons.error_outline,
          title: 'Couldn\'t get your location',
          subtitle: _errorMessage ?? 'Something went wrong.',
          actionLabel: 'Try again',
          onAction: _initLocation,
        );

      case _LocationStatus.ready:
        final p = _position!;
        final center = LatLng(p.latitude, p.longitude);
        return GoogleMap(
          initialCameraPosition: CameraPosition(target: center, zoom: _defaultZoom),
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // using our own NeoIconButton instead
          zoomControlsEnabled: false,
          markers: _placeMarkers,
        );
    }
  }
}

/// Horizontal row of neomorphic pill chips for filtering nearby places.
class _CategoryChipRow extends StatelessWidget {
  const _CategoryChipRow({
    required this.selected,
    required this.loading,
    required this.onTap,
  });

  final PlaceCategory? selected;
  final bool loading;
  final ValueChanged<PlaceCategory> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: PlaceCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final category = PlaceCategory.values[i];
          final isSelected = selected == category;
          return GestureDetector(
            onTap: () => onTap(category),
            child: NeoBox(
              style: isSelected ? NeoStyle.pressed : NeoStyle.raised,
              borderRadius: 22,
              depth: 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected && loading) ...[
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        color: NeoTheme.accentPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? NeoTheme.accentPurple : NeoTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Full-bleed neomorphic placeholder used for loading / error / permission
/// states, so the map area never just shows a blank white screen.
class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.showSpinner = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeoTheme.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: NeoCard(
        borderRadius: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeoBox(
              style: NeoStyle.pressed,
              borderRadius: 30,
              width: 60,
              height: 60,
              child: Icon(icon, size: 26, color: NeoTheme.accentPurple),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: NeoTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: NeoTheme.textSecondary),
            ),
            if (showSpinner) ...[
              const SizedBox(height: 18),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: NeoTheme.accentPurple,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              NeoButton(
                onPressed: onAction!,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: NeoTheme.accentPurple,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

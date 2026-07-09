import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/donor_search_controller.dart';
import '../../../../core/theme/app_theme.dart';

class SearchDonorsScreen extends ConsumerStatefulWidget {
  const SearchDonorsScreen({super.key});

  @override
  ConsumerState<SearchDonorsScreen> createState() => _SearchDonorsScreenState();
}

class _SearchDonorsScreenState extends ConsumerState<SearchDonorsScreen> {
  String _selectedBloodType = 'A+';
  double _radius = 10.0; 
  final MapController _mapController = MapController();

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final LatLng _defaultCenter = const LatLng(42.3601, -71.0589); 

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runSearch();
    });
  }

  void _runSearch() {
    ref.read(donorSearchControllerProvider.notifier).searchDonors(
          latitude: _defaultCenter.latitude,
          longitude: _defaultCenter.longitude,
          radius: _radius,
          bloodType: _selectedBloodType,
        );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(donorSearchControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Nearby Donors'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedBloodType,
                            decoration: const InputDecoration(
                              labelText: 'Required Blood Group',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _bloodTypes.map((type) {
                              return DropdownMenuItem(value: type, child: Text(type));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedBloodType = val);
                                _runSearch();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Radius: ${_radius.round()} km',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Slider(
                                value: _radius,
                                min: 5.0,
                                max: 50.0,
                                divisions: 9,
                                activeColor: AppTheme.primaryRed,
                                label: '${_radius.round()} km',
                                onChanged: (val) {
                                  setState(() => _radius = val);
                                },
                                onChangeEnd: (_) {
                                  _runSearch();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            
            Expanded(
              child: Stack(
                children: [
                  
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _defaultCenter,
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'pk.eyJ1Ijoicm9oYW5hbGkiLCJhIjoiY21yNHJoMXR4MGMyYzMxc2VrZHdsaml4NSJ9.5xak4gPNhNAY7YGS_H8sxA',
                        userAgentPackageName: 'com.blood.sos',
                      ),
                      
                      
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _defaultCenter,
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 26,
                              ),
                            ),
                          ),
                          
                          
                          ...searchState.maybeWhen(
                            data: (donors) {
                              return donors.map((donor) {
                                return Marker(
                                  point: LatLng(donor.latitude, donor.longitude),
                                  width: 45,
                                  height: 45,
                                  child: GestureDetector(
                                    onTap: () => _showDonorDetailSheet(context, donor),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: AppTheme.primaryRed,
                                      size: 40,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            orElse: () => [],
                          ),
                        ],
                      ),
                    ],
                  ),

                  
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          )
                        ],
                      ),
                      child: searchState.when(
                        data: (donors) {
                          if (donors.isEmpty) {
                            return const Center(
                              child: Text(
                                'No matching active donors found within radius.',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${donors.length} Donors Found',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Tap map markers to view details'),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryRed,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () {
                                  _showResultsList(context, donors);
                                },
                                icon: const Icon(Icons.list_rounded),
                                label: const Text('View List'),
                              ),
                            ],
                          );
                        },
                        error: (err, _) => Center(child: Text('Search error: $err')),
                        loading: () => const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(strokeWidth: 2.5),
                              SizedBox(width: 16),
                              Text('Searching nearby donors...', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonorDetailSheet(BuildContext context, dynamic donor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    donor.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      donor.bloodGroup,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    backgroundColor: AppTheme.primaryRed,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Distance: ${donor.distance} km away',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_city, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text('Location: ${donor.city}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text('Phone: ${donor.phone}'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {}, 
                icon: const Icon(Icons.phone),
                label: const Text('Call Donor'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResultsList(BuildContext context, List<dynamic> donors) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: donors.length,
          itemBuilder: (context, index) {
            final donor = donors[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryRed,
                child: Text(
                  donor.bloodGroup,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(donor.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${donor.city} (${donor.distance} km away)'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).pop();
                _mapController.move(LatLng(donor.latitude, donor.longitude), 14.5);
                _showDonorDetailSheet(context, donor);
              },
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../models/doctor_model.dart';
import '../../providers/doctor_provider.dart';
import 'doctor_detail_screen.dart';

class DoctorMapScreen extends StatefulWidget {
  const DoctorMapScreen({Key? key}) : super(key: key);

  @override
  State<DoctorMapScreen> createState() => _DoctorMapScreenState();
}

class _DoctorMapScreenState extends State<DoctorMapScreen> {
  late final MapController _mapController;
  LatLng? _userLocation;
  bool _isLoadingLocation = true;
  String _selectedSpecialization = 'All';
  Doctor? _selectedDoctor;

  final List<String> _specializations = [
    'All',
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Orthopedic',
    'Neurologist',
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Fetch doctors with location
      if (mounted) {
        await Provider.of<DoctorProvider>(context, listen: false)
            .fetchDoctorsWithLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }

      // Move map to user location after build
      if (_userLocation != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(_userLocation!, 13.0);
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        // Default location (India center)
        _userLocation = LatLng(20.5937, 78.9629);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
        // Still fetch doctors without location
        await Provider.of<DoctorProvider>(context, listen: false).fetchDoctors();
      }
      
      if (_userLocation != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(_userLocation!, 5.0);
        });
      }
    }
  }

  List<Doctor> _getFilteredDoctors(List<Doctor> doctors) {
    if (_selectedSpecialization == 'All') {
      return doctors;
    }
    return doctors
        .where((doctor) => doctor.specialization == _selectedSpecialization)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors Near You'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeLocation,
          ),
        ],
      ),
      body: _isLoadingLocation
          ? const Center(child: CircularProgressIndicator())
          : Consumer<DoctorProvider>(
              builder: (context, doctorProvider, child) {
                if (doctorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (doctorProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(doctorProvider.errorMessage),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _initializeLocation,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredDoctors = _getFilteredDoctors(doctorProvider.doctors);

                return Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _userLocation ?? LatLng(20.5937, 78.9629),
                        initialZoom: 13.0,
                        onTap: (_, __) {
                          setState(() {
                            _selectedDoctor = null;
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
                          userAgentPackageName: 'com.careconnect.app',
                          subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                        ),
                        // User location marker
                        if (_userLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _userLocation!,
                                width: 50,
                                height: 50,
                                child: const Icon(
                                  Icons.person_pin_circle,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        // Doctor markers
                        MarkerLayer(
                          markers: filteredDoctors
                              .where((doctor) => doctor.location != null)
                              .map((doctor) {
                            final isSelected = _selectedDoctor?.id == doctor.id;
                            return Marker(
                              point: LatLng(
                                doctor.location!.latitude,
                                doctor.location!.longitude,
                              ),
                              width: isSelected ? 70 : 50,
                              height: isSelected ? 70 : 50,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDoctor = doctor;
                                  });
                                  _mapController.move(
                                    LatLng(
                                      doctor.location!.latitude,
                                      doctor.location!.longitude,
                                    ),
                                    15.0,
                                  );
                                },
                                child: Icon(
                                  Icons.local_hospital,
                                  size: isSelected ? 70 : 50,
                                  color: isSelected ? Colors.green : Colors.red,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // Filter dropdown
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSpecialization,
                              isExpanded: true,
                              icon: const Icon(Icons.filter_list),
                              items: _specializations
                                  .map((spec) => DropdownMenuItem(
                                        value: spec,
                                        child: Text(spec),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSpecialization = value!;
                                  _selectedDoctor = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Doctors count badge
                    Positioned(
                      top: 80,
                      left: 16,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${filteredDoctors.length} doctor${filteredDoctors.length != 1 ? 's' : ''} found',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Center to user location button
                    Positioned(
                      bottom: _selectedDoctor != null ? 220 : 100,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'centerUser',
                        onPressed: () {
                          if (_userLocation != null) {
                            _mapController.move(_userLocation!, 13.0);
                          }
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                    // List view toggle button
                    Positioned(
                      bottom: _selectedDoctor != null ? 220 : 160,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'listView',
                        onPressed: () {
                          _showDoctorsList(filteredDoctors);
                        },
                        child: const Icon(Icons.list),
                      ),
                    ),
                    // Selected doctor card
                    if (_selectedDoctor != null)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: _buildDoctorCard(_selectedDoctor!),
                      ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    doctor.userName?.substring(0, 1).toUpperCase() ?? 'D',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.userName ?? 'Doctor',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor.specialization,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (doctor.distance != null)
                        Text(
                          '${doctor.distance!.toStringAsFixed(1)} km away',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedDoctor = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('${doctor.rating.toStringAsFixed(1)}'),
                const SizedBox(width: 16),
                Icon(Icons.work, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${doctor.experience} years'),
                const SizedBox(width: 16),
                Icon(Icons.currency_rupee, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${doctor.consultationFee.toInt()}'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorDetailScreen(doctorId: doctor.id),
                    ),
                  );
                },
                child: const Text('View Profile & Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorsList(List<Doctor> doctors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nearby Doctors (${doctors.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: doctors.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          doctor.userName?.substring(0, 1).toUpperCase() ?? 'D',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        doctor.userName ?? 'Doctor',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.specialization),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${doctor.rating.toStringAsFixed(1)}'),
                              const SizedBox(width: 12),
                              if (doctor.distance != null)
                                Text(
                                  '${doctor.distance!.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${doctor.consultationFee.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${doctor.experience} yrs',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedDoctor = doctor;
                        });
                        if (doctor.location != null) {
                          _mapController.move(
                            LatLng(
                              doctor.location!.latitude,
                              doctor.location!.longitude,
                            ),
                            15.0,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

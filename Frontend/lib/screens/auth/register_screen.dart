import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/location_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedRole = 'patient';
  bool _isPasswordVisible = false;

  // Patient specific
  final _dobController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'O+';

  // Doctor specific
  String _selectedSpecialization = 'General Physician';
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  LatLng? _selectedLocation;
  String _locationStatus = 'Not selected';

  // Pharmacist specific
  final _pharmacyNameController = TextEditingController();
  final _pharmacyLicenseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _consultationFeeController.dispose();
    _pharmacyNameController.dispose();
    _pharmacyLicenseController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'phone': _phoneController.text.trim(),
      'role': _selectedRole,
    };

    // Add role-specific data
    if (_selectedRole == 'patient') {
      userData['dateOfBirth'] = _dobController.text;
      userData['gender'] = _selectedGender;
      userData['bloodGroup'] = _selectedBloodGroup;
    } else if (_selectedRole == 'doctor') {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your clinic location on the map'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      userData['specialization'] = _selectedSpecialization;
      userData['licenseNumber'] = _licenseNumberController.text.trim();
      userData['experience'] = int.parse(_experienceController.text);
      userData['consultationFee'] = double.parse(_consultationFeeController.text);
      userData['address'] = {'city': '', 'state': ''};
      userData['location'] = {
        'type': 'Point',
        'coordinates': [_selectedLocation!.longitude, _selectedLocation!.latitude]
      };
    } else if (_selectedRole == 'pharmacist') {
      userData['pharmacyName'] = _pharmacyNameController.text.trim();
      userData['licenseNumber'] = _pharmacyLicenseController.text.trim();
      userData['address'] = {
        'street': '',
        'city': '',
        'state': '',
        'pincode': ''
      };
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(userData);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRoleSpecificFields() {
    switch (_selectedRole) {
      case 'patient':
        return Column(
          children: [
            TextFormField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth (YYYY-MM-DD)',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter date of birth';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.person),
              ),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                prefixIcon: Icon(Icons.bloodtype),
              ),
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((bg) => DropdownMenuItem(
                        value: bg,
                        child: Text(bg),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodGroup = value!;
                });
              },
            ),
          ],
        );

      case 'doctor':
        return Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSpecialization,
              decoration: const InputDecoration(
                labelText: 'Specialization',
                prefixIcon: Icon(Icons.medical_services),
              ),
              items: [
                'General Physician',
                'Cardiologist',
                'Dermatologist',
                'Pediatrician',
                'Orthopedic',
                'Neurologist',
              ]
                  .map((spec) => DropdownMenuItem(
                        value: spec,
                        child: Text(spec),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpecialization = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _licenseNumberController,
              decoration: const InputDecoration(
                labelText: 'License Number',
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter license number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Experience (years)',
                prefixIcon: Icon(Icons.work),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter experience';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _consultationFeeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Consultation Fee (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter consultation fee';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Clinic Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _locationStatus,
                            style: TextStyle(
                              color: _selectedLocation != null 
                                  ? Colors.green 
                                  : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final location = await Navigator.push<LatLng>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationPicker(
                                initialLocation: _selectedLocation,
                                onLocationSelected: (location) {
                                  setState(() {
                                    _selectedLocation = location;
                                    _locationStatus =
                                        'Lat: ${location.latitude.toStringAsFixed(4)}, '
                                        'Lng: ${location.longitude.toStringAsFixed(4)}';
                                  });
                                },
                              ),
                            ),
                          );
                          if (location != null) {
                            setState(() {
                              _selectedLocation = location;
                              _locationStatus =
                                  'Lat: ${location.latitude.toStringAsFixed(4)}, '
                                  'Lng: ${location.longitude.toStringAsFixed(4)}';
                            });
                          }
                        },
                        icon: const Icon(Icons.location_on),
                        label: Text(_selectedLocation == null 
                            ? 'Select Location' 
                            : 'Change Location'),
                      ),
                    ],
                  ),
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Patients will be able to see doctors near their location. '
                      'Make sure to select your correct clinic location.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );

      case 'pharmacist':
        return Column(
          children: [
            TextFormField(
              controller: _pharmacyNameController,
              decoration: const InputDecoration(
                labelText: 'Pharmacy Name',
                prefixIcon: Icon(Icons.store),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pharmacy name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pharmacyLicenseController,
              decoration: const InputDecoration(
                labelText: 'Pharmacy License Number',
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter license number';
                }
                return null;
              },
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // Role Selection
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'patient',
                      label: Text('Patient'),
                      icon: Icon(Icons.person),
                    ),
                    ButtonSegment(
                      value: 'doctor',
                      label: Text('Doctor'),
                      icon: Icon(Icons.medical_services),
                    ),
                    ButtonSegment(
                      value: 'pharmacist',
                      label: Text('Pharmacist'),
                      icon: Icon(Icons.local_pharmacy),
                    ),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedRole = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Common Fields
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Role-specific fields
                _buildRoleSpecificFields(),
                const SizedBox(height: 30),

                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

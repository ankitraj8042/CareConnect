import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  Map<String, dynamic>? _patientData;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadMedicalHistory();
  }

  Future<void> _loadMedicalHistory() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id ?? '';

      final response = await ApiService.get('/patients/user/$userId', requiresAuth: true);
      
      setState(() {
        _patientData = response['patient'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMedicalHistory,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(),
            tooltip: 'Edit Medical History',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMedicalHistory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_patientData == null) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadMedicalHistory,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfoCard(),
            const SizedBox(height: 16),
            _buildEmergencyContactCard(),
            const SizedBox(height: 16),
            _buildMedicalConditionsCard(),
            const SizedBox(height: 16),
            _buildAllergiesCard(),
            const SizedBox(height: 16),
            _buildCurrentMedicationsCard(),
            const SizedBox(height: 16),
            _buildBloodGroupCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final dob = _patientData?['dateOfBirth'] != null
        ? DateTime.parse(_patientData!['dateOfBirth'])
        : null;
    
    final age = dob != null
        ? DateTime.now().difference(dob).inDays ~/ 365
        : null;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Gender', _patientData?['gender'] ?? 'Not specified'),
            _buildInfoRow('Date of Birth',
                dob != null ? dateFormat.format(dob) : 'Not specified'),
            if (age != null) _buildInfoRow('Age', '$age years'),
            _buildInfoRow('Address',
                _patientData?['address'] ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard() {
    final emergencyContact = _patientData?['emergencyContact'];
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency, color: Colors.red[700]),
                const SizedBox(width: 8),
                const Text(
                  'Emergency Contact',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (emergencyContact != null) ...[
              _buildInfoRow('Name', emergencyContact['name'] ?? 'Not specified'),
              _buildInfoRow('Relationship',
                  emergencyContact['relationship'] ?? 'Not specified'),
              _buildInfoRow('Phone', emergencyContact['phone'] ?? 'Not specified'),
            ] else
              const Text(
                'No emergency contact added',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalConditionsCard() {
    final conditions =
        _patientData?['medicalHistory']?['conditions'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Medical Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (conditions.isEmpty)
              const Text(
                'No medical conditions recorded',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...conditions
                  .map((condition) => _buildListItem(
                        condition.toString(),
                        Icons.check_circle_outline,
                        Colors.blue,
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesCard() {
    final allergies =
        _patientData?['medicalHistory']?['allergies'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[700]),
                const SizedBox(width: 8),
                const Text(
                  'Allergies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (allergies.isEmpty)
              const Text(
                'No allergies recorded',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...allergies
                  .map((allergy) => _buildListItem(
                        allergy.toString(),
                        Icons.warning,
                        Colors.orange,
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMedicationsCard() {
    final medications = _patientData?['medicalHistory']?['currentMedications']
            as List<dynamic>? ??
        [];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Current Medications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (medications.isEmpty)
              const Text(
                'No current medications',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...medications
                  .map((medication) => _buildListItem(
                        medication.toString(),
                        Icons.medication_outlined,
                        Colors.green,
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodGroupCard() {
    final bloodGroup = _patientData?['bloodGroup'];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bloodtype, color: Colors.red[700]),
                const SizedBox(width: 8),
                const Text(
                  'Blood Group',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  bloodGroup ?? 'Not specified',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Medical History'),
        content: const Text(
          'This feature allows you to update your medical information including conditions, allergies, and current medications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality coming soon!'),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

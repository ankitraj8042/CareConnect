import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({Key? key}) : super(key: key);

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  List<dynamic> _prescriptions = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await ApiService.get('/patients/user/$userId', requiresAuth: true);
      final patientId = response['patient']?['_id'];
      
      if (patientId == null) {
        throw Exception('Patient profile not found');
      }
      
      final prescResponse = await ApiService.get('/prescriptions/patient/$patientId', requiresAuth: true);
      
      setState(() {
        _prescriptions = prescResponse['prescriptions'] ?? [];
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
        title: const Text('My Prescriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrescriptions,
            tooltip: 'Refresh',
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
              onPressed: _loadPrescriptions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_prescriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No prescriptions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your prescriptions will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPrescriptions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          return _buildPrescriptionCard(_prescriptions[index]);
        },
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> prescription) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final prescriptionDate = prescription['createdAt'] != null
        ? DateTime.parse(prescription['createdAt'])
        : DateTime.now();
    
    final doctorName = prescription['doctorId']?['name'] ?? 'Unknown Doctor';
    final doctorSpecialization = prescription['doctorId']?['specialization'] ?? '';
    final medicines = prescription['medicines'] as List<dynamic>? ?? [];
    final diagnosis = prescription['diagnosis'] ?? 'Not specified';
    final notes = prescription['notes'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (doctorSpecialization.isNotEmpty)
                        Text(
                          doctorSpecialization,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(prescriptionDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.medical_information, 'Diagnosis', diagnosis),
            const SizedBox(height: 12),
            const Text(
              'Medicines:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...medicines.map((medicine) => _buildMedicineItem(medicine)).toList(),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note, size: 20, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor\'s Notes:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            style: TextStyle(
                              color: Colors.amber[900],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showPrescriptionDetails(prescription),
                icon: const Icon(Icons.visibility),
                label: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineItem(Map<String, dynamic> medicine) {
    final name = medicine['name'] ?? 'Unknown';
    final dosage = medicine['dosage'] ?? 'Not specified';
    final frequency = medicine['frequency'] ?? 'Not specified';
    final duration = medicine['duration'] ?? 'Not specified';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medication, size: 18, color: Colors.green[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.green[900],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMedicineDetail('Dosage', dosage),
              ),
              Expanded(
                child: _buildMedicineDetail('Frequency', frequency),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _buildMedicineDetail('Duration', duration),
        ],
      ),
    );
  }

  Widget _buildMedicineDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.green[900], fontSize: 13),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showPrescriptionDetails(Map<String, dynamic> prescription) {
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    final prescriptionDate = prescription['createdAt'] != null
        ? DateTime.parse(prescription['createdAt'])
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prescription Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${dateFormat.format(prescriptionDate)}'),
              const SizedBox(height: 8),
              Text('Doctor: ${prescription['doctorId']?['name'] ?? 'Unknown'}'),
              const SizedBox(height: 8),
              Text('Diagnosis: ${prescription['diagnosis'] ?? 'Not specified'}'),
              const SizedBox(height: 8),
              const Text('Medicines:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(prescription['medicines'] as List<dynamic>? ?? [])
                  .map((med) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 4),
                        child: Text('• ${med['name']} - ${med['dosage']}'),
                      ))
                  .toList(),
              if (prescription['notes'] != null &&
                  prescription['notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(prescription['notes']),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download feature coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }
}

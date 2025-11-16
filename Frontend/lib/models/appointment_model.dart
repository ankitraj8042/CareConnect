class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final TimeSlot timeSlot;
  final String status;
  final String chiefComplaint;
  final String? notes;
  final String? doctorName;
  final String? doctorSpecialization;
  final String? patientName;
  final String reason; // Alias for chiefComplaint

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    required this.chiefComplaint,
    this.notes,
    this.doctorName,
    this.doctorSpecialization,
    this.patientName,
  }) : reason = chiefComplaint;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    String? docName;
    String? docSpec;
    
    // Handle populated doctorId
    if (json['doctorId'] is Map) {
      final doctorData = json['doctorId'] as Map<String, dynamic>;
      if (doctorData['userId'] != null) {
        docName = doctorData['userId']['name'];
      }
      docSpec = doctorData['specialization'];
    }
    
    return Appointment(
      id: json['_id'] ?? json['id'],
      patientId: json['patientId'] is Map ? json['patientId']['_id'] : json['patientId'],
      doctorId: json['doctorId'] is Map ? json['doctorId']['_id'] : json['doctorId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      timeSlot: TimeSlot.fromJson(json['timeSlot']),
      status: json['status'] ?? 'scheduled',
      chiefComplaint: json['chiefComplaint'] ?? json['reason'] ?? '',
      notes: json['notes'],
      doctorName: docName,
      doctorSpecialization: docSpec,
      patientName: json['patientId'] is Map && json['patientId']['userId'] != null
          ? json['patientId']['userId']['name']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'timeSlot': timeSlot.toJson(),
      'chiefComplaint': chiefComplaint,
      'notes': notes,
    };
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;

  TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

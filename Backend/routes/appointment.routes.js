const express = require('express');
const router = express.Router();
const {
  createAppointment,
  getPatientAppointments,
  getDoctorAppointments,
  updateAppointment,
  deleteAppointment
} = require('../controllers/appointment.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

router.post('/', protect, authorize('patient'), createAppointment);
router.get('/patient/:patientId', protect, getPatientAppointments);
router.get('/doctor/:doctorId', protect, getDoctorAppointments);
router.put('/:id', protect, updateAppointment);
router.delete('/:id', protect, authorize('patient'), deleteAppointment);

module.exports = router;

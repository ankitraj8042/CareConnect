const express = require('express');
const router = express.Router();
const {
  createPrescription,
  getPatientPrescriptions,
  getPrescriptionById,
  getDoctorPrescriptions
} = require('../controllers/prescription.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

router.post('/', protect, authorize('doctor'), createPrescription);
router.get('/patient/:patientId', protect, getPatientPrescriptions);
router.get('/doctor/:doctorId', protect, authorize('doctor'), getDoctorPrescriptions);
router.get('/:id', protect, getPrescriptionById);

module.exports = router;

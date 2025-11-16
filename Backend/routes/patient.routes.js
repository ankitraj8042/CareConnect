const express = require('express');
const router = express.Router();
const {
  getPatientById,
  updatePatient,
  addMedicalHistory,
  addDocument
} = require('../controllers/patient.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

router.get('/:id', protect, getPatientById);
router.put('/:id', protect, updatePatient);
router.post('/:id/medical-history', protect, authorize('patient', 'doctor'), addMedicalHistory);
router.post('/:id/documents', protect, authorize('patient'), addDocument);

module.exports = router;

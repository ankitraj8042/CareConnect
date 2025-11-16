const express = require('express');
const router = express.Router();
const {
  getAllDoctors,
  getNearbyDoctors,
  getDoctorById,
  updateDoctor,
  getDoctorAvailability,
  getSpecializations
} = require('../controllers/doctor.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

router.get('/nearby', getNearbyDoctors);
router.get('/specializations/list', getSpecializations);
router.get('/', getAllDoctors);
router.get('/:id', getDoctorById);
router.get('/:id/availability', getDoctorAvailability);
router.put('/:id', protect, authorize('doctor'), updateDoctor);

module.exports = router;

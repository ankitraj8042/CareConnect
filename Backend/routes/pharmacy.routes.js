const express = require('express');
const router = express.Router();
const {
  getAllPharmacies,
  getPharmacyById,
  searchMedicine,
  addMedicine,
  updateMedicine,
  deleteMedicine
} = require('../controllers/pharmacy.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

router.get('/', getAllPharmacies);
router.get('/search/medicine', searchMedicine);
router.get('/:id', getPharmacyById);
router.post('/:id/inventory', protect, authorize('pharmacist'), addMedicine);
router.put('/:id/inventory/:medicineId', protect, authorize('pharmacist'), updateMedicine);
router.delete('/:id/inventory/:medicineId', protect, authorize('pharmacist'), deleteMedicine);

module.exports = router;

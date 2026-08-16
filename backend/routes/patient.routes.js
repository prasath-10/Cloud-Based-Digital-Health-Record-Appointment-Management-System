// backend/routes/patient.routes.js
// ============================================================
// Patient Module Router
// ============================================================

'use strict';

const express = require('express');
const router = express.Router();

const authenticate = require('../middleware/authenticate');
const authorizePatientAccess = require('../middleware/authorizePatientAccess');
const patientController = require('../controllers/patient.controller');

// All patient routes require a valid Firebase ID token
router.use(authenticate);

/**
 * @route   POST /api/patients
 * @desc    Register a new patient profile
 * @access  Private (Authenticated users)
 */
router.post('/', patientController.createPatient);

/**
 * @route   GET /api/patients/me
 * @desc    Fetch profile of currently authenticated patient
 * @access  Private (Self)
 */
router.get('/me', authorizePatientAccess, patientController.getPatientById);

/**
 * @route   GET /api/patients/:id
 * @desc    Fetch single patient profile by ID
 * @access  Private (Self or Doctor/Admin)
 */
router.get('/:id', authorizePatientAccess, patientController.getPatientById);

/**
 * @route   PUT /api/patients/:id
 * @desc    Update single patient profile
 * @access  Private (Self or Doctor/Admin)
 */
router.put('/:id', authorizePatientAccess, patientController.updatePatient);

module.exports = router;

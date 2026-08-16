// backend/middleware/authorizePatientAccess.js
// ============================================================
// Patient Self-Access Authorization Middleware
// ============================================================
// Enforces privacy policy:
// - DOCTOR and ADMIN roles can access any patient record.
// - PATIENT role can ONLY access their OWN patient record.
// ============================================================

'use strict';

const prisma = require('../config/prisma');

async function authorizePatientAccess(req, res, next) {
  try {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Authentication required prior to patient access authorization.',
      });
    }

    // Doctors and Admins have global permission to view/edit patient profiles
    const userRole = (req.user.role || 'PATIENT').toUpperCase();
    if (userRole === 'DOCTOR' || userRole === 'ADMIN') {
      return next();
    }

    let targetPatientId = req.params.id;

    // Handle special "me" alias endpoint (GET/PUT /api/patients/me)
    if (targetPatientId === 'me') {
      if (!req.user.patient_id) {
        // Look up patient ID from database by firebase_uid
        const userWithPatient = await prisma.user.findUnique({
          where: { firebase_uid: req.user.uid },
          include: { patient: true },
        });

        if (!userWithPatient || !userWithPatient.patient) {
          return res.status(404).json({
            success: false,
            error: 'Not Found',
            message: 'Patient profile not registered yet for this account. Please register first via POST /api/patients.',
          });
        }
        req.user.patient_id = userWithPatient.patient.id;
      }
      req.params.id = req.user.patient_id;
      return next();
    }

    // For specific UUID access (e.g. GET /api/patients/:id)
    // Check 1: Quick match against req.user.patient_id
    if (req.user.patient_id && req.user.patient_id === targetPatientId) {
      return next();
    }

    // Check 2: Query DB to verify if patient record belongs to this user's firebase_uid
    const patientRecord = await prisma.patient.findUnique({
      where: { id: targetPatientId },
      include: { user: true },
    });

    if (!patientRecord) {
      return res.status(404).json({
        success: false,
        error: 'Not Found',
        message: `Patient with ID "${targetPatientId}" was not found.`,
      });
    }

    if (patientRecord.user && patientRecord.user.firebase_uid === req.user.uid) {
      req.user.patient_id = patientRecord.id; // cache match
      return next();
    }

    // If neither match, user is trying to access someone else's profile!
    return res.status(403).json({
      success: false,
      error: 'Forbidden',
      message: 'Access denied. You are only authorized to access your own patient profile.',
    });
  } catch (error) {
    console.error('❌ Patient Access Authorization Error:', error.message);
    return res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'An error occurred during patient authorization check.',
    });
  }
}

module.exports = authorizePatientAccess;

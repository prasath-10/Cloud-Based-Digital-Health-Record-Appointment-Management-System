// backend/controllers/patient.controller.js
// ============================================================
// Patient Module Controller
// ============================================================
// Handles Patient Registration (POST), Profile Lookup (GET), and Profile Updates (PUT)
// ============================================================

'use strict';

const prisma = require('../config/prisma');
const { generateUniqueHealthId } = require('../utils/healthId');

/**
 * @route   POST /api/patients
 * @desc    Register a new patient profile linked to Firebase Auth UID & phone number
 * @access  Private (Authenticated User)
 */
async function createPatient(req, res, next) {
  try {
    const { name, dob, gender, language_pref, phone } = req.body;

    // 1. Field Validations
    if (!name || typeof name !== 'string' || name.trim().length < 2) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Field "name" is required and must be at least 2 characters.',
      });
    }

    if (!dob || isNaN(Date.parse(dob))) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Field "dob" (Date of Birth) is required and must be a valid date format (e.g. YYYY-MM-DD).',
      });
    }

    if (!gender || !['Male', 'Female', 'Other'].includes(gender)) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Field "gender" is required and must be one of: Male, Female, Other.',
      });
    }

    if (!language_pref || typeof language_pref !== 'string') {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Field "language_pref" is required (e.g. Bengali, Hindi, English, Tamil, Malayalam).',
      });
    }

    // Phone number comes from verified Firebase Auth token, with fallback to request body
    const userPhone = req.user.phone_number || phone;
    if (!userPhone) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Phone number missing from authenticated user token and body.',
      });
    }

    // 2. Find or Create database User record
    let user = await prisma.user.findUnique({
      where: { firebase_uid: req.user.uid },
    });

    if (!user) {
      user = await prisma.user.create({
        data: {
          firebase_uid: req.user.uid,
          phone: userPhone,
          role: 'PATIENT',
        },
      });
    }

    // 3. Check if Patient profile already exists for this User or Phone
    const existingPatient = await prisma.patient.findFirst({
      where: {
        OR: [{ user_id: user.id }, { phone: userPhone }],
      },
    });

    if (existingPatient) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'A patient profile is already registered for this user account / phone number.',
        patient_id: existingPatient.id,
        health_id: existingPatient.health_id,
      });
    }

    // 4. Generate system-wide unique Health ID (MWH-XXXXXX)
    const health_id = await generateUniqueHealthId(prisma);

    // 5. Create Patient record in PostgreSQL
    const newPatient = await prisma.patient.create({
      data: {
        user_id: user.id,
        health_id,
        name: name.trim(),
        phone: userPhone,
        dob: new Date(dob),
        gender,
        language_pref: language_pref.trim(),
      },
      include: {
        user: {
          select: { id: true, firebase_uid: true, role: true },
        },
      },
    });

    return res.status(201).json({
      success: true,
      message: '🎉 Patient profile registered successfully!',
      data: newPatient,
    });
  } catch (error) {
    console.error('❌ Error creating patient:', error.message);
    next(error);
  }
}

/**
 * @route   GET /api/patients/:id
 * @desc    Fetch single patient profile by ID (or "me")
 * @access  Private (Self-Access or Doctor/Admin)
 */
async function getPatientById(req, res, next) {
  try {
    const patientId = req.params.id;

    const patient = await prisma.patient.findUnique({
      where: { id: patientId },
      include: {
        user: {
          select: { id: true, firebase_uid: true, role: true, phone: true },
        },
      },
    });

    if (!patient) {
      return res.status(404).json({
        success: false,
        error: 'Not Found',
        message: `Patient profile with ID "${patientId}" not found.`,
      });
    }

    return res.json({
      success: true,
      data: patient,
    });
  } catch (error) {
    console.error('❌ Error fetching patient:', error.message);
    next(error);
  }
}

/**
 * @route   PUT /api/patients/:id
 * @desc    Update allowed profile fields for a patient (name, dob, gender, language_pref)
 * @access  Private (Self-Access or Doctor/Admin)
 */
async function updatePatient(req, res, next) {
  try {
    const patientId = req.params.id;
    const { name, dob, gender, language_pref } = req.body;

    const existingPatient = await prisma.patient.findUnique({
      where: { id: patientId },
    });

    if (!existingPatient) {
      return res.status(404).json({
        success: false,
        error: 'Not Found',
        message: `Patient profile with ID "${patientId}" not found.`,
      });
    }

    // Build update payload dynamically
    const updateData = {};
    if (name && typeof name === 'string' && name.trim().length >= 2) {
      updateData.name = name.trim();
    }
    if (dob && !isNaN(Date.parse(dob))) {
      updateData.dob = new Date(dob);
    }
    if (gender && ['Male', 'Female', 'Other'].includes(gender)) {
      updateData.gender = gender;
    }
    if (language_pref && typeof language_pref === 'string') {
      updateData.language_pref = language_pref.trim();
    }

    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'No valid update fields provided. Allowed fields: name, dob, gender, language_pref.',
      });
    }

    const updatedPatient = await prisma.patient.update({
      where: { id: patientId },
      data: updateData,
      include: {
        user: {
          select: { id: true, firebase_uid: true, role: true },
        },
      },
    });

    return res.json({
      success: true,
      message: '✅ Patient profile updated successfully.',
      data: updatedPatient,
    });
  } catch (error) {
    console.error('❌ Error updating patient:', error.message);
    next(error);
  }
}

module.exports = {
  createPatient,
  getPatientById,
  updatePatient,
};

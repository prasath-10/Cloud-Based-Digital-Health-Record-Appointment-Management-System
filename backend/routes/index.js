// routes/index.js
// Central router — mounts all sub-routers here.
// As you add features (patients, appointments), import their routers and mount them below.

const express = require('express');
const router = express.Router();

const healthRouter = require('./health.routes');

// Mount the health-check route at /health
router.use('/health', healthRouter);

module.exports = router;

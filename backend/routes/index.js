// routes/index.js
// Central router — mounts all sub-routers here.
// As you add features (patients, appointments), import their routers and mount them below.

const express = require('express');
const router = express.Router();

const healthRouter = require('./health.routes');
const protectedRouter = require('./protected.routes');

// Mount sub-routers
router.use('/health', healthRouter);
router.use('/protected', protectedRouter);

module.exports = router;

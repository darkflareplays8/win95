const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

app.get('*', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));

app.use((err, req, res, next) => {
  console.error(`[ERROR] ${err.message}`);
  res.status(500).send('Internal Server Error');
});

app.listen(PORT, () => {
  console.log(`[BOOT] VoidHub Emulation starting...`);
  console.log(`[BOOT] Server running on port ${PORT}`);
  console.log(`[BOOT] Environment: ${process.env.NODE_ENV || 'development'}`);
});
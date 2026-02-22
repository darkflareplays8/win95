const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files with range request support (needed for v86 async disk)
app.use(express.static(path.join(__dirname, 'public'), {
  acceptRanges: true,
  setHeaders: (res) => {
    res.set('Accept-Ranges', 'bytes');
  }
}));

// Explicit range request handler for disk images
app.get('/v86/images/:file', (req, res) => {
  const filePath = path.join(__dirname, 'public', 'v86', 'images', req.params.file);
  if (!fs.existsSync(filePath)) return res.status(404).send('Not found');

  const stat = fs.statSync(filePath);
  const total = stat.size;

  if (req.headers.range) {
    const range = req.headers.range;
    const parts = range.replace(/bytes=/, '').split('-');
    const start = parseInt(parts[0], 10);
    const end = parts[1] ? parseInt(parts[1], 10) : total - 1;

    if (start >= total || end >= total) {
      res.status(416).set('Content-Range', `bytes */${total}`).end();
      return;
    }

    const chunkSize = end - start + 1;
    console.log(`[RANGE] ${req.params.file} bytes=${start}-${end}/${total}`);

    res.status(206).set({
      'Content-Range': `bytes ${start}-${end}/${total}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': chunkSize,
      'Content-Type': 'application/octet-stream',
    });

    fs.createReadStream(filePath, { start, end }).pipe(res);
  } else {
    console.log(`[FULL] Serving ${req.params.file} (${(total/1024/1024).toFixed(1)}MB)`);
    res.set({
      'Content-Length': total,
      'Content-Type': 'application/octet-stream',
      'Accept-Ranges': 'bytes',
    });
    fs.createReadStream(filePath).pipe(res);
  }
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
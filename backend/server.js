const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;
const DB_FILE = path.join(__dirname, 'database.json');

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Initialize persistent database file if not present
function getDatabase() {
  if (!fs.existsSync(DB_FILE)) {
    const initialData = {
      rfqs: [],
      catalog_requests: [],
      stats: {
        total_inquiries: 0,
        pending_quotes: 0,
        completed_quotes: 0
      }
    };
    fs.writeFileSync(DB_FILE, JSON.stringify(initialData, null, 2));
    return initialData;
  }
  try {
    const raw = fs.readFileSync(DB_FILE, 'utf-8');
    return JSON.parse(raw);
  } catch (err) {
    return { rfqs: [], catalog_requests: [], stats: {} };
  }
}

function saveDatabase(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

// 1. Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'online',
    system: 'Gravix Equipment Solutions Backend API',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// 2. Submit new RFQ (Request For Quotation)
app.post('/api/rfq', (req, res) => {
  try {
    const { name, company, email, phone, category, quantity, message } = req.body;

    if (!name || !phone) {
      return res.status(400).json({ error: 'Name and Phone number are required fields' });
    }

    const db = getDatabase();
    const newRfq = {
      id: 'RFQ-' + Date.now().toString(36).toUpperCase(),
      name: name.trim(),
      company: (company || 'Not Specified').trim(),
      email: (email || '').trim(),
      phone: phone.trim(),
      category: category || 'General Inquiries',
      quantity: quantity || 'Not specified',
      message: (message || '').trim(),
      status: 'NEW', // NEW, IN_PROGRESS, QUOTED, CLOSED
      createdAt: new Date().toISOString()
    };

    db.rfqs.unshift(newRfq);
    db.stats.total_inquiries = (db.stats.total_inquiries || 0) + 1;
    db.stats.pending_quotes = (db.stats.pending_quotes || 0) + 1;
    saveDatabase(db);

    console.log(`[RFQ RECEIVED] ${newRfq.id} from ${newRfq.name} (${newRfq.phone}) for ${newRfq.category}`);

    res.status(201).json({
      success: true,
      message: 'Quotation request logged successfully. Engineering team notified.',
      rfq_id: newRfq.id
    });
  } catch (err) {
    console.error('Error processing RFQ:', err);
    res.status(500).json({ error: 'Internal server error processing quote' });
  }
});

// 3. Get all RFQs with optional status filter
app.get('/api/rfq', (req, res) => {
  const db = getDatabase();
  const { status, search } = req.query;

  let results = db.rfqs;

  if (status && status !== 'ALL') {
    results = results.filter(item => item.status === status);
  }

  if (search) {
    const q = search.toLowerCase();
    results = results.filter(item =>
      item.name.toLowerCase().includes(q) ||
      item.phone.includes(q) ||
      item.company.toLowerCase().includes(q) ||
      item.id.toLowerCase().includes(q)
    );
  }

  res.json({
    total: results.length,
    rfqs: results
  });
});

// 4. Update RFQ Status (e.g. mark contacted, quoted, closed)
app.patch('/api/rfq/:id', (req, res) => {
  const db = getDatabase();
  const { id } = req.params;
  const { status, notes } = req.body;

  const rfq = db.rfqs.find(item => item.id === id);
  if (!rfq) {
    return res.status(404).json({ error: 'Inquiry not found' });
  }

  if (status) rfq.status = status;
  if (notes) rfq.notes = notes;
  rfq.updatedAt = new Date().toISOString();

  saveDatabase(db);
  res.json({ success: true, rfq });
});

// 5. Delete an RFQ
app.delete('/api/rfq/:id', (req, res) => {
  const db = getDatabase();
  const { id } = req.params;

  const initialCount = db.rfqs.length;
  db.rfqs = db.rfqs.filter(item => item.id !== id);

  if (db.rfqs.length === initialCount) {
    return res.status(404).json({ error: 'Inquiry not found' });
  }

  saveDatabase(db);
  res.json({ success: true, message: 'Inquiry deleted' });
});

// 6. Catalogue Download Logging
app.post('/api/catalog', (req, res) => {
  const { name, email } = req.body;
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }

  const db = getDatabase();
  db.catalog_requests = db.catalog_requests || [];
  db.catalog_requests.unshift({
    name: name || 'Anonymous',
    email: email.trim(),
    downloadedAt: new Date().toISOString()
  });

  saveDatabase(db);
  res.json({ success: true, message: 'Catalogue request registered' });
});

// 7. Dashboard Overview Stats
app.get('/api/stats', (req, res) => {
  const db = getDatabase();
  const total = db.rfqs.length;
  const newCount = db.rfqs.filter(r => r.status === 'NEW').length;
  const quoted = db.rfqs.filter(r => r.status === 'QUOTED').length;
  const closed = db.rfqs.filter(r => r.status === 'CLOSED').length;
  const catalogs = (db.catalog_requests || []).length;

  res.json({
    total_rfqs: total,
    new_inquiries: newCount,
    quoted_orders: quoted,
    closed_deals: closed,
    catalog_downloads: catalogs
  });
});

// 8. Serve Admin Dashboard UI
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

// Start Server
app.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(` Gravix Equipment Solutions Backend API Online!`);
  console.log(` Server Port: http://localhost:${PORT}`);
  console.log(` Admin Dashboard: http://localhost:${PORT}/admin`);
  console.log(` API Endpoint: http://localhost:${PORT}/api/rfq`);
  console.log(`====================================================`);
});

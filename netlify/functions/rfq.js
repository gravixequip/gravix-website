// Netlify Serverless Function for Gravix RFQ Management

// In-memory / serverless cache (for persistent long-term storage, hook to Supabase/MongoDB)
let inMemoryRfqs = [
  {
    id: "RFQ-SAMPLE1",
    name: "Rajesh Patel",
    company: "Gujarat Infra Earthmovers",
    email: "rajesh@gujaratinfra.com",
    phone: "+91 98250 12345",
    category: "Tooth Points",
    quantity: "50 Sets (JCB 3DX)",
    message: "Immediate dispatch needed for stone quarry site in Naroda Ahmedabad.",
    status: "NEW",
    createdAt: new Date().toISOString()
  }
];

exports.handler = async (event, context) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Content-Type': 'application/json'
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  // GET: Fetch RFQs
  if (event.httpMethod === 'GET') {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        total: inMemoryRfqs.length,
        rfqs: inMemoryRfqs
      })
    };
  }

  // POST: Receive new quotation request
  if (event.httpMethod === 'POST') {
    try {
      const data = JSON.parse(event.body || '{}');

      if (!data.name || !data.phone) {
        return {
          statusCode: 400,
          headers,
          body: JSON.stringify({ error: 'Name and phone number are required' })
        };
      }

      const newRfq = {
        id: 'RFQ-' + Date.now().toString(36).toUpperCase(),
        name: data.name.trim(),
        company: (data.company || 'Direct Buyer').trim(),
        email: (data.email || '').trim(),
        phone: data.phone.trim(),
        category: data.category || 'General Inquiries',
        quantity: data.quantity || 'Not specified',
        message: (data.message || '').trim(),
        status: 'NEW',
        createdAt: new Date().toISOString()
      };

      inMemoryRfqs.unshift(newRfq);

      return {
        statusCode: 201,
        headers,
        body: JSON.stringify({
          success: true,
          message: 'Quotation request received successfully.',
          rfq_id: newRfq.id
        })
      };
    } catch (err) {
      return {
        statusCode: 500,
        headers,
        body: JSON.stringify({ error: 'Failed to process quotation' })
      };
    }
  }

  return { statusCode: 405, headers, body: JSON.stringify({ error: 'Method not allowed' }) };
};

// ============================================================
// GRAVIX EQUIPMENT SOLUTIONS - GOOGLE APPS SCRIPT
// ============================================================
// Instructions:
// 1. Open https://sheets.new (new Google Sheet)
// 2. Click "Extensions" -> "Apps Script" in the top menu
// 3. Delete any code in the editor, paste this entire file
// 4. Click "Deploy" -> "New deployment"
// 5. Select type: "Web app"
// 6. Set Description: "Gravix Cloud Sync"
// 7. Set "Execute as": "Me"
// 8. Set "Who has access": "Anyone"  <-- CRITICAL!
// 9. Click "Deploy" and Copy the Web App URL (ends with /exec)
// 10. Paste into Admin Desk (or set window.GRAVIX_CLOUD_URL in cloud-config.js)
// ============================================================

function doGet(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var rows = sheet.getDataRange().getValues();
  if (rows.length <= 1) {
    return ContentService.createTextOutput(JSON.stringify({ rfqs: [] }))
      .setMimeType(ContentService.MimeType.JSON);
  }
  var rfqs = [];
  for (var i = rows.length - 1; i >= 1; i--) {
    var r = rows[i];
    if (r[0] || r[2] || r[4]) {
      rfqs.push({
        id: String(r[0] || ''),
        date: String(r[1] || ''),
        name: String(r[2] || ''),
        company: String(r[3] || ''),
        phone: String(r[4] || ''),
        category: String(r[5] || ''),
        message: String(r[6] || ''),
        status: String(r[7] || 'NEW'),
        source: String(r[8] || 'Website')
      });
    }
  }
  return ContentService.createTextOutput(JSON.stringify({ rfqs: rfqs }))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    if (sheet.getLastRow() === 0) {
      sheet.appendRow([
        "Inquiry ID",
        "Date",
        "Customer Name",
        "Company",
        "Phone / WhatsApp",
        "Product Category",
        "Message / Machine Details",
        "Status",
        "Source"
      ]);
    }
    var data = JSON.parse(e.postData.contents || '{}');
    sheet.appendRow([
      data.id || ('RFQ-' + new Date().getTime().toString(36).toUpperCase()),
      data.date || new Date().toISOString(),
      data.name || '',
      data.company || '',
      data.phone || '',
      data.category || '',
      data.message || '',
      data.status || 'NEW',
      data.source || 'Website'
    ]);
    return ContentService.createTextOutput(JSON.stringify({ success: true }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ error: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

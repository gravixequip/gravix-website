// Initialize Lucide icons
document.addEventListener("DOMContentLoaded", () => {
  if (window.lucide) {
    window.lucide.createIcons();
  }

  // Mobile menu toggle
  const mobileMenuBtn = document.getElementById("mobileMenuBtn");
  const mobileMenu = document.getElementById("mobileMenu");

  if (mobileMenuBtn && mobileMenu) {
    mobileMenuBtn.addEventListener("click", () => {
      mobileMenu.classList.toggle("hidden");
    });
  }
});

// Product Filtering
function filterProducts(category) {
  const searchInput = document.getElementById("liveProductSearch");
  if (searchInput) searchInput.value = "";

  const cards = document.querySelectorAll(".product-card");
  const buttons = document.querySelectorAll(".filter-btn");

  // Update button active state
  buttons.forEach((btn) => {
    btn.classList.remove("active");
  });

  if (window.event && window.event.currentTarget) {
    window.event.currentTarget.classList.add("active");
  }

  let visibleCount = 0;
  // Filter Cards
  cards.forEach((card) => {
    const cardCat = card.getAttribute("data-category");
    if (category === "all" || cardCat === category) {
      card.style.display = "flex";
      visibleCount++;
    } else {
      card.style.display = "none";
    }
  });

  const notice = document.getElementById("noProductsFoundNotice");
  if (notice) {
    if (visibleCount === 0) {
      notice.classList.remove("hidden");
    } else {
      notice.classList.add("hidden");
    }
  }
}

// Live Real-Time Product Search
function liveSearchProducts() {
  const query = (document.getElementById("liveProductSearch")?.value || "").toLowerCase().trim();
  const cards = document.querySelectorAll(".product-card");
  let visibleCount = 0;

  // Clear active tab filter if typing a search
  if (query) {
    const buttons = document.querySelectorAll(".filter-btn");
    buttons.forEach((btn) => btn.classList.remove("active"));
  }

  cards.forEach((card) => {
    const searchData = (card.getAttribute("data-search") || "").toLowerCase();
    const title = card.querySelector("h3")?.innerText.toLowerCase() || "";
    const desc = card.querySelector("p")?.innerText.toLowerCase() || "";

    if (!query || searchData.includes(query) || title.includes(query) || desc.includes(query)) {
      card.style.display = "flex";
      visibleCount++;
    } else {
      card.style.display = "none";
    }
  });

  const notice = document.getElementById("noProductsFoundNotice");
  if (notice) {
    if (visibleCount === 0) {
      notice.classList.remove("hidden");
    } else {
      notice.classList.add("hidden");
    }
  }
}

// Quick Inquire from Product card -> scroll & pre-fill RFQ
function requestItemQuote(itemName) {
  const rfqSection = document.getElementById("quote");
  const messageBox = document.getElementById("rfqMessage");

  if (rfqSection) {
    rfqSection.scrollIntoView({ behavior: "smooth" });
  }

  if (messageBox) {
    messageBox.value = `I would like to request factory pricing & availability for: ${itemName}.\nQuantity needed: \nDelivery Location: `;
    messageBox.focus();
  }
}

// RFQ Form Submission for GitHub Pages (static hosting)
// The inquiry is delivered by email through FormSubmit. No Netlify/server API is required.
async function handleFormSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const submitBtn = form.querySelector('button[type="submit"]');
  const successBox = document.getElementById("formSuccessMessage");

  const nameVal = document.getElementById("rfqName")?.value.trim() || '';
  const companyVal = document.getElementById("rfqCompany")?.value.trim() || 'Direct Buyer';
  const phoneVal = document.getElementById("rfqPhone")?.value.trim() || '';
  const categoryVal = document.getElementById("rfqCategorySelect")?.value || 'General Inquiries';
  const messageVal = document.getElementById("rfqMessage")?.value.trim() || '';
  const rfqId = 'RFQ-' + Date.now().toString(36).toUpperCase();

  const honeyVal = document.getElementById("rfqHoney")?.value;
  if (honeyVal) {
    if (successBox) {
      successBox.textContent = '✓ Thank you! Your request has been received.';
      successBox.classList.remove("hidden");
    }
    form.reset();
    return;
  }

  const originalText = submitBtn ? submitBtn.innerHTML : '';
  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="animate-pulse">Sending Quote Request...</span>';
  }

  try {
    const response = await fetch('https://formsubmit.co/ajax/gravixequip@gmail.com', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        'Inquiry ID': rfqId,
        'Customer Name': nameVal,
        'Company / Firm': companyVal,
        'Phone / WhatsApp': phoneVal,
        'Product Required': categoryVal,
        'Machine Model & Message': messageVal || 'Standard Quotation Request',
        '_subject': `New Gravix RFQ: ${nameVal} - ${categoryVal}`,
        '_template': 'table',
        '_captcha': 'false',
        '_honey': ''
      })
    });

    if (!response.ok) throw new Error(`Form service returned ${response.status}`);

    if (successBox) {
      successBox.innerHTML = `✓ Thank you <strong>${escapeForMessage(nameVal)}</strong>! Your RFQ <strong>#${rfqId}</strong> has been sent to our team. We will contact you on WhatsApp/Phone shortly.`;
      successBox.classList.remove("hidden");
    }
    form.reset();
  } catch (err) {
    console.error('RFQ email delivery failed:', err);
    if (successBox) {
      successBox.innerHTML = `We could not send the form automatically. Please contact us on <a class="underline font-bold" href="https://wa.me/919724350510" target="_blank" rel="noopener noreferrer">WhatsApp</a> or email <a class="underline font-bold" href="mailto:gravixequip@gmail.com">gravixequip@gmail.com</a>.`;
      successBox.classList.remove("hidden");
    }
  } finally {
    if (submitBtn) {
      submitBtn.disabled = false;
      submitBtn.innerHTML = originalText;
      if (window.lucide) window.lucide.createIcons();
    }
  }
}

function escapeForMessage(value) {
  return String(value || '').replace(/[&<>"']/g, (char) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[char]));
}

// Catalogue Modal
function openCatalogModal() {
  const modal = document.getElementById("catalogModal");
  if (modal) {
    modal.classList.remove("hidden");
    modal.classList.add("flex");
  }
}

function closeCatalogModal() {
  const modal = document.getElementById("catalogModal");
  if (modal) {
    modal.classList.add("hidden");
    modal.classList.remove("flex");
  }
}

async function handleCatalogueDownload(e) {
  e.preventDefault();
  const form = e.target;
  const inputs = form.querySelectorAll('input');
  const notice = document.getElementById("catalogDownloadNotice");
  const submitBtn = form.querySelector('button[type="submit"]');
  const name = inputs[0]?.value.trim() || '';
  const email = inputs[1]?.value.trim() || '';
  const originalText = submitBtn ? submitBtn.innerHTML : '';

  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.textContent = 'Sending Request...';
  }

  try {
    const response = await fetch('https://formsubmit.co/ajax/gravixequip@gmail.com', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        'Request Type': 'Product Catalogue PDF',
        'Customer Name': name,
        'Customer Email': email,
        '_subject': `Gravix Catalogue Request - ${name}`,
        '_template': 'table',
        '_captcha': 'false'
      })
    });

    if (!response.ok) throw new Error(`Form service returned ${response.status}`);

    if (notice) {
      notice.textContent = '✓ Catalogue request sent. Our team will email the PDF to you.';
      notice.classList.remove("hidden");
    }
    form.reset();
    setTimeout(() => {
      closeCatalogModal();
      notice?.classList.add("hidden");
    }, 2500);
  } catch (err) {
    console.error('Catalogue request failed:', err);
    if (notice) {
      notice.innerHTML = 'Could not send automatically. Please email <a class="underline font-bold" href="mailto:gravixequip@gmail.com">gravixequip@gmail.com</a>.';
      notice.classList.remove("hidden");
    }
  } finally {
    if (submitBtn) {
      submitBtn.disabled = false;
      submitBtn.innerHTML = originalText;
    }
  }
}

// Toggle technical metallurgy spectro sheet
function toggleTechSpecs() {
  const panel = document.getElementById("techSpecsDetail");
  const btn = document.getElementById("toggleTechBtn");
  if (panel) {
    const isHidden = panel.classList.contains("hidden");
    panel.classList.toggle("hidden");
    if (btn) {
      btn.innerHTML = isHidden 
        ? '<i data-lucide="chevron-up" class="w-4 h-4"></i> Hide Chemical Composition' 
        : '<i data-lucide="sliders" class="w-4 h-4"></i> View Spectro Chemical Composition';
      if (window.lucide) window.lucide.createIcons();
    }
  }
}

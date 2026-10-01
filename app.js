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

// RFQ Form Submission to Backend REST API & Local Storage
async function handleFormSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const submitBtn = form.querySelector('button[type="submit"]');
  const successBox = document.getElementById("formSuccessMessage");

  const nameVal = document.getElementById("rfqName")?.value || '';
  const companyVal = document.getElementById("rfqCompany")?.value || 'Direct Buyer';
  const phoneVal = document.getElementById("rfqPhone")?.value || '';
  const categoryVal = document.getElementById("rfqCategorySelect")?.value || 'General Inquiries';
  const messageVal = document.getElementById("rfqMessage")?.value || '';
  const rfqId = 'RFQ-' + Date.now().toString(36).toUpperCase();

  const payload = {
    id: rfqId,
    name: nameVal,
    company: companyVal,
    phone: phoneVal,
    category: categoryVal,
    quantity: 'Direct Inquiry',
    message: messageVal,
    status: 'NEW',
    createdAt: new Date().toISOString()
  };

  // 1. Save in localStorage for instant access across tabs
  try {
    let existing = JSON.parse(localStorage.getItem('gravix_rfqs') || '[]');
    existing.unshift(payload);
    localStorage.setItem('gravix_rfqs', JSON.stringify(existing));
  } catch (err) {
    console.error('LocalStorage write error:', err);
  }

  const originalText = submitBtn ? submitBtn.innerHTML : '';
  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="animate-pulse">Processing Quote Request...</span>';
  }

  try {
    const res = await fetch('/api/rfq', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const data = await res.json();
    if (successBox) {
      successBox.innerHTML = `✓ Thank you <strong>${nameVal}</strong>! Your RFQ <strong>#${data.rfq_id || rfqId}</strong> has been registered. Our engineering desk will connect with you on WhatsApp/Phone shortly.`;
      successBox.classList.remove("hidden");
    }
    form.reset();
  } catch (err) {
    // Graceful offline fallback
    if (successBox) {
      successBox.innerHTML = `✓ Thank you <strong>${nameVal}</strong>! Your RFQ <strong>#${rfqId}</strong> has been logged. Our engineering desk in Naroda will connect with you shortly.`;
      successBox.classList.remove("hidden");
    }
    form.reset();
  } finally {
    if (submitBtn) {
      submitBtn.disabled = false;
      submitBtn.innerHTML = originalText;
    }
  }
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

  const payload = {
    name: inputs[0]?.value || '',
    email: inputs[1]?.value || ''
  };

  try {
    await fetch('/api/catalog', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
  } catch (err) {
    // Graceful offline fallback
  }

  if (notice) {
    notice.classList.remove("hidden");
    setTimeout(() => {
      closeCatalogModal();
      notice.classList.add("hidden");
      form.reset();
    }, 2000);
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

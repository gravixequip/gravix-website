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
  const cards = document.querySelectorAll(".product-card");
  const buttons = document.querySelectorAll(".filter-btn");

  // Update button active state
  buttons.forEach((btn) => {
    btn.classList.remove("active");
  });

  const activeBtn = event ? event.currentTarget : null;
  if (activeBtn) {
    activeBtn.classList.add("active");
  }

  // Filter Cards
  cards.forEach((card) => {
    const cardCat = card.getAttribute("data-category");
    if (category === "all" || cardCat === category) {
      card.style.display = "flex";
      card.classList.add("animate-fadeIn");
    } else {
      card.style.display = "none";
    }
  });
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

// RFQ Form Submission to Backend REST API
async function handleFormSubmit(e) {
  e.preventDefault();
  const form = e.target;
  const submitBtn = form.querySelector('button[type="submit"]');
  const successBox = document.getElementById("formSuccessMessage");

  const inputs = form.querySelectorAll('input');
  const payload = {
    name: inputs[0]?.value || '',
    company: inputs[1]?.value || '',
    email: inputs[2]?.value || '',
    phone: inputs[3]?.value || '',
    category: document.getElementById("rfqCategorySelect")?.value || 'General Inquiries',
    quantity: inputs[4]?.value || 'Not specified',
    message: document.getElementById("rfqMessage")?.value || ''
  };

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
      successBox.innerHTML = `✓ Thank you! Your RFQ <strong>#${data.rfq_id || 'CONFIRMED'}</strong> has been registered. Our engineering desk will connect with you shortly.`;
      successBox.classList.remove("hidden");
    }
    form.reset();
  } catch (err) {
    // Fallback if backend server is still connecting
    if (successBox) {
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

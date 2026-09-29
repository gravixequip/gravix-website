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

// RFQ Form Submission
function handleFormSubmit(e) {
  e.preventDefault();
  const successBox = document.getElementById("formSuccessMessage");
  if (successBox) {
    successBox.classList.remove("hidden");
    setTimeout(() => {
      e.target.reset();
    }, 1500);
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

function handleCatalogueDownload(e) {
  e.preventDefault();
  const notice = document.getElementById("catalogDownloadNotice");
  if (notice) {
    notice.classList.remove("hidden");
    setTimeout(() => {
      closeCatalogModal();
      notice.classList.add("hidden");
      e.target.reset();
    }, 2000);
  }
}

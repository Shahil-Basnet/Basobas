/**
 * utils.js - Shared utility functions for Basobas Rental Platform
 * Used across Admin, Landlord, and Tenant dashboards
 */

// ========== TOAST NOTIFICATIONS ==========

/**
 * Show a toast notification
 * @param {string} message - The message to display
 * @param {string} type - 'success', 'error', or 'warning'
 */
function showToast(message, type = 'success') {
    // Try to get existing toast or create one
    let toast = document.getElementById('toast');
    
    if (!toast) {
        // Create toast element if it doesn't exist
        toast = document.createElement('div');
        toast.id = 'toast';
        toast.className = 'toast';
        toast.innerHTML = `
            <div class="toast-content">
                <span class="material-symbols-outlined" id="toastIcon">check_circle</span>
                <span id="toastMessage"></span>
            </div>
        `;
        document.body.appendChild(toast);
        
        // Add styles if not already in CSS
        if (!document.querySelector('#toast-styles')) {
            const style = document.createElement('style');
            style.id = 'toast-styles';
            style.textContent = `
                .toast {
                    position: fixed;
                    bottom: 2rem;
                    right: 2rem;
                    z-index: 1100;
                    animation: slideIn 0.3s ease;
                }
                .toast-content {
                    background: var(--surface-container-lowest, #ffffff);
                    color: var(--on-surface, #1b1c18);
                    padding: 0.75rem 1.25rem;
                    border-radius: 0.5rem;
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    border-left: 4px solid var(--primary, #334f2b);
                    font-size: 0.875rem;
                    font-weight: 500;
                }
                .toast.success .toast-content {
                    border-left-color: #22c55e;
                }
                .toast.error .toast-content {
                    border-left-color: var(--error, #ba1a1a);
                }
                .toast.warning .toast-content {
                    border-left-color: #f59e0b;
                }
                .toast-content .material-symbols-outlined {
                    font-size: 1.25rem;
                }
                .toast.success .material-symbols-outlined {
                    color: #22c55e;
                }
                .toast.error .material-symbols-outlined {
                    color: var(--error, #ba1a1a);
                }
                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
                @keyframes fadeOut {
                    from {
                        opacity: 1;
                    }
                    to {
                        opacity: 0;
                        visibility: hidden;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }
    
    const toastIcon = document.getElementById('toastIcon');
    const toastMessage = document.getElementById('toastMessage');
    
    // Set icon based on type
    let icon = 'check_circle';
    if (type === 'error') icon = 'error';
    if (type === 'warning') icon = 'warning';
    
    if (toastIcon) toastIcon.textContent = icon;
    if (toastMessage) toastMessage.textContent = message;
    
    // Remove existing classes and add new type
    toast.classList.remove('success', 'error', 'warning');
    toast.classList.add(type);
    
    // Show toast
    toast.style.display = 'block';
    toast.style.animation = 'slideIn 0.3s ease';
    
    // Auto hide after 3 seconds
    setTimeout(() => {
        toast.style.animation = 'fadeOut 0.3s ease';
        setTimeout(() => {
            toast.style.display = 'none';
        }, 300);
    }, 3000);
}

// ========== HTML ESCAPING (XSS Prevention) ==========

/**
 * Escape HTML special characters to prevent XSS attacks
 * @param {string} str - The string to escape
 * @returns {string} Escaped string
 */
function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

// ========== DATE FORMATTING ==========

/**
 * Format a date string for display
 * @param {string} dateString - ISO date string or MySQL datetime
 * @param {boolean} includeTime - Whether to include time
 * @returns {string} Formatted date
 */
function formatDate(dateString, includeTime = true) {
    if (!dateString) return 'Never';
    
    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return dateString;
        
        const datePart = date.toLocaleDateString();
        if (!includeTime) return datePart;
        
        const timePart = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        return `${datePart} ${timePart}`;
    } catch (e) {
        return dateString;
    }
}

/**
 * Format currency for display
 * @param {number} amount - The amount to format
 * @param {string} currency - Currency code (default: USD)
 * @returns {string} Formatted currency
 */
function formatCurrency(amount, currency = 'USD') {
    if (amount === undefined || amount === null) return '-';
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currency,
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount);
}

/**
 * Format a number with commas
 * @param {number} num - The number to format
 * @returns {string} Formatted number
 */
function formatNumber(num) {
    if (num === undefined || num === null) return '0';
    return num.toLocaleString();
}

// ========== FORM VALIDATION ==========

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean} True if valid
 */
function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

/**
 * Validate phone number (simple check)
 * @param {string} phone - Phone to validate
 * @returns {boolean} True if valid
 */
function isValidPhone(phone) {
    if (!phone) return true; // Optional field
    const regex = /^[\d\s\-+()]{10,}$/;
    return regex.test(phone);
}

/**
 * Validate password strength
 * @param {string} password - Password to check
 * @returns {object} { valid: boolean, message: string }
 */
function validatePassword(password) {
    if (!password || password.length < 4) {
        return { valid: false, message: 'Password must be at least 4 characters' };
    }
    return { valid: true, message: '' };
}

// ========== CONFIRMATION DIALOG ==========

/**
 * Show a custom confirmation dialog
 * @param {string} message - Confirmation message
 * @param {string} title - Dialog title
 * @param {Function} onConfirm - Callback when confirmed
 */
function showConfirm(message, title, onConfirm) {
    let modal = document.getElementById('confirmModal');
    
    if (!modal) {
        // Create modal if it doesn't exist
        modal = document.createElement('div');
        modal.id = 'confirmModal';
        modal.className = 'modal';
        modal.style.display = 'none';
        modal.innerHTML = `
            <div class="modal-content" style="max-width: 400px;">
                <div class="modal-header">
                    <h3 id="confirmTitle">Confirm Action</h3>
                    <button class="modal-close" onclick="closeConfirmModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <p id="confirmMessage">Are you sure?</p>
                </div>
                <div class="modal-footer">
                    <button class="btn-secondary" onclick="closeConfirmModal()">Cancel</button>
                    <button id="confirmOkBtn" class="btn-primary">Confirm</button>
                </div>
            </div>
        `;
        document.body.appendChild(modal);
        
        // Add modal styles if not present
        if (!document.querySelector('#modal-styles')) {
            const style = document.createElement('style');
            style.id = 'modal-styles';
            style.textContent = `
                .modal {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                }
                .modal-content {
                    background: var(--surface-container-lowest, #ffffff);
                    border-radius: 1rem;
                    width: 90%;
                    max-width: 500px;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                }
                .modal-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 1.25rem 1.5rem;
                    border-bottom: 1px solid var(--outline-variant, #e2e8f0);
                }
                .modal-header h3 {
                    font-size: 1.25rem;
                    font-weight: 700;
                }
                .modal-close {
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    cursor: pointer;
                    color: var(--on-surface-variant, #64748b);
                }
                .modal-close:hover {
                    color: var(--error, #dc2626);
                }
                .modal-body {
                    padding: 1.5rem;
                }
                .modal-footer {
                    display: flex;
                    justify-content: flex-end;
                    gap: 1rem;
                    padding: 1.25rem 1.5rem;
                    border-top: 1px solid var(--outline-variant, #e2e8f0);
                }
            `;
            document.head.appendChild(style);
        }
    }
    
    const titleEl = document.getElementById('confirmTitle');
    const messageEl = document.getElementById('confirmMessage');
    const okBtn = document.getElementById('confirmOkBtn');
    
    if (titleEl) titleEl.textContent = title || 'Confirm Action';
    if (messageEl) messageEl.textContent = message;
    
    modal.style.display = 'flex';
    
    // Remove old listener and add new one
    const newOkBtn = okBtn.cloneNode(true);
    okBtn.parentNode.replaceChild(newOkBtn, okBtn);
    newOkBtn.addEventListener('click', () => {
        if (onConfirm) onConfirm();
        closeConfirmModal();
    });
}

/**
 * Close the confirmation modal
 */
function closeConfirmModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) modal.style.display = 'none';
}

// ========== LOADING STATES ==========

/**
 * Show a loading spinner on a button
 * @param {HTMLElement} button - The button element
 * @param {string} text - Text to show while loading
 */
function showButtonLoading(button, text = 'Loading...') {
    if (!button) return;
    button.disabled = true;
    button.dataset.originalText = button.innerHTML;
    button.innerHTML = `<span class="material-symbols-outlined" style="animation: spin 1s linear infinite;">progress_activity</span> ${text}`;
    
    // Add spin animation if not present
    if (!document.querySelector('#spin-style')) {
        const style = document.createElement('style');
        style.id = 'spin-style';
        style.textContent = `@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`;
        document.head.appendChild(style);
    }
}

/**
 * Restore button to original state
 * @param {HTMLElement} button - The button element
 */
function hideButtonLoading(button) {
    if (!button) return;
    button.disabled = false;
    if (button.dataset.originalText) {
        button.innerHTML = button.dataset.originalText;
        delete button.dataset.originalText;
    }
}

// ========== LOCAL STORAGE HELPERS ==========

/**
 * Save user preference to localStorage
 * @param {string} key - Storage key
 * @param {any} value - Value to store
 */
function savePreference(key, value) {
    localStorage.setItem(`basobas_${key}`, JSON.stringify(value));
}

/**
 * Get user preference from localStorage
 * @param {string} key - Storage key
 * @param {any} defaultValue - Default value if not found
 * @returns {any} Stored value or default
 */
function getPreference(key, defaultValue = null) {
    const value = localStorage.getItem(`basobas_${key}`);
    if (value === null) return defaultValue;
    try {
        return JSON.parse(value);
    } catch (e) {
        return value;
    }
}

// ========== DEBOUNCE FUNCTION ==========

/**
 * Debounce a function call
 * @param {Function} func - Function to debounce
 * @param {number} delay - Delay in milliseconds
 * @returns {Function} Debounced function
 */
function debounce(func, delay) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), delay);
    };
}
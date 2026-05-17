/**
 * property-form.js - Shared JavaScript for Add/Edit Property Forms
 */

// Store selected files in an array to allow appending/removing
let selectedFiles = [];
let primaryIndex = 0;

// Initialize primaryIndex based on hidden field if it exists (for edit page)
document.addEventListener('DOMContentLoaded', function() {
    const primaryInput = document.getElementById('primaryPhotoIndex');
    if (primaryInput) {
        primaryIndex = parseInt(primaryInput.value);
    }
});

/**
 * Updates the hidden file input with the currently selected files
 */
function updatePhotoInput() {
    const input = document.getElementById('photoInput');
    if (!input) return;
    
    const dt = new DataTransfer();
    selectedFiles.forEach(file => dt.items.add(file));
    input.files = dt.files;
    
    // Ensure primaryIndex is valid for new uploads
    if (selectedFiles.length > 0) {
        if (primaryIndex === -1 || primaryIndex >= selectedFiles.length) {
            // Only auto-reset to 0 if we are on add page or if we want to force a new primary
            if (document.getElementById('addPropertyForm')) {
                primaryIndex = 0;
            }
        }
    } else {
        // If no new files, reset primary index to -1 for edit page
        if (document.getElementById('editPropertyForm')) {
            primaryIndex = -1;
        }
    }
    
    const primaryInput = document.getElementById('primaryPhotoIndex');
    if (primaryInput) {
        primaryInput.value = primaryIndex;
    }
}

/**
 * Renders previews for the newly selected photos
 */
function renderPreviews() {
    const previewContainer = document.getElementById('photoPreview');
    if (!previewContainer) return;
    
    previewContainer.innerHTML = '';
    
    const isEditPage = !!document.getElementById('editPropertyForm');
    
    // Create placeholders to maintain order
    const placeholders = [];
    selectedFiles.forEach((file, index) => {
        const previewItem = document.createElement('div');
        previewItem.className = 'photo-preview-item' + (index === primaryIndex ? ' primary' : '');
        previewItem.innerHTML = '<div class="loading-spinner-small"></div>';
        previewContainer.appendChild(previewItem);
        placeholders[index] = previewItem;
    });

    selectedFiles.forEach((file, index) => {
        const reader = new FileReader();
        reader.onload = function(e) {
            const previewItem = placeholders[index];
            
            const primaryText = index === primaryIndex 
                ? (isEditPage ? 'NEW PRIMARY' : 'PRIMARY PHOTO') 
                : 'SET AS PRIMARY';
            
            previewItem.innerHTML = `
                <img src="${e.target.result}" alt="Preview">
                <div class="primary-star">
                    <span class="material-symbols-outlined">star</span>
                </div>
                <div class="remove-photo" onclick="removeSelectedPhoto(${index})">×</div>
                <div class="set-primary-overlay" onclick="setAsNewPrimary(${index})">
                    ${primaryText}
                </div>
            `;
        };
        reader.readAsDataURL(file);
    });
    
    updatePhotoInput();
}

/**
 * Removes a photo from the newly selected files
 */
function removeSelectedPhoto(index) {
    selectedFiles.splice(index, 1);
    if (index === primaryIndex) {
        const isEditPage = !!document.getElementById('editPropertyForm');
        primaryIndex = isEditPage ? -1 : 0;
    } else if (index < primaryIndex) {
        primaryIndex--;
    }
    renderPreviews();
}

/**
 * Sets a new photo as the primary photo
 */
function setAsNewPrimary(index) {
    primaryIndex = index;
    renderPreviews();
}

// Alias for add page compatibility
function setAsPrimary(index) {
    setAsNewPrimary(index);
}

// ========== REAL-TIME VALIDATION ==========

function validateTitle() {
    const input = document.getElementById('title');
    if (!input) return true;
    const error = document.getElementById('titleError');
    const value = input.value.trim();
    
    if (value === '') {
        if (error) error.textContent = 'Property title is required';
        input.classList.add('error');
        return false;
    }
    if (value.length < 3) {
        if (error) error.textContent = 'Title must be at least 3 characters';
        input.classList.add('error');
        return false;
    }
    if (value.length > 200) {
        if (error) error.textContent = 'Title must be less than 200 characters';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateCity() {
    const input = document.getElementById('city');
    if (!input) return true;
    const error = document.getElementById('cityError');
    const value = input.value.trim();
    
    if (value === '') {
        if (error) error.textContent = 'City is required';
        input.classList.add('error');
        return false;
    }
    if (value.length < 2) {
        if (error) error.textContent = 'City name must be at least 2 characters';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validatePropertyType() {
    const select = document.getElementById('propertyType');
    if (!select) return true;
    const error = document.getElementById('propertyTypeError');
    
    if (select.value === '') {
        if (error) error.textContent = 'Please select a property type';
        select.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    select.classList.remove('error');
    return true;
}

function validateBedrooms() {
    const input = document.getElementById('bedrooms');
    if (!input) return true;
    const error = document.getElementById('bedroomsError');
    let value = parseInt(input.value);
    
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter number of bedrooms';
        input.classList.add('error');
        return false;
    }
    if (value < 0) {
        if (error) error.textContent = 'Bedrooms cannot be negative';
        input.classList.add('error');
        return false;
    }
    if (value > 20) {
        if (error) error.textContent = 'Bedrooms cannot exceed 20';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateBathrooms() {
    const input = document.getElementById('bathrooms');
    if (!input) return true;
    const error = document.getElementById('bathroomsError');
    let value = parseFloat(input.value);
    
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter number of bathrooms';
        input.classList.add('error');
        return false;
    }
    if (value < 0) {
        if (error) error.textContent = 'Bathrooms cannot be negative';
        input.classList.add('error');
        return false;
    }
    if (value > 10) {
        if (error) error.textContent = 'Bathrooms cannot exceed 10';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateMonthlyRent() {
    const input = document.getElementById('monthlyRent');
    if (!input) return true;
    const error = document.getElementById('monthlyRentError');
    let value = parseFloat(input.value);
    
    if (isNaN(value) || input.value === '') {
        if (error) error.textContent = 'Monthly rent is required';
        input.classList.add('error');
        return false;
    }
    if (value <= 0) {
        if (error) error.textContent = 'Monthly rent must be greater than 0';
        input.classList.add('error');
        return false;
    }
    if (value > 10000000) {
        if (error) error.textContent = 'Monthly rent is too high';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateWardNumber() {
    const input = document.getElementById('wardNumber');
    if (!input) return true;
    const error = document.getElementById('wardNumberError');
    
    if (input.value === '') {
        if (error) error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    let value = parseInt(input.value);
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter a valid ward number';
        input.classList.add('error');
        return false;
    }
    if (value < 1 || value > 35) {
        if (error) error.textContent = 'Ward number must be between 1 and 35';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateFloorNumber() {
    const input = document.getElementById('floorNumber');
    if (!input) return true;
    const error = document.getElementById('floorNumberError');
    
    if (input.value === '') {
        if (error) error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    let value = parseInt(input.value);
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter a valid floor number';
        input.classList.add('error');
        return false;
    }
    if (value < 0) {
        if (error) error.textContent = 'Floor number cannot be negative';
        input.classList.add('error');
        return false;
    }
    if (value > 50) {
        if (error) error.textContent = 'Floor number cannot exceed 50';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validatePowerBackup() {
    const input = document.getElementById('powerBackupHours');
    if (!input) return true;
    const error = document.getElementById('powerBackupError');
    
    if (input.value === '') {
        if (error) error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    let value = parseInt(input.value);
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter a valid number of hours';
        input.classList.add('error');
        return false;
    }
    if (value < 0) {
        if (error) error.textContent = 'Hours cannot be negative';
        input.classList.add('error');
        return false;
    }
    if (value > 24) {
        if (error) error.textContent = 'Hours cannot exceed 24';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateSecurityDeposit() {
    const input = document.getElementById('securityDeposit');
    if (!input) return true;
    const error = document.getElementById('securityDepositError');
    
    if (input.value === '') {
        if (error) error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    let value = parseFloat(input.value);
    if (isNaN(value)) {
        if (error) error.textContent = 'Please enter a valid amount';
        input.classList.add('error');
        return false;
    }
    if (value < 0) {
        if (error) error.textContent = 'Deposit cannot be negative';
        input.classList.add('error');
        return false;
    }
    if (value > 10000000) {
        if (error) error.textContent = 'Deposit amount is too high';
        input.classList.add('error');
        return false;
    }
    if (error) error.textContent = '';
    input.classList.remove('error');
    return true;
}

function validateForm() {
    const validations = [
        validateTitle(),
        validateCity(),
        validatePropertyType(),
        validateBedrooms(),
        validateBathrooms(),
        validateMonthlyRent(),
        validateWardNumber(),
        validateFloorNumber(),
        validatePowerBackup(),
        validateSecurityDeposit()
    ];
    
    const allValid = validations.every(v => v === true);
    
    if (!allValid) {
        const firstError = document.querySelector('.error');
        if (firstError) {
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false;
    }
    
    return true;
}

function limitInput(input, min, max) {
    let value = parseFloat(input.value);
    if (!isNaN(value)) {
        if (value < min) input.value = min;
        if (value > max) input.value = max;
    }
}

// ========== INITIALIZATION ==========

document.addEventListener('DOMContentLoaded', function() {
    // Initialize photo input listener
    const photoInput = document.getElementById('photoInput');
    if (photoInput) {
        photoInput.addEventListener('change', function() {
            if (this.files) {
                for (let i = 0; i < this.files.length; i++) {
                    selectedFiles.push(this.files[i]);
                }
                renderPreviews();
            }
        });
    }

    // Set up form field IDs and error spans
    const fieldNames = [
        'title', 'city', 'propertyType', 'bedrooms', 'bathrooms', 
        'monthlyRent', 'wardNumber', 'floorNumber', 'powerBackupHours', 'securityDeposit'
    ];
    
    fieldNames.forEach(name => {
        const input = document.querySelector(`[name="${name}"]`);
        if (input) {
            if (!input.id) input.id = name;
            
            if (!document.getElementById(name + 'Error')) {
                const errorSpan = document.createElement('div');
                errorSpan.id = name + 'Error';
                errorSpan.className = 'form-error';
                input.parentNode.appendChild(errorSpan);
            }
            
            // Add real-time validation
            input.addEventListener('input', () => {
                switch(name) {
                    case 'title': validateTitle(); break;
                    case 'city': validateCity(); break;
                    case 'propertyType': validatePropertyType(); break;
                    case 'bedrooms': validateBedrooms(); break;
                    case 'bathrooms': validateBathrooms(); break;
                    case 'monthlyRent': validateMonthlyRent(); break;
                    case 'wardNumber': validateWardNumber(); break;
                    case 'floorNumber': validateFloorNumber(); break;
                    case 'powerBackupHours': validatePowerBackup(); break;
                    case 'securityDeposit': validateSecurityDeposit(); break;
                }
            });
            
            input.addEventListener('blur', () => {
                switch(name) {
                    case 'title': validateTitle(); break;
                    case 'city': validateCity(); break;
                    case 'propertyType': validatePropertyType(); break;
                    case 'bedrooms': validateBedrooms(); break;
                    case 'bathrooms': validateBathrooms(); break;
                    case 'monthlyRent': validateMonthlyRent(); break;
                    case 'wardNumber': validateWardNumber(); break;
                    case 'floorNumber': validateFloorNumber(); break;
                    case 'powerBackupHours': validatePowerBackup(); break;
                    case 'securityDeposit': validateSecurityDeposit(); break;
                }
            });
        }
    });

    // Add real-time limits to number inputs
    const bathroomsInput = document.querySelector('input[name="bathrooms"]');
    if (bathroomsInput) {
        bathroomsInput.addEventListener('change', function() {
            limitInput(this, 0, 10);
        });
    }
    
    const bedroomsInput = document.querySelector('input[name="bedrooms"]');
    if (bedroomsInput) {
        bedroomsInput.addEventListener('change', function() {
            limitInput(this, 0, 20);
        });
    }
    
    const wardInput = document.querySelector('input[name="wardNumber"]');
    if (wardInput) {
        wardInput.addEventListener('change', function() {
            if (this.value !== '') limitInput(this, 1, 35);
        });
    }
    
    const powerInput = document.querySelector('input[name="powerBackupHours"]');
    if (powerInput) {
        powerInput.addEventListener('change', function() {
            if (this.value !== '') limitInput(this, 0, 24);
        });
    }

    // Form submission validation
    const addForm = document.getElementById('addPropertyForm');
    const editForm = document.getElementById('editPropertyForm');
    const form = addForm || editForm;

    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                // Show toast or alert
                const errorMsg = document.createElement('div');
                errorMsg.className = 'error-alert';
                errorMsg.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 1000;';
                errorMsg.innerHTML = `
                    <span class="material-symbols-outlined error-icon">error</span>
                    <div class="error-text">Please fix the errors in the form before submitting.</div>
                `;
                document.body.appendChild(errorMsg);
                setTimeout(() => errorMsg.remove(), 3000);
            }
        });
    }
});

// ========== EDIT PAGE SPECIFIC AJAX ==========

function deletePhoto(photoId) {
    showConfirm('Are you sure you want to delete this photo?', 'Confirm Delete', function() {
        fetch(window.contextPath + '/landlord/properties?action=deletePhoto&photoId=' + photoId, {
            method: 'POST'
        }).then(response => response.json())
          .then(data => {
              if (data.success) {
                  // Remove the photo card from DOM
                  const photoCard = document.querySelector(`.photo-card[data-photo-id="${photoId}"]`);
                  if (photoCard) photoCard.remove();
                  showToast('Photo deleted successfully', 'success');
              } else {
                  showToast('Failed to delete photo', 'error');
              }
          });
    });
}

function setPrimaryPhoto(photoId) {
    fetch(window.contextPath + '/landlord/properties?action=setPrimary&photoId=' + photoId, {
        method: 'POST'
    }).then(response => response.json())
      .then(data => {
          if (data.success) {
              window.location.reload();
          } else {
              showToast('Failed to set primary photo', 'error');
          }
      });
}

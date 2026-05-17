document.addEventListener('DOMContentLoaded', function() {
    // Toggle request form
    const showBtn = document.getElementById('showRequestFormBtn');
    const requestForm = document.getElementById('requestForm');
    const cancelBtn = document.getElementById('cancelRequestBtn');

    if (showBtn) {
        showBtn.addEventListener('click', function() {
            requestForm.style.display = 'block';
            showBtn.style.display = 'none';
        });
    }

    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            requestForm.style.display = 'none';
            if (showBtn) showBtn.style.display = 'flex';
        });
    }

    // Form submission with AJAX
    const rentalForm = document.getElementById('rentalRequestForm');
    if (rentalForm) {
        rentalForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get values directly from form inputs
            const propertyId = document.querySelector('input[name="propertyId"]').value;
            const moveInDate = document.getElementById('moveInDate').value;
            const leaseDuration = document.getElementById('leaseDuration').value;
            const message = document.getElementById('message').value;
            
            // Validate
            if (!propertyId) {
                showToast('Property ID is missing', 'error');
                return;
            }
            if (!moveInDate) {
                showToast('Please select a move-in date', 'warning');
                return;
            }
            if (!leaseDuration) {
                showToast('Please select lease duration', 'warning');
                return;
            }
            
            // Send as JSON instead of FormData
            fetch(window.contextPath + '/tenant/submit-request', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    propertyId: propertyId,
                    moveInDate: moveInDate,
                    leaseDuration: leaseDuration,
                    message: message
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message || 'Rental request submitted successfully!', 'success');
                    requestForm.style.display = 'none';
                    if (showBtn) {
                        showBtn.style.display = 'none';
                    }
                    const successDiv = document.createElement('div');
                    successDiv.style.cssText = 'text-align: center; padding: 1rem; background: #d1fae5; border-radius: 0.5rem; margin-top: 1rem; color: #059669;';
                    successDiv.innerHTML = '<span class="material-symbols-outlined" style="vertical-align: middle;">check_circle</span> Request submitted! The landlord will review your request.';
                    document.querySelector('.request-section').appendChild(successDiv);
                } else {
                    showToast(data.message || 'Failed to submit request. Please try again.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred. Please try again.', 'error');
            });
        });
    }
});

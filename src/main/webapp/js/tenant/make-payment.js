document.addEventListener('DOMContentLoaded', function() {
    // Auto-fill amount when property is selected
    const propertySelect = document.getElementById('propertyId');
    if (propertySelect) {
        propertySelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const rent = selectedOption.getAttribute('data-rent');
            if (rent && rent !== 'null' && rent !== '') {
                document.getElementById('amount').value = rent;
            } else {
                document.getElementById('amount').value = '';
            }
        });
    }

    // Populate year dropdown (current year - 1 to current year + 2)
    const yearSelect = document.getElementById('paymentYear');
    if (yearSelect) {
        const currentYear = new Date().getFullYear();
        for (let i = currentYear - 1; i <= currentYear + 2; i++) {
            const option = document.createElement('option');
            option.value = i;
            option.textContent = i;
            if (i === currentYear) {
                option.selected = true;
            }
            yearSelect.appendChild(option);
        }
    }

    // Set default month to current month
    const monthInput = document.getElementById('paymentMonthName');
    if (monthInput) {
        const currentMonth = new Date().getMonth() + 1;
        monthInput.value = currentMonth;
    }

    // Form submission
    const paymentForm = document.getElementById('paymentForm');
    if (paymentForm) {
        paymentForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get values
            const propertyId = document.getElementById('propertyId').value;
            const amount = document.getElementById('amount').value;
            const paymentYear = document.getElementById('paymentYear').value;
            const paymentMonthName = document.getElementById('paymentMonthName').value;
            const paymentMethod = document.getElementById('paymentMethod').value;
            const transactionReference = document.getElementById('transactionReference').value;
            const notes = document.getElementById('notes').value;
            
            // Combine year and month into YYYY-MM format
            const paymentMonth = `${paymentYear}-${String(paymentMonthName).padStart(2, '0')}`;
            
            // Validate
            if (!propertyId) {
                showToast('Please select a property', 'error');
                return;
            }
            
            if (!amount || amount <= 0) {
                showToast('Please enter a valid amount', 'error');
                return;
            }
            
            if (!paymentYear || !paymentMonthName) {
                showToast('Please select year and month', 'error');
                return;
            }
            
            if (!paymentMethod) {
                showToast('Please select a payment method', 'error');
                return;
            }
            
            // Create FormData
            const formData = new FormData();
            formData.append('propertyId', propertyId);
            formData.append('amount', amount);
            formData.append('paymentMonth', paymentMonth);
            formData.append('paymentMethod', paymentMethod);
            formData.append('transactionReference', transactionReference || '');
            formData.append('notes', notes || '');
            
            // Disable submit button
            const submitBtn = document.querySelector('#paymentForm button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="material-symbols-outlined" style="animation: spin 1s linear infinite;">progress_activity</span> Processing...';
            
            fetch(window.contextPath + '/tenant/payments/make', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    setTimeout(() => {
                        window.location.href = window.contextPath + '/tenant/payments';
                    }, 1500);
                } else {
                    showToast(data.message || 'Failed to submit payment', 'error');
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('An error occurred: ' + error.message, 'error');
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            });
        });
    }

    // Add spin animation style if not present
    if (!document.querySelector('#spin-style')) {
        const style = document.createElement('style');
        style.id = 'spin-style';
        style.textContent = `@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`;
        document.head.appendChild(style);
    }
});

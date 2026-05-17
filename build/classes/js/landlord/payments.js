function verifyPayment(paymentId, status) {
    const action = status === 'completed' ? 'approve' : 'reject';
    showConfirm('Are you sure you want to ' + action + ' this payment?', 'Confirm Verification', function() {
        fetch(window.contextPath + '/landlord/payments/verify', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'paymentId=' + paymentId + '&status=' + status
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast(data.message, 'success');
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast(data.message || 'Failed to update payment', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An error occurred', 'error');
        });
    });
}

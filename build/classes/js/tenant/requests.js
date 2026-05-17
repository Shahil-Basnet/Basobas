function cancelRequest(requestId) {
    showConfirm('Are you sure you want to cancel this request?', 'Confirm Cancel', function() {
        fetch(window.contextPath + '/tenant/cancel-request', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'requestId=' + requestId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast('Request cancelled successfully', 'success');
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast(data.message || 'Failed to cancel request', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An error occurred', 'error');
        });
    });
}

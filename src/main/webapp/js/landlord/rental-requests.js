document.addEventListener('DOMContentLoaded', function() {
    // Search functionality
    document.getElementById('searchInput')?.addEventListener('keyup', function() {
        const searchTerm = this.value.toLowerCase();
        const cards = document.querySelectorAll('.request-card');
        
        cards.forEach(card => {
            const text = card.innerText.toLowerCase();
            if (text.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    });

    // Submit response
    document.getElementById('submitResponseBtn')?.addEventListener('click', function() {
        const responseMessage = document.getElementById('responseMessage').value;
        
        fetch(window.contextPath + '/landlord/requests/' + currentAction, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'requestId=' + currentRequestId + '&responseMessage=' + encodeURIComponent(responseMessage)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showToast(data.message, 'success');
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast(data.message || 'Failed to process request', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('An error occurred', 'error');
        });
    });

    // Close modal when clicking outside
    document.getElementById('responseModal')?.addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
});

// Global modal variables
let currentRequestId = null;
let currentAction = null;

function openResponseModal(requestId, action) {
    currentRequestId = requestId;
    currentAction = action;
    const modalTitle = document.getElementById('modalTitle');
    if (modalTitle) {
        modalTitle.innerText = action === 'approve' ? 'Approve Request' : 'Reject Request';
    }
    document.getElementById('responseMessage').value = '';
    document.getElementById('responseModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('responseModal').style.display = 'none';
    currentRequestId = null;
    currentAction = null;
}

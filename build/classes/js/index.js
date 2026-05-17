function searchProperties() {
    const searchTerm = document.getElementById('homeSearch').value.trim();
    if (searchTerm) {
        window.location.href = window.contextPath + '/properties?search=' + encodeURIComponent(searchTerm);
    } else {
        window.location.href = window.contextPath + '/properties';
    }
}

// Allow Enter key to search
document.getElementById('homeSearch')?.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        searchProperties();
    }
});

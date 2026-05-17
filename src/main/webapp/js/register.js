document.addEventListener('DOMContentLoaded', function() {
    // Toggle password visibility for Password field
    var regToggle = document.getElementById('toggleRegPassword');
    var regPassword = document.getElementById('regPassword');
    if (regToggle && regPassword) {
        regToggle.addEventListener('click', function() {
            var type = regPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            regPassword.setAttribute('type', type);
            regToggle.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    }

    // Toggle password visibility for Confirm Password field
    var confirmToggle = document.getElementById('toggleConfirmPassword');
    var confirmPassword = document.getElementById('confirmPassword');
    if (confirmToggle && confirmPassword) {
        confirmToggle.addEventListener('click', function() {
            var type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPassword.setAttribute('type', type);
            confirmToggle.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    }
});

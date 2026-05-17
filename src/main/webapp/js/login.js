// Toggle password visibility for Login field
document.addEventListener('DOMContentLoaded', function() {
    var toggleBtn = document.getElementById('togglePassword');
    var passwordInput = document.getElementById('password');
    if (toggleBtn && passwordInput) {
        toggleBtn.addEventListener('click', function() {
            var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            toggleBtn.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    }
});

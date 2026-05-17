<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Basobas</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <main>
        <div class="container" style="padding: 3rem 1rem;">
            <div style="max-width: 600px; margin: 0 auto;">
                <div style="text-align: center; margin-bottom: 2rem;">
                    <h1 style="font-size: 2rem;">Contact Us</h1>
                    <p style="color: var(--on-surface-variant);">We'd love to hear from you</p>
                </div>
                
                <!-- Contact Info -->
                <div style="display: flex; justify-content: center; gap: 2rem; margin-bottom: 2rem; flex-wrap: wrap;">
                    <div style="text-align: center;">
                        <span class="material-symbols-outlined" style="font-size: 2rem; color: var(--primary);">email</span>
                        <p style="margin-top: 0.5rem;">info@basobas.com</p>
                    </div>
                    <div style="text-align: center;">
                        <span class="material-symbols-outlined" style="font-size: 2rem; color: var(--primary);">phone</span>
                        <p style="margin-top: 0.5rem;">+977 1-2345678</p>
                    </div>
                    <div style="text-align: center;">
                        <span class="material-symbols-outlined" style="font-size: 2rem; color: var(--primary);">location_on</span>
                        <p style="margin-top: 0.5rem;">Kathmandu, Nepal</p>
                    </div>
                </div>
                
                <!-- Contact Form -->
                <div class="dashboard-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
                    <div style="padding: 1.5rem;">
                        <form id="contactForm">
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Your Name</label>
                                <input type="text" id="name" class="form-input" required style="width: 100%; padding: 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Email Address</label>
                                <input type="email" id="email" class="form-input" required style="width: 100%; padding: 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Subject</label>
                                <input type="text" id="subject" class="form-input" required style="width: 100%; padding: 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Message</label>
                                <textarea id="message" rows="4" class="form-input" required style="width: 100%; padding: 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; resize: vertical;"></textarea>
                            </div>
                            
                            <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">
                                <span class="material-symbols-outlined">send</span>
                                Send Message
                            </button>
                        </form>
                        
                        <div id="formMessage" style="margin-top: 1rem; text-align: center; display: none;"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
    
    <script>
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value.trim();
            const message = document.getElementById('message').value.trim();
            const messageDiv = document.getElementById('formMessage');
            
            // Validation
            if (!name) {
                showToast('Please enter your name', 'error');
                return;
            }
            
            if (!email) {
                showToast('Please enter your email', 'error');
                return;
            }
            
            // Simple email validation
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                showToast('Please enter a valid email address', 'error');
                return;
            }
            
            if (!subject) {
                showToast('Please enter a subject', 'error');
                return;
            }
            
            if (!message) {
                showToast('Please enter your message', 'error');
                return;
            }
            
            // Success message
            messageDiv.style.display = 'block';
            messageDiv.style.background = '#d1fae5';
            messageDiv.style.color = '#059669';
            messageDiv.style.padding = '0.75rem';
            messageDiv.style.borderRadius = '0.5rem';
            messageDiv.innerHTML = 'Thank you for your message! We will get back to you soon.';
            
            // Reset form
            document.getElementById('contactForm').reset();
            
            // Hide success message after 5 seconds
            setTimeout(() => {
                messageDiv.style.display = 'none';
            }, 5000);
        });
    </script>
    
    <style>
        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(51, 79, 43, 0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-container));
            color: white;
            padding: 0.75rem;
            border-radius: 0.5rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
    </style>
</body>
</html>
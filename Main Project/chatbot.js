    // Chatbot functionality
    document.addEventListener('DOMContentLoaded', function() {
        const chatbotContainer = document.getElementById('chatbotContainer');
        const chatbotToggle = document.getElementById('chatbotToggle');
        const chatMessages = document.getElementById('chatMessages');
        const chatInput = document.getElementById('chatInput');
        const chatSend = document.getElementById('chatSend');
        
        // Toggle chatbot open/close
        chatbotToggle.addEventListener('click', function() {
            chatbotContainer.classList.toggle('chatbot-closed');
            chatbotContainer.classList.toggle('chatbot-open');
            if (chatbotContainer.classList.contains('chatbot-open')) {
                chatInput.focus();
            }
        });
        
        // Send message function
        function sendMessage() {
            const userMsg = chatInput.value.trim();
            if (!userMsg) return;
            
            // Add user message to chat
            addMessage(userMsg, 'user');
            
            // Clear input
            chatInput.value = '';
            
            // Show typing indicator
            const typingIndicator = document.createElement('div');
            typingIndicator.className = 'typing-indicator';
            typingIndicator.innerHTML = `
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
                <div class="typing-dot"></div>
            `;
            chatMessages.appendChild(typingIndicator);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Disable send button while processing
            chatSend.disabled = true;
            
            // Get current topic from page
            const selectedTopic = document.getElementById('currentTopic')?.textContent || 'Tailwind CSS';
            
            // Send message to backend
            fetch('https://joyr13384.app.n8n.cloud/webhook/98594f76-a4df-4e7c-a9f7-85167da4528a', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: userMsg, topic: selectedTopic })
            })
            .then(res => res.text())
            .then(text => {
                // Remove typing indicator
                chatMessages.removeChild(typingIndicator);
                
                // Add bot response with markdown rendering
                addMessage(text, 'bot');
                
                // Re-enable send button
                chatSend.disabled = false;
            })
            .catch(error => {
                // Remove typing indicator
                chatMessages.removeChild(typingIndicator);
                
                // Show error message
                addMessage('Sorry, I encountered an error. Please try again later.', 'bot');
                
                // Re-enable send button
                chatSend.disabled = false;
                console.error('Error:', error);
            });
        }
        
        // Add message to chat
        function addMessage(text, sender) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}-message`;
            
            if (sender === 'bot') {
                // Convert markdown to HTML for bot messages
                const markdownContent = document.createElement('div');
                markdownContent.className = 'markdown-content';
                markdownContent.innerHTML = parseMarkdown(text);
                messageDiv.appendChild(markdownContent);
            } else {
                // User messages are plain text
                messageDiv.textContent = text;
            }
            
            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        // Simple markdown parser
        function parseMarkdown(text) {
            // Convert headers
            text = text.replace(/^### (.*$)/gim, '<h3>$1</h3>');
            text = text.replace(/^## (.*$)/gim, '<h2>$1</h2>');
            text = text.replace(/^# (.*$)/gim, '<h1>$1</h1>');
            
            // Convert bold and italic
            text = text.replace(/\*\*(.*?)\*\*/gim, '<strong>$1</strong>');
            text = text.replace(/\*(.*?)\*/gim, '<em>$1</em>');
            
            // Convert code blocks
            text = text.replace(/```([\s\S]*?)```/gim, '<pre><code>$1</code></pre>');
            text = text.replace(/`(.*?)`/gim, '<code>$1</code>');
            
            // Convert links
            text = text.replace(/\[([^\[]+)\]\(([^\)]+)\)/gim, '<a href="$2" target="_blank">$1</a>');
            
            // Convert paragraphs
            text = text.replace(/(\n\n|\r\r|\r\n\r\n)/gim, '</p><p>');
            text = text.replace(/(\n|\r|\r\n)/gim, '<br>');
            text = '<p>' + text + '</p>';
            
            // Convert lists
            text = text.replace(/^\s*\- (.*$)/gim, '<li>$1</li>');
            text = text.replace(/(<li>.*<\/li>)/gim, '<ul>$1</ul>');
            
            // Convert blockquotes
            text = text.replace(/^>\s(.*$)/gim, '<blockquote>$1</blockquote>');
            
            return text;
        }
        
        // Event listeners
        chatSend.addEventListener('click', sendMessage);
        chatInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    });
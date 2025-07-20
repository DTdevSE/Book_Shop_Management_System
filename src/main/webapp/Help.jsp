<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chatbot Demo</title>
    <style>
        #chatbox {
            width: 400px;
            height: 400px;
            border: 1px solid #ccc;
            padding: 10px;
            overflow-y: scroll;
            margin-bottom: 10px;
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
        }
        .message {
            margin: 5px 0;
        }
        .user {
            color: blue;
            font-weight: bold;
        }
        .bot {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>💬 Chat with AI</h2>
    <div id="chatbox"></div>
    <input type="text" id="userInput" style="width:300px" placeholder="Type your message..." onkeydown="if(event.key === 'Enter') sendMessage();"/>
    <button onclick="sendMessage()">Send</button>

    <script>
        function appendMessage(sender, text) {
            const chatbox = document.getElementById('chatbox');
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message ' + sender;
            msgDiv.textContent = (sender === 'user' ? 'You: ' : 'Bot: ') + text;
            chatbox.appendChild(msgDiv);
            chatbox.scrollTop = chatbox.scrollHeight;
        }

        function sendMessage() {
            const input = document.getElementById('userInput');
            const message = input.value.trim();
            if (!message) return;

            appendMessage('user', message);
            input.value = '';

            fetch('<%= request.getContextPath() %>/ChatBotServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'message=' + encodeURIComponent(message)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Server error: " + response.status);
                }
                return response.json();
            })
            .then(data => {
                const botReply = data.choices?.[0]?.message?.content || "No response.";
                appendMessage('bot', botReply);
            })
            .catch(err => appendMessage('bot', 'Error: ' + err.message));
        }
    </script>
</body>
</html>

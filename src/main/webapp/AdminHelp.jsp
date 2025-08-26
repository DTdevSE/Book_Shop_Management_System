<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Help Center</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #c9d6ff, #e2e2e2);
            color: #333;
        }
        .hero {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            color: white;
            padding: 60px 20px;
            text-align: center;
            position: relative;
        }
        .hero h1 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 12px;
        }
        .hero p {
            font-size: 16px;
            opacity: 0.9;
        }
        .search-box {
            margin: 30px auto;
            max-width: 600px;
        }
        .search-box input {
            width: 100%;
            padding: 14px;
            border-radius: 8px;
            border: none;
            font-size: 16px;
        }
        .hero-buttons {
            position: absolute;
            top: 30px;
            right: 40px;
        }
        .hero-buttons a {
            text-decoration: none;
            padding: 10px 20px;
            margin-left: 10px;
            border-radius: 6px;
            font-weight: 600;
            color: white;
        }
        .btn-primary { background: #5a4bff; }
        .btn-secondary { background: #2b2b2b; }

        .illustration {
            position: absolute;
            right: 60px;
            top: 100px;
        }
        .illustration img {
            max-height: 220px;
        }

        .features {
            display: flex;
            justify-content: space-around;
            background: white;
            padding: 40px 20px;
            margin-top: -50px;
            border-radius: 16px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .feature-box {
            flex: 1;
            padding: 20px;
            text-align: center;
        }
        .feature-box h3 {
            color: #6a11cb;
            margin-bottom: 10px;
        }
        .feature-box p {
            font-size: 14px;
            line-height: 1.6;
        }
        .feature-box a {
            display: inline-block;
            margin-top: 10px;
            color: #6a11cb;
            font-weight: 600;
            text-decoration: none;
        }

        /* Chat button and container (reused) */
        #openChatBtn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #6a11cb;
            color: white;
            border: none;
            padding: 14px 20px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            box-shadow: 0 6px 12px rgba(0,0,0,0.2);
        }

        .chat-container {
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 360px;
            height: 500px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 12px 24px rgba(0,0,0,0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
            z-index: 999;
        }

        .chat-header {
            background: #6a11cb;
            color: white;
            padding: 14px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-header span { font-weight: 600; }
        .close-chat {
            background: transparent;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }

        .chat-messages {
            flex: 1;
            padding: 12px;
            overflow-y: auto;
            background: #f3f3f3;
        }

        .message {
            margin-bottom: 10px;
            display: flex;
        }
        .message.left { flex-direction: row; }
        .message.right { flex-direction: row-reverse; }
        .message img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
        }
        .message .content {
            max-width: 70%;
            margin: 0 10px;
            padding: 10px 14px;
            border-radius: 16px;
            background: #e0e0e0;
        }
        .message.right .content {
            background: #6a11cb;
            color: white;
        }

        .chat-input {
            padding: 10px;
            border-top: 1px solid #ddd;
            display: flex;
        }
        .chat-input input {
            flex: 1;
            padding: 10px;
            border-radius: 20px;
            border: 1px solid #ccc;
            outline: none;
        }
        .chat-input button {
            margin-left: 10px;
            background: #6a11cb;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 20px;
            font-weight: 600;
            cursor: pointer;
        }
         .back-btn {
    display: inline-flex;
    align-items: center;
    background-color: #eee;
    border: 1px solid #ccc;
    padding: 6px 12px;
    cursor: pointer;
    font-size: 16px;
    border-radius: 4px;
    transition: background-color 0.2s ease;
    text-decoration: none;
    color: #333;
    margin-bottom: 20px;
    margin-right:1200px;
}
.back-btn i {
    margin-right: 6px;
}
.back-btn:hover {
    background-color: #ddd;
    color: #000;
}
        
    </style>
</head>
<body>

<div class="hero">
    <!-- Back Button -->
    <a href="AdminHome.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>
    
    <h1>How can we help you?</h1>
    <p>Have questions? Search through our Help Center.</p>

    <div class="search-box">
        <input type="text" placeholder="Enter a question, topic or keyword">
    </div>

    <div class="illustration">
        <img src="https://cdn.pixabay.com/photo/2024/07/14/07/46/customer-service-8893905_1280.png">
    </div>
</div>

<div class="features">
    <div class="feature-box">
        <h3>FAQs</h3>
        <p>Answers to frequently asked questions about your account, services, or usage.</p>
        <a href="#" onclick="showFaqMessage(event)">View FAQ →</a>
        <p id="faq-message" style="display:none; color: red; margin-top: 10px; font-weight: bold;">Under maintenance… Available soon.</p>

    </div>
    <div class="feature-box">
        <h3>Guides & Resources</h3>
        <p>Step-by-step guides and UI documentation to help you use the system effectively.</p>
        <a href="AdminGuideline.jsp">Browse Guides →</a>
    </div>
    <div class="feature-box">
        <h3>Support</h3>
        <p>Still need help? Contact our support team directly to get assistance.</p>
        <a href="#" onclick="showSupportMessage(event)">Submit a Request →</a>
<p id="support-message" style="display:none; color: red; margin-top: 10px; font-weight: bold;"> Under maintenance… Available soon.</p>

    </div>
</div>

<!-- Chat Button -->
<button id="openChatBtn">Team Chat</button>

<!-- Chat Box -->
<div class="chat-container" id="chatContainer">
    <div class="chat-header">
        <span>Team Chat</span>
        <button class="close-chat" onclick="closeChat()">✕</button>
    </div>
    <div class="chat-messages" id="chatMessages"></div>
    <div class="chat-input">
        <input type="text" id="messageInput" placeholder="Type a message...">
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<script>
    const username = "<%=username%>";
    const chatContainer = document.getElementById('chatContainer');
    const openChatBtn = document.getElementById('openChatBtn');

    openChatBtn.addEventListener('click', () => {
        chatContainer.style.display = "flex";
        openChatBtn.style.display = "none";
        fetchMessages();
    });

    function closeChat() {
        chatContainer.style.display = "none";
        openChatBtn.style.display = "block";
    }

    function fetchMessages() {
        fetch('TeamChatServlet')
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById('chatMessages');
                chatBox.innerHTML = "";
                data.forEach(msg => {
                    const div = document.createElement('div');
                    div.className = "message " + (msg.sender === username ? "right" : "left");
                    let imgSrc = msg.profile || "default-user.png";
                    const img = document.createElement('img'); img.src = imgSrc;
                    const content = document.createElement('div');
                    content.className = "content";
                    content.innerHTML = "<strong>" + msg.sender + ":</strong> " + msg.message + "<br><small>" + msg.timestamp + "</small>";
                    div.appendChild(img);
                    div.appendChild(content);
                    chatBox.appendChild(div);
                });
                chatBox.scrollTop = chatBox.scrollHeight;
            });
    }

    function sendMessage() {
        const input = document.getElementById('messageInput');
        const message = input.value.trim();
        if (message === "") return;

        fetch('TeamChatServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: "message=" + encodeURIComponent(message)
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === "ok") {
                input.value = "";
                fetchMessages();
            } else {
                alert(data.error);
            }
        });
    }

    setInterval(() => {
        if (chatContainer.style.display === "flex") fetchMessages();
    }, 2000);
    
    
    
    
    function showFaqMessage(event) {
        event.preventDefault();
        const msg = document.getElementById('faq-message');
        msg.style.display = 'block';

        
        setTimeout(() => {
            msg.style.display = 'none';
        }, 2000);
    }
    function showSupportMessage(event) {
        event.preventDefault();
        const msg = document.getElementById('support-message');
        msg.style.display = 'block';

     
        setTimeout(() => {
            msg.style.display = 'none';
        }, 2000);
    }

</script>

</body>
</html>

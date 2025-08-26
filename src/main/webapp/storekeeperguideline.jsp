<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Help Center Guide - Inventory Manager</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
<style>
  @keyframes fadeInUp {
    0% {
      opacity: 0;
      transform: translateY(20px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }

  body {
    font-family: 'Inter', sans-serif;
    background: linear-gradient(135deg, #121212, #2c2c2c);
    color: #eee;
    margin: 0; padding: 40px 30px;
  }

  h1, h2 {
    color: #f39c12;
    font-weight: 700;
    text-shadow: 0 2px 6px rgba(243,156,18,0.6);
  }

  h1 {
    font-size: 2.8rem;
    margin-bottom: 30px;
    animation: fadeInUp 0.8s ease forwards;
  }

  h2 {
    font-size: 1.8rem;
    margin-top: 40px;
    margin-bottom: 16px;
  }

  p, li {
    font-size: 1rem;
    line-height: 1.6;
    margin-bottom: 10px;
  }

  ul {
    padding-left: 25px;
    margin-top: 0;
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
}
.back-btn i {
    margin-right: 6px;
}
.back-btn:hover {
    background-color: #ddd;
    color: #000;
}

  .section {
    background: rgba(255, 255, 255, 0.05);
    padding: 25px 30px;
    border-radius: 16px;
    margin-bottom: 35px;
    box-shadow: 0 8px 24px rgba(243,156,18,0.12);
    opacity: 0;
    transform: translateY(20px);
    animation: fadeInUp 0.8s ease forwards;
  }

  /* Stagger animations */
  .section:nth-child(2)  { animation-delay: 0.2s; }
  .section:nth-child(3)  { animation-delay: 0.4s; }
  .section:nth-child(4)  { animation-delay: 0.6s; }
  .section:nth-child(5)  { animation-delay: 0.8s; }
  .section:nth-child(6)  { animation-delay: 1s; }
  .section:nth-child(7)  { animation-delay: 1.2s; }
  .section:nth-child(8)  { animation-delay: 1.4s; }

  .emoji {
    font-size: 24px;
    margin-right: 12px;
    transition: transform 0.3s ease;
    display: inline-block;
    vertical-align: middle;
  }
  .section:hover .emoji {
    transform: rotate(15deg) scale(1.2);
  }

  .note {
    color: #e74c3c;
    font-weight: 700;
    font-style: italic;
  }

  a {
    color: #f39c12;
    text-decoration: none;
    font-weight: 700;
    transition: color 0.3s ease;
  }
  a:hover {
    color: #ffb347;
    text-decoration: underline;
  }

  /* Responsive */
  @media (max-width: 600px) {
    body {
      padding: 20px 15px;
    }
    h1 {
      font-size: 2rem;
      margin-bottom: 20px;
    }
    h2 {
      font-size: 1.4rem;
      margin-top: 30px;
    }
  }
</style>
</head>
<body>
 <a href="StoreKeeperHelp.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>
<h1><span class="emoji">🛠️</span>Help Center Guide for Inventory Manager (Storekeeper)</h1>

<div class="section">
  <h2><span class="emoji">📚</span>Welcome to the Help Center!</h2>
  <p>This section helps you with managing suppliers, stock, and supplier mappings.</p>
  <p>Use the options below to find answers or contact support quickly.</p>
</div>

<div class="section">
  <h2><span class="emoji">❓</span>FAQs (Frequently Asked Questions)</h2>
  <p>Find answers to common questions about:</p>
  <ul>
    <li><span class="emoji">🔹</span>Supplier management (add, update, delete)</li>
    <li><span class="emoji">🔹</span>Updating stock quantities & applying discounts</li>
    <li><span class="emoji">🔹</span>Supplier mappings for automated inventory updates</li>
  </ul>
  <p class="note">⚠️ Currently under maintenance. Available soon.</p>
</div>

<div class="section">
  <h2><span class="emoji">📖</span>Guides & Resources</h2>
  <p>Step-by-step tutorials to help you:</p>
  <ul>
    <li><span class="emoji">➕</span>Add or edit suppliers</li>
    <li><span class="emoji">📦</span>Update stock quantities and discounts</li>
    <li><span class="emoji">🔗</span>Map suppliers to stock items for automation</li>
  </ul>
  <p>Access full documentation to better understand system features.</p>
</div>

<div class="section">
  <h2><span class="emoji">📩</span>Submit a Support Request</h2>
  <p>If you face issues not covered in the FAQs or guides, submit a request to our support team.</p>
  <ul>
    <li>Include detailed descriptions of your issue</li>
    <li>Attach screenshots for faster help</li>
  </ul>
  <p class="note">⚠️ Support requests may be temporarily unavailable during updates. Please try again later.</p>
</div>

<div class="section">
  <h2><span class="emoji">💬</span>Using the Team Chat</h2>
  <p>Use the <strong>Team Chat</strong> button at the bottom right for real-time help:</p>
  <ul>
    <li>Chat directly with support or other storekeepers</li>
    <li>View and save chat history for your reference</li>
  </ul>
</div>

<div class="section">
  <h2><span class="emoji">🔎</span>Best Practices for Getting Help</h2>
  <ul>
    <li>Search with keywords before submitting requests</li>
    <li>Be specific and clear when describing issues</li>
    <li>Attach screenshots if possible</li>
    <li>Allow some time for responses and check notifications</li>
  </ul>
</div>

<div class="section">
  <h2><span class="emoji">🚪</span>Contact & Logout</h2>
  <p>Access this Help Center anytime via the sidebar link.</p>
  <p>Use the <strong>Logout</strong> option to securely end your session after finishing work.</p>
</div>

<p style="text-align:center; margin-top: 50px; font-size: 14px; color: #bbb;">
  Need more help? Contact your system administrator or consult the internal documentation.
</p>

</body>
</html>

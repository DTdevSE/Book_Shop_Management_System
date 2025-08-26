<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Help Center Guide - Admin</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
<style>
  @keyframes fadeInUp {
    0% { opacity: 0; transform: translateY(20px); }
    100% { opacity: 1; transform: translateY(0); }
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
    text-decoration: none;
    color: #333;
    margin-bottom: 20px;
  }
  .back-btn i { margin-right: 6px; }
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

  .section:nth-child(2)  { animation-delay: 0.2s; }
  .section:nth-child(3)  { animation-delay: 0.4s; }
  .section:nth-child(4)  { animation-delay: 0.6s; }
  .section:nth-child(5)  { animation-delay: 0.8s; }
  .section:nth-child(6)  { animation-delay: 1s; }
  .section:nth-child(7)  { animation-delay: 1.2s; }

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

  @media (max-width: 600px) {
    body { padding: 20px 15px; }
    h1 { font-size: 2rem; margin-bottom: 20px; }
    h2 { font-size: 1.4rem; margin-top: 30px; }
  }
</style>
</head>
<body>

<a href="AdminHelp.jsp" class="back-btn" title="Go Back">
  <i class="fas fa-arrow-left"></i> Back
</a>

<h1><span class="emoji">🛡️</span>Help Center Guide for Admin</h1>

<div class="section">
  <h2><span class="emoji">👤</span>Create & Manage User Accounts</h2>
  <p>Instructions to add, edit, or delete user accounts like <strong>Cashiers, Storekeepers, and Admins</strong>.</p>
</div>

<div class="section">
  <h2><span class="emoji">📚</span>Add / Update / Delete Books</h2>
  <p>Manage your book database — from uploading new books to updating prices, titles, or removing old entries.</p>
</div>

<div class="section">
  <h2><span class="emoji">🔐</span>Credentials & Access Control</h2>
  <p>Set up user roles and permissions. Define what each type of user can see or do within the system.</p>
</div>

<div class="section">
  <h2><span class="emoji">📊</span>View Daily Billing History</h2>
  <p>Track and analyze daily billing activities by accessing detailed billing records and summaries.</p>
</div>

<div class="section">
  <h2><span class="emoji">💬</span>Using the Team Chat</h2>
  <p>Access the integrated team chat to:</p>
  <ul>
    <li>Contact other admins or departments</li>
    <li>Get fast answers to technical questions</li>
    <li>Save or review conversation history</li>
  </ul>
</div>

<div class="section">
  <h2><span class="emoji">📘</span>Access Help & Logout</h2>
  <p>Use this Help Center anytime from the sidebar or dashboard.</p>
  <p>Click <strong>Logout</strong> when you're done to exit securely.</p>
</div>

<p style="text-align:center; margin-top: 50px; font-size: 14px; color: #bbb;">
  Still stuck? Contact the system developer or refer to your IT guidebook.
</p>

</body>
</html>

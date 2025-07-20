<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="com.bookshop.dao.BuyRequestDAO, com.bookshop.dao.BookDAO, com.bookshop.dao.PaymentRequestDAO" %>
<%@ page import="com.bookshop.model.BuyRequest, com.bookshop.model.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("account_number") == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    int accountNumber = (Integer) currentSession.getAttribute("account_number");
    String userLocation = (String) currentSession.getAttribute("location");

    BuyRequestDAO buyRequestDAO = new BuyRequestDAO();
    BookDAO bookDAO = new BookDAO();
    PaymentRequestDAO prDAO = new PaymentRequestDAO();
    List<BuyRequest> requests = buyRequestDAO.getRequestsByCustomer(accountNumber);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Your Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
<div class="container my-5">
    <h3 class="mb-4">🛒 Your Cart</h3>

    <% if (requests.isEmpty()) { %>
        <div class="alert alert-info text-center">You have no items in your cart.</div>
    <% } else { %>
        <table class="table table-bordered text-center align-middle">
            <thead class="table-light">
                <tr>
                    <th>Book</th>
                    <th>Qty</th>
                    <th>Status</th>
                    <th>Time</th>
                    <th>Book Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% for (BuyRequest br : requests) {
                double deliveryCharge = "Drazee".equalsIgnoreCase(userLocation) ? 300.0 :
                                        "Colombo".equalsIgnoreCase(userLocation) ? 200.0 : 350.0;

                Book book = bookDAO.getBookById(br.getBookId());

                if (book != null) {
                    double unitPrice = book.getPrice();
                    double discountPercent = book.getDiscount();
                    int quantity = br.getQuantity();
                    double subtotal = unitPrice * quantity;
                    double discountAmount = subtotal * discountPercent / 100;
                    double totalPayable = subtotal - discountAmount + deliveryCharge;

                    String paymentStatus = prDAO.getPaymentStatusByRequestId(br.getId());
            %>
                <tr>
                    <td>
                        <strong><%= br.getBookName() %></strong><br/>
                        <span class="text-muted small">by <%= br.getCustomerName() %></span>
                        <span class="text-muted small">📍 <%= br.getCustomerAddress() %></span>

                        
                    </td>
                    <td><%= quantity %></td>
                    <td>
                        <span class="badge
                            <%= br.getStatus().equals("Approved") ? "bg-success" :
                                br.getStatus().equals("Rejected") ? "bg-danger" : "bg-warning text-dark" %>">
                            <%= br.getStatus() %>
                        </span>
                    </td>
                    <td><%= br.getRequestTime() %></td>
                    <td>Rs. <%= String.format("%.2f", unitPrice) %></td>
                    <td>
                        <% if ("Approved".equals(paymentStatus)) { %>
                          <a href="DownloadBillServlet?requestId=<%= br.getId() %>" class="btn btn-success btn-sm">Download Bill</a>

                        <% } else if ("Pending".equals(paymentStatus)) { %>
                            <button class="btn btn-warning btn-sm" disabled>Awaiting Payment Approval</button>
                        <% } else if ("Rejected".equals(paymentStatus)) { %>
                            <button class="btn btn-danger btn-sm" disabled>Payment Rejected</button>
                        <% } else { 
                            if ("Approved".equals(br.getStatus())) { %>
                                <button type="button" class="btn btn-success btn-sm"
                                        data-bs-toggle="modal" data-bs-target="#paymentModal<%= br.getId() %>">
                                    Pay Now
                                </button>
                            <% } else { %>
                                <button class="btn btn-secondary btn-sm" disabled>Awaiting Request Approval</button>
                            <% }
                        } %>

                        <!-- Remove button -->
                        <a href="RemoveFromCartServlet?requestId=<%= br.getId() %>" 
                           class="btn btn-danger btn-sm mt-1"
                           onclick="return confirm('Are you sure you want to remove this item from cart?');">
                           Remove
                        </a>

                        <!-- Payment Modal -->
                        <div class="modal fade" id="paymentModal<%= br.getId() %>" tabindex="-1" aria-hidden="true">
                          <div class="modal-dialog modal-dialog-centered modal-md">
                            <form action="PaymentMethod.jsp" method="post">
                              <input type="hidden" name="requestId" value="<%= br.getId() %>" />
                              <input type="hidden" name="customerName" value="<%= br.getCustomerName() %>" />
                              <input type="hidden" name="bookName" value="<%= br.getBookName() %>" />
                              <input type="hidden" name="quantity" value="<%= quantity %>" />
                              <input type="hidden" name="unitPrice" value="<%= String.format("%.2f", unitPrice) %>" />
                              <input type="hidden" name="discountPercent" value="<%= discountPercent %>" />
                              <input type="hidden" name="deliveryCharge" value="<%= deliveryCharge %>" />
                              <input type="hidden" name="totalAmount" value="<%= String.format("%.2f", totalPayable) %>" />

                              <div class="modal-content">
                                <div class="modal-header bg-primary text-white py-2">
                                  <h6 class="modal-title">🛒 Payment Summary</h6>
                                  <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-3">
                                  <div class="d-flex mb-2">
                                    <img src="<%= request.getContextPath() + "/" + book.getImage() %>" class="img-thumbnail me-3" style="width: 80px;">
                                    <div>
                                      <h6><%= br.getBookName() %></h6>
                                      <small>by <%= book.getAuthor() %></small><br>
                                      <small><strong>Category:</strong> <%= book.getCategory() %></small>
                                    </div>
                                  </div>
                                  <ul class="list-group list-group-flush small mb-3">
                                    <li class="list-group-item d-flex justify-content-between">Unit Price: <span>Rs. <%= String.format("%.2f", unitPrice) %></span></li>
                                    <li class="list-group-item d-flex justify-content-between">Quantity: <span><%= quantity %></span></li>
                                    <li class="list-group-item d-flex justify-content-between">Subtotal: <span>Rs. <%= String.format("%.2f", subtotal) %></span></li>
                                    <li class="list-group-item d-flex justify-content-between text-success">Discount: <span>- Rs. <%= String.format("%.2f", discountAmount) %></span></li>
                                    <li class="list-group-item d-flex justify-content-between">Delivery: <span>Rs. <%= String.format("%.2f", deliveryCharge) %></span></li>
                                    <li class="list-group-item d-flex justify-content-between fw-bold border-top">Total: <span>Rs. <%= String.format("%.2f", totalPayable) %></span></li>
                                  </ul>
                                </div>
                                <div class="modal-footer py-2">
                                  <button type="submit" class="btn btn-primary btn-sm">Confirm Payment</button>
                                  <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                                </div>
                              </div>
                            </form>
                          </div>
                        </div>

                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

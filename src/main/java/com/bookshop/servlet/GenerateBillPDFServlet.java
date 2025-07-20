package com.bookshop.servlet;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.dao.BookDAO;
import com.bookshop.dao.BuyRequestDAO;
import com.bookshop.model.Book;
import com.bookshop.model.BuyRequest;

import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.*;
import com.itextpdf.layout.*;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.*;

@WebServlet("/GenerateBillPDFServlet")
public class GenerateBillPDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId;
        try {
            requestId = Integer.parseInt(request.getParameter("requestId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
            return;
        }

        BuyRequestDAO buyRequestDAO = new BuyRequestDAO();
        BookDAO bookDAO = new BookDAO();

        BuyRequest br = buyRequestDAO.getRequestById(requestId);
        if (br == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Buy request not found.");
            return;
        }

        Book book = bookDAO.getBookById(br.getBookId());
        if (book == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found.");
            return;
        }

        double unitPrice = book.getPrice();
        double discount = book.getDiscount();
        int quantity = br.getQuantity();
        double subtotal = unitPrice * quantity;
        double discountAmount = subtotal * discount / 100;
        double deliveryCharge = "Drazee".equalsIgnoreCase(br.getCustomerAddress()) ? 300.0
                : "Colombo".equalsIgnoreCase(br.getCustomerAddress()) ? 200.0 : 350.0;
        double total = subtotal - discountAmount + deliveryCharge;

        LocalDate placedDate = br.getRequestTime().toLocalDate();
        LocalDate arrivalDate = placedDate.plusDays(3);

        // Set response headers to force download
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=PaymentBill_" + requestId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdfDoc = new PdfDocument(writer);
            pdfDoc.setDefaultPageSize(PageSize.A4);
            Document document = new Document(pdfDoc);

            document.add(new Paragraph("📚 Payment Bill - Padu Edu Book Shop")
                    .setFontSize(18).setBold()
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(20));

            document.add(new Paragraph("Customer Name: " + br.getCustomerName()));
            document.add(new Paragraph("Book: " + book.getName()));
            document.add(new Paragraph("Category: " + book.getCategory()));
            document.add(new Paragraph("Order Date: " + placedDate));
            document.add(new Paragraph("Expected Arrival: " + arrivalDate));
            document.add(new Paragraph("Delivery Location: " + br.getCustomerAddress()));
            document.add(new Paragraph("\n"));

            Table table = new Table(UnitValue.createPercentArray(new float[] { 2, 1, 2, 2, 2, 2 }))
                    .useAllAvailableWidth();

            table.addHeaderCell("Unit Price");
            table.addHeaderCell("Qty");
            table.addHeaderCell("Subtotal");
            table.addHeaderCell("Discount");
            table.addHeaderCell("Delivery");
            table.addHeaderCell("Total");

            table.addCell("Rs. " + String.format("%.2f", unitPrice));
            table.addCell(String.valueOf(quantity));
            table.addCell("Rs. " + String.format("%.2f", subtotal));
            table.addCell("Rs. " + String.format("%.2f", discountAmount));
            table.addCell("Rs. " + String.format("%.2f", deliveryCharge));
            table.addCell("Rs. " + String.format("%.2f", total));

            document.add(table);

            document.add(new Paragraph("\nThank you for choosing Padu Edu Book Shop!")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setItalic());

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate PDF.");
        }
    }
}

package com.jignesh.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.PaymentDAO;

@WebServlet("/admin/payment-update")
public class PaymentUpdateServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			String status = req.getParameter("paymentStatus");
			String mode = req.getParameter("paymentMode");
			BigDecimal amount = new BigDecimal(req.getParameter("paidAmount"));
			new PaymentDAO().updatePayment(bookingId, status, mode, amount);
			resp.sendRedirect(req.getContextPath() + "/admin/bookings?success=Payment updated");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

package com.jignesh.servlet.customer;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.CancellationDAO;
import com.jignesh.model.Cancellation;

@WebServlet("/customer/cancel-booking")
public class CancelBookingServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int customerId = (Integer) req.getSession().getAttribute("customerId");
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			String reason = req.getParameter("reason");
			Cancellation c = new CancellationDAO().cancelBooking(bookingId, customerId, reason);
			String msg = "Booking cancelled. Penalty Rs " + c.getPenaltyAmount() + ", Refund Rs " + c.getRefundAmount();
			resp.sendRedirect(req.getContextPath() + "/customer/my-bookings?success=" + msg.replace(" ", "+"));
		} catch (Exception e) {
			resp.sendRedirect(req.getContextPath() + "/customer/my-bookings?error=" + e.getMessage().replace(" ", "+"));
		}
	}
}

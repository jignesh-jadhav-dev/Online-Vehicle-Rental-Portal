package com.jignesh.servlet.customer;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;
import com.jignesh.Entity.InvoiceDAO;
import com.jignesh.model.Booking;

@WebServlet("/customer/invoice")
public class CustomerInvoiceServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int customerId = (Integer) req.getSession().getAttribute("customerId");
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			Booking booking = new BookingDAO().getById(bookingId);
			if (booking == null || booking.getCustomerId() != customerId) {
				resp.sendRedirect(req.getContextPath() + "/customer/my-bookings?error=Invoice not found");
				return;
			}
			req.setAttribute("booking", booking);
			req.setAttribute("invoice", new InvoiceDAO().buildInvoice(bookingId));
			req.getRequestDispatcher("/customer/invoice.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

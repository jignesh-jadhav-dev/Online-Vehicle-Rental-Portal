package com.jignesh.servlet.customer;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;

@WebServlet("/customer/my-bookings")
public class MyBookingsServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int customerId = (Integer) req.getSession().getAttribute("customerId");
			req.setAttribute("bookings", new BookingDAO().getByCustomer(customerId));
			req.getRequestDispatcher("/customer/my-bookings.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

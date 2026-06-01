package com.jignesh.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;
import com.jignesh.Entity.ReturnDAO;

@WebServlet("/admin/return-add")
public class ReturnAddServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			req.setAttribute("booking", new BookingDAO().getById(bookingId));
			req.getRequestDispatcher("/admin/return-form.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			LocalDate actualReturnDate = LocalDate.parse(req.getParameter("actualReturnDate"));
			String condition = req.getParameter("vehicleCondition");
			BigDecimal damageCharges = new BigDecimal(req.getParameter("damageCharges"));
			BigDecimal finePerDay = new BigDecimal(req.getParameter("finePerDay"));
			new ReturnDAO().addReturn(bookingId, actualReturnDate, condition, damageCharges, finePerDay);
			resp.sendRedirect(req.getContextPath() + "/admin/bookings?success=Vehicle return completed");
		} catch (Exception e) {
			resp.sendRedirect(req.getContextPath() + "/admin/bookings?error=" + e.getMessage().replace(" ", "+"));
		}
	}
}

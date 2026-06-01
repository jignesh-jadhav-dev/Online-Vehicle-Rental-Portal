package com.jignesh.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;

@WebServlet("/admin/bookings")
public class AdminBookingsServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int page = req.getParameter("page") == null ? 1 : Integer.parseInt(req.getParameter("page"));
			int size = 10;
			BookingDAO dao = new BookingDAO();
			req.setAttribute("bookings", dao.getAll(page, size));
			req.setAttribute("currentPage", page);
			req.setAttribute("totalPages", (int) Math.ceil(dao.countAll() / (double) size));
			req.getRequestDispatcher("/admin/bookings.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

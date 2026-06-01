package com.jignesh.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;
import com.jignesh.Entity.InvoiceDAO;

@WebServlet("/admin/invoice")
public class AdminInvoiceServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int bookingId = Integer.parseInt(req.getParameter("bookingId"));
			req.setAttribute("booking", new BookingDAO().getById(bookingId));
			req.setAttribute("invoice", new InvoiceDAO().buildInvoice(bookingId));
			req.getRequestDispatcher("/admin/invoice.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

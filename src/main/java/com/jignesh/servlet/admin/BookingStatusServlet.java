package com.jignesh.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;
import com.jignesh.Entity.VehicleDAO;
import com.jignesh.model.Booking;

@WebServlet("/admin/booking-status")
public class BookingStatusServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(req.getParameter("bookingId"));
			String status = req.getParameter("status");
			BookingDAO bookingDAO = new BookingDAO();
			Booking booking = bookingDAO.getById(id);
			if ("APPROVED".equals(status)) {
				boolean ok = new VehicleDAO().isVehicleAvailable(booking.getVehicleId(), booking.getPickupDate(),
						booking.getReturnDate(), id);
				if (!ok) {
					resp.sendRedirect(
							req.getContextPath() + "/admin/bookings?error=Vehicle is not available for selected dates");
					return;
				}
			}
			bookingDAO.updateStatus(id, status);
			resp.sendRedirect(req.getContextPath() + "/admin/bookings?success=Booking status updated");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

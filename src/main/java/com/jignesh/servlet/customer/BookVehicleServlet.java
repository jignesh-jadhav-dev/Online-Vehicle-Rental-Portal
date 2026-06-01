package com.jignesh.servlet.customer;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.BookingDAO;
import com.jignesh.Entity.VehicleDAO;
import com.jignesh.model.Booking;
import com.jignesh.model.Vehicle;
import com.jignesh.util.AppUtil;

@WebServlet("/customer/book")
public class BookVehicleServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
			req.setAttribute("vehicle", new VehicleDAO().getById(vehicleId));
			req.getRequestDispatcher("/customer/book-form.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int customerId = (Integer) req.getSession().getAttribute("customerId");
			int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
			LocalDate pickupDate = LocalDate.parse(req.getParameter("pickupDate"));
			LocalDate returnDate = LocalDate.parse(req.getParameter("returnDate"));
			String location = req.getParameter("pickupLocation");

			if (returnDate.isBefore(pickupDate)) {
				resp.sendRedirect(req.getContextPath() + "/customer/book?vehicleId=" + vehicleId
						+ "&error=Return date must be after pickup date");
				return;
			}

			VehicleDAO vehicleDAO = new VehicleDAO();
			boolean available = vehicleDAO.isVehicleAvailable(vehicleId, pickupDate, returnDate, null);
			if (!available) {
				resp.sendRedirect(
						req.getContextPath() + "/customer/vehicles?error=Vehicle not available for selected dates");
				return;
			}

			Vehicle vehicle = vehicleDAO.getById(vehicleId);
			int days = AppUtil.calculateDays(pickupDate, returnDate);

			Booking booking = new Booking();
			booking.setBookingCode(new BookingDAO().generateBookingCode());
			booking.setCustomerId(customerId);
			booking.setVehicleId(vehicleId);
			booking.setPickupDate(pickupDate);
			booking.setReturnDate(returnDate);
			booking.setPickupLocation(location);
			booking.setTotalDays(days);
			booking.setTotalAmount(AppUtil.calculateAmount(days, vehicle.getRentPerDay()));
			new BookingDAO().create(booking);
			resp.sendRedirect(req.getContextPath() + "/customer/my-bookings?success=Booking request submitted");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

package com.jignesh.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.VehicleDAO;
import com.jignesh.model.Vehicle;

@WebServlet("/admin/vehicle-add")
public class VehicleAddServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/admin/vehicle-form.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Vehicle v = readVehicle(req);
			new VehicleDAO().add(v);
			resp.sendRedirect(req.getContextPath() + "/admin/vehicles?success=Vehicle added");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	static Vehicle readVehicle(HttpServletRequest req) {
		Vehicle v = new Vehicle();
		v.setVehicleName(req.getParameter("vehicleName"));
		v.setVehicleType(req.getParameter("vehicleType"));
		v.setBrand(req.getParameter("brand"));
		v.setModel(req.getParameter("model"));
		v.setVehicleNumber(req.getParameter("vehicleNumber"));
		v.setFuelType(req.getParameter("fuelType"));
		v.setRentPerDay(new BigDecimal(req.getParameter("rentPerDay")));
		v.setStatus(req.getParameter("status"));
		v.setImageUrl(req.getParameter("imageUrl"));
		return v;
	}
}

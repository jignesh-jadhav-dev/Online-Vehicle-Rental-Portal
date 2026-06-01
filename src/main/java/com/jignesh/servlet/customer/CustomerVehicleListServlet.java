package com.jignesh.servlet.customer;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.VehicleDAO;

@WebServlet("/customer/vehicles")
public class CustomerVehicleListServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			String type = req.getParameter("type");
			String brand = req.getParameter("brand");
			String fuel = req.getParameter("fuel");
			BigDecimal min = req.getParameter("minRent") == null || req.getParameter("minRent").isBlank() ? null
					: new BigDecimal(req.getParameter("minRent"));
			BigDecimal max = req.getParameter("maxRent") == null || req.getParameter("maxRent").isBlank() ? null
					: new BigDecimal(req.getParameter("maxRent"));
			boolean availableOnly = "on".equals(req.getParameter("availableOnly"));
			req.setAttribute("vehicles", new VehicleDAO().search(type, brand, fuel, min, max, availableOnly));
			req.getRequestDispatcher("/customer/vehicles.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

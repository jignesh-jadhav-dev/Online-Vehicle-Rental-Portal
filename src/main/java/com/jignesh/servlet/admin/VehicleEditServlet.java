package com.jignesh.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.VehicleDAO;
import com.jignesh.model.Vehicle;

@WebServlet("/admin/vehicle-edit")
public class VehicleEditServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(req.getParameter("id"));
			req.setAttribute("vehicle", new VehicleDAO().getById(id));
			req.getRequestDispatcher("/admin/vehicle-form.jsp").forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Vehicle v = VehicleAddServlet.readVehicle(req);
			v.setId(Integer.parseInt(req.getParameter("id")));
			new VehicleDAO().update(v);
			resp.sendRedirect(req.getContextPath() + "/admin/vehicles?success=Vehicle updated");
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

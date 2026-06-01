package com.jignesh.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.VehicleDAO;

@WebServlet("/admin/vehicle-delete")
public class VehicleDeleteServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(req.getParameter("id"));
			new VehicleDAO().delete(id);
			resp.sendRedirect(req.getContextPath() + "/admin/vehicles?success=Vehicle deleted");
		} catch (Exception e) {
			resp.sendRedirect(
					req.getContextPath() + "/admin/vehicles?error=Vehicle cannot be deleted because booking exists");
		}
	}
}

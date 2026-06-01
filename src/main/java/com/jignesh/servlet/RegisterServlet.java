package com.jignesh.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jignesh.Entity.CustomerDAO;
import com.jignesh.model.Customer;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Customer customer = new Customer();
		customer.setName(req.getParameter("name"));
		customer.setEmail(req.getParameter("email"));
		customer.setMobile(req.getParameter("mobile"));
		customer.setAddress(req.getParameter("address"));
		customer.setLicenseNo(req.getParameter("licenseNo"));
		String password = req.getParameter("password");

		try {
			new CustomerDAO().register(customer, password);
			resp.sendRedirect(req.getContextPath() + "/login.jsp?success=Registration successful. Please login.");
		} catch (Exception e) {
			resp.sendRedirect(
					req.getContextPath() + "/register.jsp?error=Registration failed. Email may already exist.");
		}
	}
}

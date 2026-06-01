package com.jignesh.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jignesh.Entity.CustomerDAO;
import com.jignesh.Entity.UserDAO;
import com.jignesh.model.Customer;
import com.jignesh.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");
		String password = req.getParameter("password");
		try {
			User user = new UserDAO().login(email, password);
			if (user == null) {
				resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid email or password");
				return;
			}
			HttpSession session = req.getSession();
			session.setAttribute("userId", user.getId());
			session.setAttribute("userName", user.getName());
			session.setAttribute("role", user.getRole());

			if ("CUSTOMER".equals(user.getRole())) {
				Customer customer = new CustomerDAO().getByUserId(user.getId());
				if (customer != null) {
					session.setAttribute("customerId", customer.getId());
				}
				resp.sendRedirect(req.getContextPath() + "/customer/dashboard");
			} else {
				resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
			}
		} catch (Exception e) {
			throw new ServletException(e);
		}
	}
}

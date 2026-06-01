package com.jignesh.Security;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = { "/admin/*", "/customer/*" })
public class AuthSecurity implements Filter {
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		HttpSession session = req.getSession(false);

		if (session == null || session.getAttribute("userId") == null) {
			res.sendRedirect(req.getContextPath() + "/login.jsp?error=Please login first");
			return;
		}

		String role = (String) session.getAttribute("role");
		String uri = req.getRequestURI();
		if (uri.contains("/admin/") && !"ADMIN".equals(role)) {
			res.sendRedirect(req.getContextPath() + "/customer/dashboard");
			return;
		}
		if (uri.contains("/customer/") && !"CUSTOMER".equals(role)) {
			res.sendRedirect(req.getContextPath() + "/admin/dashboard");
			return;
		}
		chain.doFilter(request, response);
	}
}

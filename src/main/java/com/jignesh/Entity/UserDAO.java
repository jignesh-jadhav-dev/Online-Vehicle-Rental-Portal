package com.jignesh.Entity;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jignesh.model.User;
import com.jignesh.util.DBConnection;
import com.jignesh.util.PasswordUtil;

public class UserDAO {
	public User login(String email, String password) throws SQLException {
		String sql = "SELECT * FROM users WHERE email=? AND password=?";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, email);
			ps.setString(2, PasswordUtil.hashPassword(password));
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setId(rs.getInt("id"));
					user.setName(rs.getString("name"));
					user.setEmail(rs.getString("email"));
					user.setRole(rs.getString("role"));
					return user;
				}
			}
		}
		return null;
	}

	public int createCustomerUser(String name, String email, String password, Connection con) throws SQLException {
		String sql = "INSERT INTO users(name,email,password,role) VALUES(?,?,?, 'CUSTOMER') RETURNING id";
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, name);
			ps.setString(2, email);
			ps.setString(3, PasswordUtil.hashPassword(password));
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
		}
		throw new SQLException("User creation failed");
	}
}

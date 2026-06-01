package com.jignesh.Entity;

import com.jignesh.model.Customer;
import com.jignesh.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public boolean register(Customer customer, String password) throws SQLException {
        Connection con = DBConnection.getConnection();
        try {
            con.setAutoCommit(false);
            UserDAO userDAO = new UserDAO();
            int userId = userDAO.createCustomerUser(customer.getName(), customer.getEmail(), password, con);

            String sql = "INSERT INTO customers(user_id,mobile,address,license_no) VALUES(?,?,?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, customer.getMobile());
                ps.setString(3, customer.getAddress());
                ps.setString(4, customer.getLicenseNo());
                ps.executeUpdate();
            }
            con.commit();
            return true;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }

    public Customer getByUserId(int userId) throws SQLException {
        String sql = "SELECT c.*, u.name, u.email FROM customers c JOIN users u ON c.user_id=u.id WHERE c.user_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapCustomer(rs);
            }
        }
        return null;
    }

    public List<Customer> getAll() throws SQLException {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT c.*, u.name, u.email FROM customers c JOIN users u ON c.user_id=u.id ORDER BY c.id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapCustomer(rs));
        }
        return list;
    }

    private Customer mapCustomer(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setMobile(rs.getString("mobile"));
        c.setAddress(rs.getString("address"));
        c.setLicenseNo(rs.getString("license_no"));
        c.setName(rs.getString("name"));
        c.setEmail(rs.getString("email"));
        return c;
    }
}

package com.jignesh.Entity;

import java.math.BigDecimal;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

import com.jignesh.util.DBConnection;

public class DashboardDAO {
    public Map<String, Object> getAdminStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        try (Connection con = DBConnection.getConnection()) {
            stats.put("totalCustomers", count(con, "SELECT COUNT(*) FROM customers"));
            stats.put("totalVehicles", count(con, "SELECT COUNT(*) FROM vehicles"));
            stats.put("availableVehicles", count(con, "SELECT COUNT(*) FROM vehicles WHERE status='AVAILABLE'"));
            stats.put("bookedVehicles", count(con, "SELECT COUNT(*) FROM vehicles WHERE status='BOOKED'"));
            stats.put("pendingBookings", count(con, "SELECT COUNT(*) FROM bookings WHERE status='PENDING'"));
            stats.put("completedBookings", count(con, "SELECT COUNT(*) FROM bookings WHERE status='COMPLETED'"));
            stats.put("cancelledBookings", count(con, "SELECT COUNT(*) FROM bookings WHERE status='CANCELLED'"));
            stats.put("totalRevenue", money(con, "SELECT COALESCE(SUM(paid_amount),0) FROM payments WHERE payment_status='PAID'"));
        }
        return stats;
    }

    private int count(Connection con, String sql) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private BigDecimal money(Connection con, String sql) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }
}

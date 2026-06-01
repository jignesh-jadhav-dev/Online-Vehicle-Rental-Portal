package com.jignesh.Entity;

import java.math.BigDecimal;
import java.sql.*;

import com.jignesh.util.DBConnection;

public class PaymentDAO {
    public boolean updatePayment(int bookingId, String paymentStatus, String paymentMode, BigDecimal paidAmount) throws SQLException {
        String sql = "UPDATE payments SET payment_status=?, payment_mode=?, paid_amount=?, updated_at=CURRENT_TIMESTAMP WHERE booking_id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setString(2, paymentMode);
            ps.setBigDecimal(3, paidAmount);
            ps.setInt(4, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    public void updatePayment(Connection con, int bookingId, String paymentStatus, String paymentMode, BigDecimal paidAmount) throws SQLException {
        String sql = "UPDATE payments SET payment_status=?, payment_mode=?, paid_amount=?, updated_at=CURRENT_TIMESTAMP WHERE booking_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setString(2, paymentMode);
            ps.setBigDecimal(3, paidAmount);
            ps.setInt(4, bookingId);
            ps.executeUpdate();
        }
    }

    public void refundPayment(Connection con, int bookingId) throws SQLException {
        String sql = "UPDATE payments SET payment_status='REFUNDED', updated_at=CURRENT_TIMESTAMP WHERE booking_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.executeUpdate();
        }
    }
}

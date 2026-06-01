package com.jignesh.Entity;

import com.jignesh.model.Booking;
import com.jignesh.model.Cancellation;
import com.jignesh.util.AppUtil;
import com.jignesh.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

public class CancellationDAO {
    public Cancellation cancelBooking(int bookingId, int customerId, String reason) throws SQLException {
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null || booking.getCustomerId() != customerId) {
            throw new SQLException("Booking not found");
        }
        if ("COMPLETED".equals(booking.getStatus()) || "REJECTED".equals(booking.getStatus()) || "CANCELLED".equals(booking.getStatus())) {
            throw new SQLException("This booking cannot be cancelled");
        }

        LocalDate today = LocalDate.now();
        BigDecimal penalty = BigDecimal.ZERO;
        if ("PENDING".equals(booking.getStatus())) {
            penalty = BigDecimal.ZERO;
        } else if (today.isBefore(booking.getPickupDate())) {
            penalty = AppUtil.percent(booking.getTotalAmount(), 10);
        } else if (today.isEqual(booking.getPickupDate())) {
            penalty = AppUtil.percent(booking.getTotalAmount(), 25);
        } else {
            penalty = AppUtil.percent(booking.getTotalAmount(), 50);
        }
        BigDecimal refund = booking.getTotalAmount().subtract(penalty);
        if (refund.compareTo(BigDecimal.ZERO) < 0) refund = BigDecimal.ZERO;

        Connection con = DBConnection.getConnection();
        try {
            con.setAutoCommit(false);
            String sql = """
                INSERT INTO cancellations(booking_id,customer_id,cancel_date,cancel_reason,total_amount,penalty_amount,refund_amount,cancellation_status)
                VALUES(?,?,?,?,?,?,?,'CANCELLED') RETURNING id
            """;
            int cancelId;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, customerId);
                ps.setDate(3, Date.valueOf(today));
                ps.setString(4, reason);
                ps.setBigDecimal(5, booking.getTotalAmount());
                ps.setBigDecimal(6, penalty);
                ps.setBigDecimal(7, refund);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("Cancellation failed");
                    cancelId = rs.getInt(1);
                }
            }
            bookingDAO.updateStatus(con, bookingId, "CANCELLED");
            new PaymentDAO().refundPayment(con, bookingId);
            new InvoiceDAO().upsertInvoice(con, bookingId);
            con.commit();

            Cancellation c = new Cancellation();
            c.setId(cancelId);
            c.setBookingId(bookingId);
            c.setCustomerId(customerId);
            c.setCancelDate(today);
            c.setCancelReason(reason);
            c.setTotalAmount(booking.getTotalAmount());
            c.setPenaltyAmount(penalty);
            c.setRefundAmount(refund);
            c.setCancellationStatus("CANCELLED");
            return c;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }
}

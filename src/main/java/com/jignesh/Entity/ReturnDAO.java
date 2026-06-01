package com.jignesh.Entity;

import com.jignesh.model.Booking;
import com.jignesh.model.ReturnRecord;
import com.jignesh.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class ReturnDAO {
    public ReturnRecord addReturn(int bookingId, LocalDate actualReturnDate, String condition, BigDecimal damageCharges, BigDecimal finePerDay) throws SQLException {
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getById(bookingId);
        if (booking == null || !"APPROVED".equals(booking.getStatus())) {
            throw new SQLException("Only approved bookings can be returned");
        }

        long lateDays = ChronoUnit.DAYS.between(booking.getReturnDate(), actualReturnDate);
        if (lateDays < 0) lateDays = 0;
        BigDecimal lateFine = finePerDay.multiply(BigDecimal.valueOf(lateDays));
        BigDecimal finalAmount = booking.getTotalAmount().add(lateFine).add(damageCharges);

        Connection con = DBConnection.getConnection();
        try {
            con.setAutoCommit(false);
            String sql = """
                INSERT INTO vehicle_returns(booking_id,actual_return_date,vehicle_condition,damage_charges,late_fine,final_amount,return_status)
                VALUES(?,?,?,?,?,?,'RETURNED') RETURNING id
            """;
            int returnId;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ps.setDate(2, Date.valueOf(actualReturnDate));
                ps.setString(3, condition);
                ps.setBigDecimal(4, damageCharges);
                ps.setBigDecimal(5, lateFine);
                ps.setBigDecimal(6, finalAmount);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("Return entry failed");
                    returnId = rs.getInt(1);
                }
            }
            bookingDAO.updateStatus(con, bookingId, "COMPLETED");
            new PaymentDAO().updatePayment(con, bookingId, "PAID", "CASH", finalAmount);
            new InvoiceDAO().upsertInvoice(con, bookingId);
            con.commit();

            ReturnRecord record = new ReturnRecord();
            record.setId(returnId);
            record.setBookingId(bookingId);
            record.setActualReturnDate(actualReturnDate);
            record.setVehicleCondition(condition);
            record.setDamageCharges(damageCharges);
            record.setLateFine(lateFine);
            record.setFinalAmount(finalAmount);
            record.setReturnStatus("RETURNED");
            return record;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }
}

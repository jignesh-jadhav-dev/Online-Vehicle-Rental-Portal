package com.jignesh.Entity;

import com.jignesh.model.Booking;
import com.jignesh.model.Invoice;
import com.jignesh.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;

public class InvoiceDAO {
    public void upsertInvoice(Connection con, int bookingId) throws SQLException {
        Invoice invoice = buildInvoice(con, bookingId);
        String sql = """
            INSERT INTO invoices(booking_id,invoice_no,rent_amount,cancellation_penalty,late_fine,damage_charges,final_total)
            VALUES(?,?,?,?,?,?,?)
            ON CONFLICT (booking_id) DO UPDATE SET
            rent_amount=EXCLUDED.rent_amount,
            cancellation_penalty=EXCLUDED.cancellation_penalty,
            late_fine=EXCLUDED.late_fine,
            damage_charges=EXCLUDED.damage_charges,
            final_total=EXCLUDED.final_total
        """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, invoice.getInvoiceNo());
            ps.setBigDecimal(3, invoice.getRentAmount());
            ps.setBigDecimal(4, invoice.getCancellationPenalty());
            ps.setBigDecimal(5, invoice.getLateFine());
            ps.setBigDecimal(6, invoice.getDamageCharges());
            ps.setBigDecimal(7, invoice.getFinalTotal());
            ps.executeUpdate();
        }
    }

    public Invoice buildInvoice(int bookingId) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            return buildInvoice(con, bookingId);
        }
    }

    private Invoice buildInvoice(Connection con, int bookingId) throws SQLException {
        String sql = """
            SELECT b.booking_code, b.total_amount,
            COALESCE(c.penalty_amount,0) AS penalty,
            COALESCE(r.late_fine,0) AS late_fine,
            COALESCE(r.damage_charges,0) AS damage
            FROM bookings b
            LEFT JOIN cancellations c ON b.id=c.booking_id
            LEFT JOIN vehicle_returns r ON b.id=r.booking_id
            WHERE b.id=?
        """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("Booking not found");
                BigDecimal rent = rs.getBigDecimal("total_amount");
                BigDecimal penalty = rs.getBigDecimal("penalty");
                BigDecimal lateFine = rs.getBigDecimal("late_fine");
                BigDecimal damage = rs.getBigDecimal("damage");

                Invoice inv = new Invoice();
                inv.setInvoiceNo("INV-" + rs.getString("booking_code"));
                inv.setRentAmount(rent);
                inv.setCancellationPenalty(penalty);
                inv.setLateFine(lateFine);
                inv.setDamageCharges(damage);
                inv.setFinalTotal(rent.add(penalty).add(lateFine).add(damage));
                return inv;
            }
        }
    }
}

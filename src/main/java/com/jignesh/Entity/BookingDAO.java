package com.jignesh.Entity;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.jignesh.model.Booking;
import com.jignesh.util.DBConnection;

public class BookingDAO {
	public String generateBookingCode() throws SQLException {
		String prefix = "VRB" + LocalDate.now().getYear();
		String sql = "SELECT COUNT(*) FROM bookings WHERE booking_code LIKE ?";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, prefix + "%");
			try (ResultSet rs = ps.executeQuery()) {
				int next = 1;
				if (rs.next()) {
					next = rs.getInt(1) + 1;
				}
				return prefix + String.format("%04d", next);
			}
		}
	}

	public boolean create(Booking b) throws SQLException {
		String sql = "INSERT INTO bookings(booking_code,customer_id,vehicle_id,pickup_date,return_date,pickup_location,total_days,total_amount,status) VALUES(?,?,?,?,?,?,?,?, 'PENDING') RETURNING id";
		Connection con = DBConnection.getConnection();
		try {
			con.setAutoCommit(false);
			int bookingId;
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setString(1, b.getBookingCode());
				ps.setInt(2, b.getCustomerId());
				ps.setInt(3, b.getVehicleId());
				ps.setDate(4, Date.valueOf(b.getPickupDate()));
				ps.setDate(5, Date.valueOf(b.getReturnDate()));
				ps.setString(6, b.getPickupLocation());
				ps.setInt(7, b.getTotalDays());
				ps.setBigDecimal(8, b.getTotalAmount());
				try (ResultSet rs = ps.executeQuery()) {
					if (!rs.next()) {
						throw new SQLException("Booking failed");
					}
					bookingId = rs.getInt(1);
				}
			}
			createDefaultPayment(bookingId, con);
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

	private void createDefaultPayment(int bookingId, Connection con) throws SQLException {
		String sql = "INSERT INTO payments(booking_id,payment_status,payment_mode,paid_amount) VALUES(?, 'PENDING', 'CASH', 0)";
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.executeUpdate();
		}
	}

	public Booking getById(int id) throws SQLException {
		String sql = baseQuery() + " WHERE b.id=?";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapBooking(rs);
				}
			}
		}
		return null;
	}

	public List<Booking> getAll(int page, int size) throws SQLException {
		List<Booking> list = new ArrayList<>();
		String sql = baseQuery() + " ORDER BY b.id DESC LIMIT ? OFFSET ?";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, size);
			ps.setInt(2, (page - 1) * size);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapBooking(rs));
				}
			}
		}
		return list;
	}

	public int countAll() throws SQLException {
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM bookings");
				ResultSet rs = ps.executeQuery()) {
			return rs.next() ? rs.getInt(1) : 0;
		}
	}

	public List<Booking> getByCustomer(int customerId) throws SQLException {
		List<Booking> list = new ArrayList<>();
		String sql = baseQuery() + " WHERE b.customer_id=? ORDER BY b.id DESC";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapBooking(rs));
				}
			}
		}
		return list;
	}

	public boolean updateStatus(int bookingId, String status) throws SQLException {
		Connection con = DBConnection.getConnection();
		try {
			con.setAutoCommit(false);
			Booking booking = getById(bookingId);
			if (booking == null) {
				return false;
			}
			String sql = "UPDATE bookings SET status=? WHERE id=?";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setString(1, status);
				ps.setInt(2, bookingId);
				ps.executeUpdate();
			}
			VehicleDAO vehicleDAO = new VehicleDAO();
			if ("APPROVED".equals(status)) {
				vehicleDAO.updateStatus(booking.getVehicleId(), "BOOKED", con);
			}
			if ("REJECTED".equals(status) || "CANCELLED".equals(status) || "COMPLETED".equals(status)) {
				vehicleDAO.updateStatus(booking.getVehicleId(), "AVAILABLE", con);
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

	public boolean updateStatus(Connection con, int bookingId, String status) throws SQLException {
		Booking booking = getById(bookingId);
		if (booking == null) {
			return false;
		}
		try (PreparedStatement ps = con.prepareStatement("UPDATE bookings SET status=? WHERE id=?")) {
			ps.setString(1, status);
			ps.setInt(2, bookingId);
			ps.executeUpdate();
		}
		VehicleDAO vehicleDAO = new VehicleDAO();
		if ("APPROVED".equals(status)) {
			vehicleDAO.updateStatus(booking.getVehicleId(), "BOOKED", con);
		}
		if ("REJECTED".equals(status) || "CANCELLED".equals(status) || "COMPLETED".equals(status)) {
			vehicleDAO.updateStatus(booking.getVehicleId(), "AVAILABLE", con);
		}
		return true;
	}

	private String baseQuery() {
		return """
				    SELECT b.*, u.name AS customer_name, u.email AS customer_email,
				           v.vehicle_name, v.vehicle_number, v.rent_per_day,
				           COALESCE(p.payment_status, 'PENDING') AS payment_status
				    FROM bookings b
				    JOIN customers c ON b.customer_id=c.id
				    JOIN users u ON c.user_id=u.id
				    JOIN vehicles v ON b.vehicle_id=v.id
				    LEFT JOIN payments p ON b.id=p.booking_id
				""";
	}

	private Booking mapBooking(ResultSet rs) throws SQLException {
		Booking b = new Booking();
		b.setId(rs.getInt("id"));
		b.setBookingCode(rs.getString("booking_code"));
		b.setCustomerId(rs.getInt("customer_id"));
		b.setVehicleId(rs.getInt("vehicle_id"));
		b.setPickupDate(rs.getDate("pickup_date").toLocalDate());
		b.setReturnDate(rs.getDate("return_date").toLocalDate());
		b.setPickupLocation(rs.getString("pickup_location"));
		b.setTotalDays(rs.getInt("total_days"));
		b.setTotalAmount(rs.getBigDecimal("total_amount"));
		b.setStatus(rs.getString("status"));
		b.setCustomerName(rs.getString("customer_name"));
		b.setCustomerEmail(rs.getString("customer_email"));
		b.setVehicleName(rs.getString("vehicle_name"));
		b.setVehicleNumber(rs.getString("vehicle_number"));
		b.setRentPerDay(rs.getBigDecimal("rent_per_day"));
		b.setPaymentStatus(rs.getString("payment_status"));
		return b;
	}
}

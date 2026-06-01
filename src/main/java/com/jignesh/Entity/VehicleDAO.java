package com.jignesh.Entity;

import com.jignesh.model.Vehicle;
import com.jignesh.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {
    public boolean add(Vehicle v) throws SQLException {
        String sql = "INSERT INTO vehicles(vehicle_name,vehicle_type,brand,model,vehicle_number,fuel_type,rent_per_day,status,image_url) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            fillVehicle(ps, v);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Vehicle v) throws SQLException {
        String sql = "UPDATE vehicles SET vehicle_name=?,vehicle_type=?,brand=?,model=?,vehicle_number=?,fuel_type=?,rent_per_day=?,status=?,image_url=? WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            fillVehicle(ps, v);
            ps.setInt(10, v.getId());
            return ps.executeUpdate() > 0;
        }
    }

    private void fillVehicle(PreparedStatement ps, Vehicle v) throws SQLException {
        ps.setString(1, v.getVehicleName());
        ps.setString(2, v.getVehicleType());
        ps.setString(3, v.getBrand());
        ps.setString(4, v.getModel());
        ps.setString(5, v.getVehicleNumber());
        ps.setString(6, v.getFuelType());
        ps.setBigDecimal(7, v.getRentPerDay());
        ps.setString(8, v.getStatus());
        ps.setString(9, v.getImageUrl());
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public Vehicle getById(int id) throws SQLException {
        String sql = "SELECT * FROM vehicles WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapVehicle(rs);
            }
        }
        return null;
    }

    public List<Vehicle> getAll(int page, int size) throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles ORDER BY id DESC LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, size);
            ps.setInt(2, (page - 1) * size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapVehicle(rs));
            }
        }
        return list;
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Vehicle> search(String type, String brand, String fuel, BigDecimal minRent, BigDecimal maxRent, boolean availableOnly) throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM vehicles WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (type != null && !type.isBlank()) { sql.append("AND LOWER(vehicle_type)=LOWER(?) "); params.add(type); }
        if (brand != null && !brand.isBlank()) { sql.append("AND LOWER(brand) LIKE LOWER(?) "); params.add("%" + brand + "%"); }
        if (fuel != null && !fuel.isBlank()) { sql.append("AND LOWER(fuel_type)=LOWER(?) "); params.add(fuel); }
        if (minRent != null) { sql.append("AND rent_per_day >= ? "); params.add(minRent); }
        if (maxRent != null) { sql.append("AND rent_per_day <= ? "); params.add(maxRent); }
        if (availableOnly) { sql.append("AND status='AVAILABLE' "); }
        sql.append("ORDER BY id DESC");

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapVehicle(rs));
            }
        }
        return list;
    }

    public void updateStatus(int vehicleId, String status, Connection con) throws SQLException {
        String sql = "UPDATE vehicles SET status=? WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, vehicleId);
            ps.executeUpdate();
        }
    }

    public boolean isVehicleAvailable(int vehicleId, LocalDate pickupDate, LocalDate returnDate, Integer excludeBookingId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM bookings
            WHERE vehicle_id=?
            AND status IN ('PENDING','APPROVED')
            AND pickup_date <= ?
            AND return_date >= ?
        """);
        if (excludeBookingId != null) sql.append(" AND id <> ?");
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, vehicleId);
            ps.setDate(2, Date.valueOf(returnDate));
            ps.setDate(3, Date.valueOf(pickupDate));
            if (excludeBookingId != null) ps.setInt(4, excludeBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return false;
            }
        }
        Vehicle v = getById(vehicleId);
        return v != null && !"MAINTENANCE".equalsIgnoreCase(v.getStatus());
    }

    private Vehicle mapVehicle(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setVehicleName(rs.getString("vehicle_name"));
        v.setVehicleType(rs.getString("vehicle_type"));
        v.setBrand(rs.getString("brand"));
        v.setModel(rs.getString("model"));
        v.setVehicleNumber(rs.getString("vehicle_number"));
        v.setFuelType(rs.getString("fuel_type"));
        v.setRentPerDay(rs.getBigDecimal("rent_per_day"));
        v.setStatus(rs.getString("status"));
        v.setImageUrl(rs.getString("image_url"));
        return v;
    }
}

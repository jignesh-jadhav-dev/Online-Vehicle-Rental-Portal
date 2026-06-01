package com.jignesh.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ReturnRecord {
    private int id;
    private int bookingId;
    private LocalDate actualReturnDate;
    private String vehicleCondition;
    private BigDecimal damageCharges;
    private BigDecimal lateFine;
    private BigDecimal finalAmount;
    private String returnStatus;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public LocalDate getActualReturnDate() { return actualReturnDate; }
    public void setActualReturnDate(LocalDate actualReturnDate) { this.actualReturnDate = actualReturnDate; }
    public String getVehicleCondition() { return vehicleCondition; }
    public void setVehicleCondition(String vehicleCondition) { this.vehicleCondition = vehicleCondition; }
    public BigDecimal getDamageCharges() { return damageCharges; }
    public void setDamageCharges(BigDecimal damageCharges) { this.damageCharges = damageCharges; }
    public BigDecimal getLateFine() { return lateFine; }
    public void setLateFine(BigDecimal lateFine) { this.lateFine = lateFine; }
    public BigDecimal getFinalAmount() { return finalAmount; }
    public void setFinalAmount(BigDecimal finalAmount) { this.finalAmount = finalAmount; }
    public String getReturnStatus() { return returnStatus; }
    public void setReturnStatus(String returnStatus) { this.returnStatus = returnStatus; }
}

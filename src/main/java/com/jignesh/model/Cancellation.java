package com.jignesh.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Cancellation {
    private int id;
    private int bookingId;
    private int customerId;
    private LocalDate cancelDate;
    private String cancelReason;
    private BigDecimal totalAmount;
    private BigDecimal penaltyAmount;
    private BigDecimal refundAmount;
    private String cancellationStatus;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public LocalDate getCancelDate() { return cancelDate; }
    public void setCancelDate(LocalDate cancelDate) { this.cancelDate = cancelDate; }
    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getPenaltyAmount() { return penaltyAmount; }
    public void setPenaltyAmount(BigDecimal penaltyAmount) { this.penaltyAmount = penaltyAmount; }
    public BigDecimal getRefundAmount() { return refundAmount; }
    public void setRefundAmount(BigDecimal refundAmount) { this.refundAmount = refundAmount; }
    public String getCancellationStatus() { return cancellationStatus; }
    public void setCancellationStatus(String cancellationStatus) { this.cancellationStatus = cancellationStatus; }
}

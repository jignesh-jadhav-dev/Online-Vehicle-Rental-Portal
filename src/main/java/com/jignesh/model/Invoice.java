package com.jignesh.model;

import java.math.BigDecimal;

public class Invoice {
    private String invoiceNo;
    private BigDecimal rentAmount;
    private BigDecimal cancellationPenalty;
    private BigDecimal lateFine;
    private BigDecimal damageCharges;
    private BigDecimal finalTotal;

    public String getInvoiceNo() { return invoiceNo; }
    public void setInvoiceNo(String invoiceNo) { this.invoiceNo = invoiceNo; }
    public BigDecimal getRentAmount() { return rentAmount; }
    public void setRentAmount(BigDecimal rentAmount) { this.rentAmount = rentAmount; }
    public BigDecimal getCancellationPenalty() { return cancellationPenalty; }
    public void setCancellationPenalty(BigDecimal cancellationPenalty) { this.cancellationPenalty = cancellationPenalty; }
    public BigDecimal getLateFine() { return lateFine; }
    public void setLateFine(BigDecimal lateFine) { this.lateFine = lateFine; }
    public BigDecimal getDamageCharges() { return damageCharges; }
    public void setDamageCharges(BigDecimal damageCharges) { this.damageCharges = damageCharges; }
    public BigDecimal getFinalTotal() { return finalTotal; }
    public void setFinalTotal(BigDecimal finalTotal) { this.finalTotal = finalTotal; }
}

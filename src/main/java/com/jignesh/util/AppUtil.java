package com.jignesh.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class AppUtil {
    public static int calculateDays(LocalDate pickupDate, LocalDate returnDate) {
        long days = ChronoUnit.DAYS.between(pickupDate, returnDate) + 1;
        return (int) Math.max(days, 1);
    }

    public static BigDecimal calculateAmount(int days, BigDecimal rentPerDay) {
        return rentPerDay.multiply(BigDecimal.valueOf(days));
    }

    public static BigDecimal percent(BigDecimal amount, int percentage) {
        return amount.multiply(BigDecimal.valueOf(percentage)).divide(BigDecimal.valueOf(100));
    }

    public static String safe(String value) {
        return value == null ? "" : value.trim();
    }
}

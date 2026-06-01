<%@ page import="com.jignesh.model.Booking" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    public String safe(Object value) {
        if (value == null) return "";
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>

<%
    Booking b = (Booking) request.getAttribute("booking");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Return Vehicle - Admin Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <style>
        .admin-page {
            min-height: 100vh;
            padding-bottom: 45px;
        }

        .admin-nav {
            background: rgba(15, 23, 42, 0.92);
            color: #ffffff;
            backdrop-filter: blur(16px);
            padding: 16px 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.18);
        }

        .admin-nav-inner {
            width: min(1180px, 92%);
            margin: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .admin-brand {
            font-size: 22px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .admin-brand span {
            color: #67e8f9;
        }

        .admin-links {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .admin-links a {
            padding: 9px 13px;
            border-radius: 13px;
            color: #e2e8f0;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s ease;
        }

        .admin-links a:hover {
            background: rgba(255, 255, 255, 0.14);
            color: #ffffff;
            transform: translateY(-2px);
        }

        .logout-link {
            background: rgba(239, 68, 68, 0.18);
            color: #fecaca !important;
        }

        .logout-link:hover {
            background: rgba(239, 68, 68, 0.32) !important;
        }

        .return-hero {
            margin-top: 30px;
            padding: 30px;
            border-radius: 28px;
            color: #ffffff;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.96), rgba(67, 56, 202, 0.9));
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.22);
            position: relative;
            overflow: hidden;
            animation: fadeUp 0.75s ease both;
        }

        .return-hero::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -95px;
            top: -95px;
        }

        .return-hero::after {
            content: "";
            position: absolute;
            width: 190px;
            height: 190px;
            border-radius: 50%;
            background: rgba(6, 182, 212, 0.25);
            left: 42%;
            bottom: -95px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .hero-title {
            font-size: 34px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .hero-subtitle {
            color: #dbeafe;
            max-width: 720px;
            line-height: 1.7;
            font-size: 15px;
        }

        .return-layout {
            margin-top: 24px;
            display: grid;
            grid-template-columns: 0.85fr 1.15fr;
            gap: 22px;
            align-items: start;
        }

        .summary-card,
        .return-form-card {
            padding: 26px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            animation: fadeUp 0.85s ease both;
        }

        .summary-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }

        .summary-icon {
            width: 58px;
            height: 58px;
            border-radius: 20px;
            display: grid;
            place-items: center;
            color: #ffffff;
            font-size: 27px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            box-shadow: 0 14px 35px rgba(99, 102, 241, 0.3);
        }

        .summary-header h2 {
            font-size: 22px;
            color: #0f172a;
            font-weight: 900;
            margin-bottom: 4px;
        }

        .summary-header p {
            color: #64748b;
            font-size: 13px;
        }

        .detail-line {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            padding: 13px 0;
            border-bottom: 1px dashed #cbd5e1;
        }

        .detail-line:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }

        .detail-value {
            color: #0f172a;
            font-size: 13px;
            font-weight: 900;
            text-align: right;
        }

        .booking-code {
            color: #4338ca;
            background: #eef2ff;
            padding: 6px 10px;
            border-radius: 999px;
            display: inline-block;
        }

        .info-box {
            margin-top: 20px;
            padding: 16px;
            border-radius: 18px;
            background: #eef2ff;
            border: 1px solid #c7d2fe;
            color: #4338ca;
            font-size: 13px;
            line-height: 1.7;
            font-weight: 600;
        }

        .return-form-card h2 {
            font-size: 25px;
            color: #0f172a;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .return-form-card .subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 24px;
        }

        .return-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap input,
        .input-wrap select {
            padding-left: 44px;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 17px;
            opacity: 0.75;
            z-index: 1;
        }

        .hint-text {
            margin-top: 6px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.5;
        }

        .condition-preview {
            margin-top: 22px;
            padding: 18px;
            border-radius: 20px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
        }

        .condition-preview h3 {
            font-size: 17px;
            color: #0f172a;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .condition-preview p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.7;
        }

        .form-actions {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .missing-box {
            margin-top: 30px;
            padding: 35px;
            border-radius: 26px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            text-align: center;
        }

        .missing-box h2 {
            color: #0f172a;
            font-size: 25px;
            margin-bottom: 10px;
        }

        .missing-box p {
            color: #64748b;
            margin-bottom: 20px;
        }

        @media (max-width: 920px) {
            .return-layout {
                grid-template-columns: 1fr;
            }

            .hero-title {
                font-size: 28px;
            }
        }

        @media (max-width: 680px) {
            .admin-nav-inner {
                flex-direction: column;
            }

            .admin-links {
                justify-content: center;
            }

            .return-grid {
                grid-template-columns: 1fr;
            }

            .return-hero {
                padding: 25px 20px;
            }

            .summary-card,
            .return-form-card {
                padding: 22px 18px;
            }

            .form-actions {
                justify-content: stretch;
            }

            .form-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="admin-page">

    <!-- Navbar -->
    <div class="admin-nav">
        <div class="admin-nav-inner">
            <div class="admin-brand">
                🚘 Admin <span>Panel</span>
            </div>

            <div class="admin-links">
                <a href="dashboard">Dashboard</a>
                <a href="vehicles">Vehicles</a>
                <a href="bookings">Back to Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="return-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">↩️ Vehicle Return</div>
                    <h1 class="hero-title">Return Vehicle</h1>
                    <p class="hero-subtitle">
                        Complete the vehicle return process, add actual return date,
                        vehicle condition, damage charges and fine per late day.
                    </p>
                </div>

                <a class="btn btn-light" href="bookings">← Back</a>
            </div>
        </div>

        <% if(b == null) { %>

            <div class="missing-box">
                <h2>Booking Data Not Found</h2>
                <p>Booking details are missing. Please go back and try again.</p>
                <a class="btn btn-primary" href="bookings">Back to Bookings</a>
            </div>

        <% } else { %>

            <div class="return-layout">

                <!-- Booking Summary -->
                <div class="summary-card">

                    <div class="summary-header">
                        <div class="summary-icon">🚗</div>
                        <div>
                            <h2>Booking Summary</h2>
                            <p>Return details for selected booking</p>
                        </div>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Booking Code</span>
                        <span class="detail-value">
                            <span class="booking-code"><%= safe(b.getBookingCode()) %></span>
                        </span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Vehicle</span>
                        <span class="detail-value"><%= safe(b.getVehicleName()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Vehicle Number</span>
                        <span class="detail-value"><%= safe(b.getVehicleNumber()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Customer</span>
                        <span class="detail-value"><%= safe(b.getCustomerName()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Expected Return</span>
                        <span class="detail-value"><%= safe(b.getReturnDate()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Total Amount</span>
                        <span class="detail-value">₹<%= safe(b.getTotalAmount()) %></span>
                    </div>

                    <div class="info-box">
                        Late fine will be calculated automatically from actual return date and fine per day.
                        Damage charges will be added to the final amount.
                    </div>

                </div>

                <!-- Return Form -->
                <div class="return-form-card">

                    <h2>Complete Return Details</h2>
                    <p class="subtitle">Fill return information carefully before completing the booking.</p>

                    <form method="post" action="return-add">

                        <input type="hidden" name="bookingId" value="<%= b.getId() %>">

                        <div class="return-grid">

                            <div class="form-group">
                                <label>Actual Return Date</label>
                                <div class="input-wrap">
                                    <span class="input-icon">📅</span>
                                    <input type="date" name="actualReturnDate" required>
                                </div>
                                <div class="hint-text">Select the real date when vehicle is returned.</div>
                            </div>

                            <div class="form-group">
                                <label>Vehicle Condition</label>
                                <div class="input-wrap">
                                    <span class="input-icon">🔍</span>
                                    <select name="vehicleCondition" required>
                                        <option value="Good">Good</option>
                                        <option value="Average">Average</option>
                                        <option value="Damaged">Damaged</option>
                                    </select>
                                </div>
                                <div class="hint-text">Choose condition after checking the vehicle.</div>
                            </div>

                            <div class="form-group">
                                <label>Damage Charges</label>
                                <div class="input-wrap">
                                    <span class="input-icon">₹</span>
                                    <input 
                                        type="number" 
                                        step="0.01" 
                                        min="0"
                                        name="damageCharges" 
                                        value="0" 
                                        required>
                                </div>
                                <div class="hint-text">Enter 0 if there is no damage.</div>
                            </div>

                            <div class="form-group">
                                <label>Fine Per Late Day</label>
                                <div class="input-wrap">
                                    <span class="input-icon">⚠️</span>
                                    <input 
                                        type="number" 
                                        step="0.01" 
                                        min="0"
                                        name="finePerDay" 
                                        value="300" 
                                        required>
                                </div>
                                <div class="hint-text">Default fine is ₹300 per late day.</div>
                            </div>

                        </div>

                        <div class="condition-preview">
                            <h3>Return Calculation</h3>
                            <p>
                                System will calculate late fine using expected return date and actual return date.
                                Final amount will include rent amount, damage charges and late fine.
                            </p>
                        </div>

                        <div class="form-actions">
                            <a class="btn btn-light" href="bookings">Cancel</a>
                            <button class="btn btn-success" type="submit">
                                Complete Return →
                            </button>
                        </div>

                    </form>

                </div>

            </div>

        <% } %>

    </div>

</div>

</body>
</html>
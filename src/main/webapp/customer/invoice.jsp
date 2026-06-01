<%@ page import="com.jignesh.model.Booking,com.jignesh.model.Invoice" %>
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
    Invoice inv = (Invoice) request.getAttribute("invoice");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Invoice - Online Vehicle Rental Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <style>
        .invoice-page {
            min-height: 100vh;
            padding-bottom: 45px;
        }

        .customer-nav {
            background: rgba(15, 23, 42, 0.92);
            color: #ffffff;
            backdrop-filter: blur(16px);
            padding: 16px 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.18);
        }

        .customer-nav-inner {
            width: min(1180px, 92%);
            margin: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .customer-brand {
            font-size: 22px;
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .customer-brand span {
            color: #67e8f9;
        }

        .customer-links {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .customer-links a {
            padding: 9px 13px;
            border-radius: 13px;
            color: #e2e8f0;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s ease;
        }

        .customer-links a:hover {
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

        .invoice-hero {
            margin-top: 30px;
            padding: 32px;
            border-radius: 30px;
            color: #ffffff;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.96), rgba(67, 56, 202, 0.9));
            box-shadow: 0 25px 70px rgba(15, 23, 42, 0.24);
            position: relative;
            overflow: hidden;
            animation: fadeUp 0.75s ease both;
        }

        .invoice-hero::before {
            content: "";
            position: absolute;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -110px;
            top: -110px;
        }

        .invoice-hero::after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(6, 182, 212, 0.25);
            left: 48%;
            bottom: -110px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
            font-size: 38px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .hero-title span {
            color: #67e8f9;
        }

        .hero-subtitle {
            color: #dbeafe;
            max-width: 720px;
            line-height: 1.7;
            font-size: 15px;
        }

        .invoice-wrapper {
            margin-top: 26px;
            display: grid;
            place-items: center;
        }

        .invoice-card {
            width: min(900px, 100%);
            background: rgba(255, 255, 255, 0.92);
            border: 1px solid rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(18px);
            border-radius: 30px;
            box-shadow: 0 25px 70px rgba(15, 23, 42, 0.16);
            overflow: hidden;
            animation: fadeUp 0.85s ease both;
        }

        .invoice-top {
            padding: 32px;
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #ffffff;
            display: flex;
            justify-content: space-between;
            gap: 22px;
            flex-wrap: wrap;
            position: relative;
            overflow: hidden;
        }

        .invoice-top::after {
            content: "";
            position: absolute;
            width: 190px;
            height: 190px;
            border-radius: 50%;
            right: -70px;
            top: -70px;
            background: rgba(6, 182, 212, 0.22);
        }

        .invoice-brand {
            position: relative;
            z-index: 1;
        }

        .invoice-brand h1 {
            font-size: 31px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .invoice-brand p {
            color: #cbd5e1;
            font-size: 14px;
            line-height: 1.6;
        }

        .invoice-meta {
            position: relative;
            z-index: 1;
            text-align: right;
        }

        .invoice-meta .label {
            color: #cbd5e1;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .invoice-meta .value {
            font-size: 17px;
            font-weight: 900;
            color: #67e8f9;
            margin-bottom: 12px;
        }

        .invoice-body {
            padding: 32px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-bottom: 26px;
        }

        .detail-box {
            padding: 18px;
            border-radius: 20px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            transition: 0.3s ease;
        }

        .detail-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.1);
        }

        .detail-box h3 {
            font-size: 15px;
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 12px;
        }

        .detail-line {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            padding: 7px 0;
            border-bottom: 1px dashed #cbd5e1;
            font-size: 13px;
        }

        .detail-line:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: #64748b;
            font-weight: 700;
        }

        .detail-value {
            color: #0f172a;
            font-weight: 800;
            text-align: right;
        }

        .status-pill {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            background: #e0e7ff;
            color: #3730a3;
            font-size: 12px;
            font-weight: 900;
        }

        .payment-pill {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            background: #dcfce7;
            color: #166534;
            font-size: 12px;
            font-weight: 900;
        }

        .amount-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: none;
            margin-top: 10px;
        }

        .amount-table th {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #ffffff;
            padding: 15px;
            font-size: 14px;
        }

        .amount-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 14px;
            background: #ffffff;
        }

        .amount-table tr:hover td {
            background: #f8fafc;
        }

        .amount {
            text-align: right;
            font-weight: 900;
            color: #0f172a;
        }

        .final-row th {
            background: linear-gradient(135deg, #16a34a, #14b8a6);
            font-size: 16px;
        }

        .final-total {
            font-size: 24px;
            color: #ffffff;
            text-align: right;
        }

        .invoice-note {
            margin-top: 24px;
            padding: 16px;
            border-radius: 18px;
            background: #eef2ff;
            border: 1px solid #c7d2fe;
            color: #4338ca;
            font-size: 13px;
            line-height: 1.7;
            font-weight: 600;
        }

        .thank-you-box {
            margin-top: 18px;
            padding: 18px;
            border-radius: 20px;
            background: linear-gradient(135deg, #dcfce7, #ecfeff);
            border: 1px solid #bbf7d0;
            text-align: center;
        }

        .thank-you-box h3 {
            color: #166534;
            font-size: 18px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .thank-you-box p {
            color: #047857;
            font-size: 13px;
            font-weight: 600;
            line-height: 1.6;
        }

        .invoice-actions {
            padding: 22px 32px 32px;
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

        @media (max-width: 760px) {
            .details-grid {
                grid-template-columns: 1fr;
            }

            .invoice-top {
                padding: 25px 20px;
            }

            .invoice-meta {
                text-align: left;
            }

            .invoice-body {
                padding: 22px;
            }

            .invoice-actions {
                padding: 18px 22px 28px;
                justify-content: stretch;
            }

            .invoice-actions .btn {
                width: 100%;
            }

            .hero-title {
                font-size: 28px;
            }
        }

        @media (max-width: 680px) {
            .customer-nav-inner {
                flex-direction: column;
            }

            .customer-links {
                justify-content: center;
            }

            .invoice-hero {
                padding: 25px 20px;
            }
        }

        @media print {
            body {
                background: #ffffff !important;
                animation: none !important;
            }

            .no-print,
            .customer-nav,
            .invoice-hero {
                display: none !important;
            }

            .container {
                width: 100% !important;
                margin: 0 !important;
            }

            .invoice-page {
                padding: 0 !important;
            }

            .invoice-wrapper {
                margin-top: 0 !important;
            }

            .invoice-card {
                width: 100% !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                border: none !important;
            }

            .invoice-top {
                background: #0f172a !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .amount-table th,
            .final-row th {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .invoice-body {
                padding: 25px !important;
            }
        }
    </style>
</head>

<body>

<div class="invoice-page">

    <!-- Navbar -->
    <div class="customer-nav no-print">
        <div class="customer-nav-inner">
            <div class="customer-brand">
                🚘 Vehicle <span>Rental</span>
            </div>

            <div class="customer-links">
                <a href="dashboard">Dashboard</a>
                <a href="vehicles">Vehicles</a>
                <a href="my-bookings">Back to My Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="invoice-hero no-print">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">🧾 Customer Invoice</div>
                    <h1 class="hero-title">Vehicle Rental <span>Invoice</span></h1>
                    <p class="hero-subtitle">
                        View your rental billing details including rent amount, cancellation penalty,
                        late fine, damage charges and final total amount.
                    </p>
                </div>

                <button class="btn btn-light" onclick="window.print()">Print Invoice</button>
            </div>
        </div>

        <% if(b == null || inv == null) { %>

            <div class="missing-box">
                <h2>Invoice Data Not Found</h2>
                <p>Booking or invoice details are missing. Please go back and try again.</p>
                <a class="btn btn-primary" href="my-bookings">Back to My Bookings</a>
            </div>

        <% } else { %>

            <div class="invoice-wrapper">

                <div class="invoice-card">

                    <!-- Invoice Header -->
                    <div class="invoice-top">
                        <div class="invoice-brand">
                            <h1>Online Vehicle Rental Portal</h1>
                            <p>
                                Customer rental invoice<br>
                                Cars • Bikes • Scooters
                            </p>
                        </div>

                        <div class="invoice-meta">
                            <div class="label">Invoice Number</div>
                            <div class="value"><%= safe(inv.getInvoiceNo()) %></div>

                            <div class="label">Booking Code</div>
                            <div class="value"><%= safe(b.getBookingCode()) %></div>
                        </div>
                    </div>

                    <!-- Invoice Body -->
                    <div class="invoice-body">

                        <div class="details-grid">

                            <div class="detail-box">
                                <h3>👤 Customer Details</h3>

                                <div class="detail-line">
                                    <span class="detail-label">Name</span>
                                    <span class="detail-value"><%= safe(b.getCustomerName()) %></span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Email</span>
                                    <span class="detail-value"><%= safe(b.getCustomerEmail()) %></span>
                                </div>
                            </div>

                            <div class="detail-box">
                                <h3>🚗 Vehicle Details</h3>

                                <div class="detail-line">
                                    <span class="detail-label">Vehicle</span>
                                    <span class="detail-value"><%= safe(b.getVehicleName()) %></span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Vehicle No.</span>
                                    <span class="detail-value"><%= safe(b.getVehicleNumber()) %></span>
                                </div>
                            </div>

                            <div class="detail-box">
                                <h3>📅 Rental Period</h3>

                                <div class="detail-line">
                                    <span class="detail-label">Pickup Date</span>
                                    <span class="detail-value"><%= safe(b.getPickupDate()) %></span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Return Date</span>
                                    <span class="detail-value"><%= safe(b.getReturnDate()) %></span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Total Days</span>
                                    <span class="detail-value"><%= safe(b.getTotalDays()) %> days</span>
                                </div>
                            </div>

                            <div class="detail-box">
                                <h3>📌 Booking Status</h3>

                                <div class="detail-line">
                                    <span class="detail-label">Booking ID</span>
                                    <span class="detail-value">#<%= safe(b.getId()) %></span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Status</span>
                                    <span class="detail-value">
                                        <span class="status-pill"><%= safe(b.getStatus()) %></span>
                                    </span>
                                </div>

                                <div class="detail-line">
                                    <span class="detail-label">Payment</span>
                                    <span class="detail-value">
                                        <span class="payment-pill"><%= safe(b.getPaymentStatus()) %></span>
                                    </span>
                                </div>
                            </div>

                        </div>

                        <!-- Amount Table -->
                        <table class="amount-table">
                            <tr>
                                <th>Description</th>
                                <th style="text-align:right;">Amount</th>
                            </tr>

                            <tr>
                                <td>Rent Amount</td>
                                <td class="amount">₹<%= safe(inv.getRentAmount()) %></td>
                            </tr>

                            <tr>
                                <td>Cancellation Penalty</td>
                                <td class="amount">₹<%= safe(inv.getCancellationPenalty()) %></td>
                            </tr>

                            <tr>
                                <td>Late Fine</td>
                                <td class="amount">₹<%= safe(inv.getLateFine()) %></td>
                            </tr>

                            <tr>
                                <td>Damage Charges</td>
                                <td class="amount">₹<%= safe(inv.getDamageCharges()) %></td>
                            </tr>

                            <tr class="final-row">
                                <th>Final Total</th>
                                <th class="final-total">₹<%= safe(inv.getFinalTotal()) %></th>
                            </tr>
                        </table>

                        <div class="invoice-note">
                            Note: This invoice is generated by the Online Vehicle Rental Portal.
                            Final total may include rent amount, cancellation penalty, late fine and damage charges.
                        </div>

                        <div class="thank-you-box">
                            <h3>Thank You For Using Our Service</h3>
                            <p>
                                We hope you had a smooth vehicle rental experience.
                                Please keep this invoice for your rental record.
                            </p>
                        </div>

                    </div>

                    <!-- Buttons -->
                    <div class="invoice-actions no-print">
                        <a class="btn btn-light" href="my-bookings">← Back</a>
                        <button class="btn btn-primary" onclick="window.print()">Print Invoice →</button>
                    </div>

                </div>

            </div>

        <% } %>

    </div>

</div>

</body>
</html>
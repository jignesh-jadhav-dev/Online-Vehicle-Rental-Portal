<%@ page import="java.util.*,com.jignesh.model.Booking" %>
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

    public String badgeClass(String value) {
        if (value == null) return "badge-primary";

        String s = value.toUpperCase();

        if (s.equals("APPROVED") || s.equals("PAID") || s.equals("COMPLETED")) return "badge-success";
        if (s.equals("PENDING")) return "badge-warning";
        if (s.equals("REJECTED") || s.equals("FAILED") || s.equals("CANCELLED")) return "badge-danger";
        if (s.equals("REFUNDED")) return "badge-primary";

        return "badge-primary";
    }
%>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new ArrayList<Booking>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Bookings - Online Vehicle Rental Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <style>
        .customer-page {
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

        .customer-links a:hover,
        .customer-links a.active {
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

        .booking-hero {
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

        .booking-hero::before {
            content: "";
            position: absolute;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -110px;
            top: -110px;
        }

        .booking-hero::after {
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
            max-width: 740px;
            line-height: 1.7;
            font-size: 15px;
        }

        .hero-count-box {
            padding: 18px 22px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.22);
            text-align: center;
            min-width: 145px;
        }

        .hero-count-box .count {
            font-size: 34px;
            font-weight: 900;
            color: #67e8f9;
        }

        .hero-count-box .label {
            color: #dbeafe;
            font-size: 13px;
            font-weight: 700;
        }

        .content-card {
            margin-top: 24px;
            padding: 26px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            animation: fadeUp 0.85s ease both;
        }

        .top-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .top-bar h2 {
            font-size: 25px;
            color: #0f172a;
            font-weight: 900;
        }

        .top-bar p {
            color: #64748b;
            font-size: 14px;
            margin-top: 4px;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: 22px;
        }

        .modern-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            overflow: hidden;
            border-radius: 22px;
            box-shadow: none;
        }

        .modern-table th {
            background: linear-gradient(135deg, #0f172a, #1e293b);
            color: #ffffff;
            padding: 15px 14px;
            font-size: 13px;
            white-space: nowrap;
        }

        .modern-table td {
            padding: 15px 14px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            font-size: 14px;
            vertical-align: top;
        }

        .modern-table tr {
            transition: 0.25s ease;
        }

        .modern-table tr:hover td {
            background: #f8fafc;
        }

        .booking-code {
            font-size: 15px;
            font-weight: 900;
            color: #4338ca;
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            background: #eef2ff;
        }

        .main-text {
            color: #0f172a;
            font-weight: 900;
        }

        .small-muted {
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
            margin-top: 3px;
        }

        .amount-text {
            font-size: 16px;
            font-weight: 900;
            color: #16a34a;
        }

        .action-box {
            min-width: 250px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .cancel-card {
            margin-top: 12px;
            padding: 13px;
            border-radius: 18px;
            background: #fff7ed;
            border: 1px solid #fed7aa;
        }

        .cancel-card-title {
            color: #9a3412;
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .cancel-card input {
            padding: 10px 11px;
            border-radius: 12px;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .cancel-card .btn {
            width: 100%;
            padding: 10px 12px;
            font-size: 12px;
            border-radius: 12px;
        }

        .penalty-note {
            color: #9a3412;
            font-size: 11px;
            line-height: 1.5;
            margin-top: 7px;
            font-weight: 700;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            border-radius: 26px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
        }

        .empty-state .icon {
            font-size: 55px;
            margin-bottom: 12px;
        }

        .empty-state h3 {
            color: #0f172a;
            font-size: 24px;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .booking-tips {
            margin-top: 24px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .tip-card {
            padding: 18px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.88);
            border: 1px solid rgba(255,255,255,0.45);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.1);
            transition: 0.3s ease;
        }

        .tip-card:hover {
            transform: translateY(-6px);
        }

        .tip-card h3 {
            color: #0f172a;
            font-size: 16px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .tip-card p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        @media (max-width: 950px) {
            .booking-tips {
                grid-template-columns: 1fr;
            }

            .hero-title {
                font-size: 31px;
            }
        }

        @media (max-width: 720px) {
            .customer-nav-inner {
                flex-direction: column;
            }

            .customer-links {
                justify-content: center;
            }

            .booking-hero,
            .content-card {
                padding: 24px 18px;
            }

            .hero-count-box {
                width: 100%;
            }

            .hero-title {
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

<div class="customer-page">

    <!-- Navbar -->
    <div class="customer-nav">
        <div class="customer-nav-inner">
            <div class="customer-brand">
                🚘 Vehicle <span>Rental</span>
            </div>

            <div class="customer-links">
                <a href="dashboard">Dashboard</a>
                <a href="vehicles">Vehicles</a>
                <a class="active" href="my-bookings">My Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="booking-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">📋 Booking History</div>
                    <h1 class="hero-title">My <span>Bookings</span></h1>
                    <p class="hero-subtitle">
                        Track your booking requests, payment status, invoices and cancellation details.
                        Pending or approved bookings can be cancelled, but penalty may apply after approval.
                    </p>
                </div>

                <div class="hero-count-box">
                    <div class="count"><%= bookings.size() %></div>
                    <div class="label">Total Bookings</div>
                </div>
            </div>
        </div>

        <!-- Tips -->
        <div class="booking-tips">
            <div class="tip-card">
                <h3>⏳ Pending Booking</h3>
                <p>Admin has not approved yet. You can cancel without penalty.</p>
            </div>

            <div class="tip-card">
                <h3>✅ Approved Booking</h3>
                <p>Your vehicle booking is confirmed. Cancellation penalty may apply.</p>
            </div>

            <div class="tip-card">
                <h3>🧾 Invoice</h3>
                <p>Invoice shows rent, penalty, fine, damage charges and final total.</p>
            </div>
        </div>

        <!-- Content -->
        <div class="content-card">

            <div class="top-bar">
                <div>
                    <h2>My Booking History</h2>
                    <p>View all your vehicle rental booking records.</p>
                </div>

                <a class="btn btn-primary" href="vehicles">Book New Vehicle →</a>
            </div>

            <% if(request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <%= safe(request.getParameter("success")) %>
                </div>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <%= safe(request.getParameter("error")) %>
                </div>
            <% } %>

            <% if(bookings.isEmpty()) { %>

                <div class="empty-state">
                    <div class="icon">🚗</div>
                    <h3>No Bookings Found</h3>
                    <p>You have not booked any vehicle yet. Browse vehicles and create your first booking.</p>
                    <a class="btn btn-primary" href="vehicles">Browse Vehicles</a>
                </div>

            <% } else { %>

                <div class="table-wrapper">
                    <table class="modern-table">
                        <tr>
                            <th>Booking</th>
                            <th>Vehicle</th>
                            <th>Dates</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Payment</th>
                            <th>Action</th>
                        </tr>

                        <% for(Booking b : bookings) { %>
                            <tr>
                                <td>
                                    <span class="booking-code"><%= safe(b.getBookingCode()) %></span>
                                </td>

                                <td>
                                    <span class="main-text"><%= safe(b.getVehicleName()) %></span>
                                    <br>
                                    <span class="small-muted"><%= safe(b.getVehicleNumber()) %></span>
                                </td>

                                <td>
                                    <span class="main-text">
                                        <%= safe(b.getPickupDate()) %> to <%= safe(b.getReturnDate()) %>
                                    </span>
                                    <br>
                                    <span class="small-muted"><%= safe(b.getTotalDays()) %> days rental</span>
                                </td>

                                <td>
                                    <span class="amount-text">₹<%= safe(b.getTotalAmount()) %></span>
                                </td>

                                <td>
                                    <span class="badge <%= badgeClass(b.getStatus()) %>">
                                        <%= safe(b.getStatus()) %>
                                    </span>
                                </td>

                                <td>
                                    <span class="badge <%= badgeClass(b.getPaymentStatus()) %>">
                                        <%= safe(b.getPaymentStatus()) %>
                                    </span>
                                </td>

                                <td>
                                    <div class="action-box">

                                        <div class="action-buttons">
                                            <a class="btn btn-primary btn-sm" href="invoice?bookingId=<%= b.getId() %>">
                                                Invoice
                                            </a>
                                        </div>

                                        <% if("PENDING".equals(b.getStatus()) || "APPROVED".equals(b.getStatus())) { %>

                                            <form method="post" 
                                                  action="cancel-booking" 
                                                  class="cancel-card"
                                                  onsubmit="return confirm('Cancel this booking? Penalty may apply if booking is approved.')">

                                                <div class="cancel-card-title">Cancel Booking</div>

                                                <input type="hidden" name="bookingId" value="<%= b.getId() %>">

                                                <input 
                                                    name="reason" 
                                                    placeholder="Enter cancel reason" 
                                                    required>

                                                <button class="btn btn-danger" type="submit">
                                                    Cancel Booking
                                                </button>

                                                <div class="penalty-note">
                                                    Note: Pending booking has no penalty. Approved booking may include cancellation penalty.
                                                </div>
                                            </form>

                                        <% } else { %>

                                            <div class="small-muted">
                                                No cancellation action available.
                                            </div>

                                        <% } %>

                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </table>
                </div>

            <% } %>

        </div>

    </div>

</div>

</body>
</html>
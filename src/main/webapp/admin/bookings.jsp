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

    public String selected(String currentValue, String optionValue) {
        if (currentValue == null) return "";
        return currentValue.equalsIgnoreCase(optionValue) ? "selected" : "";
    }
%>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new ArrayList<Booking>();
    }

    Integer cp = (Integer) request.getAttribute("currentPage");
    Integer tp = (Integer) request.getAttribute("totalPages");

    int currentPage = cp == null ? 1 : cp;
    int totalPages = tp == null ? 1 : tp;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings - Admin Panel</title>
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

        .admin-links a:hover,
        .admin-links a.active {
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

        .page-hero {
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

        .page-hero::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -95px;
            top: -95px;
        }

        .page-hero::after {
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
            max-width: 760px;
            line-height: 1.7;
            font-size: 15px;
        }

        .booking-summary {
            margin-top: 24px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .summary-card {
            padding: 18px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.86);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
            transition: 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-6px);
        }

        .summary-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
        }

        .summary-value {
            color: #0f172a;
            font-size: 26px;
            font-weight: 800;
            margin-top: 6px;
        }

        .content-card {
            margin-top: 24px;
            padding: 24px;
            border-radius: 26px;
            background: rgba(255, 255, 255, 0.86);
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
            font-weight: 800;
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
            border-radius: 20px;
        }

        .modern-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            overflow: hidden;
            border-radius: 20px;
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
            margin-bottom: 6px;
        }

        .small-muted {
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .main-text {
            color: #0f172a;
            font-weight: 800;
        }

        .amount-text {
            font-size: 16px;
            font-weight: 900;
            color: #16a34a;
        }

        .action-panel {
            min-width: 280px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .inline-form {
            display: inline;
        }

        .payment-card {
            margin-top: 12px;
            padding: 13px;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .payment-card-title {
            font-size: 13px;
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 10px;
        }

        .payment-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .payment-grid input,
        .payment-grid select {
            padding: 10px 11px;
            border-radius: 12px;
            font-size: 12px;
        }

        .payment-grid .full {
            grid-column: 1 / -1;
        }

        .payment-btn {
            width: 100%;
            padding: 10px 12px;
            font-size: 12px;
            border-radius: 12px;
        }

        .empty-state {
            text-align: center;
            padding: 45px 20px;
            color: #64748b;
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .empty-state h3 {
            color: #0f172a;
            font-size: 22px;
            margin-bottom: 8px;
        }

        .pagination {
            margin-top: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            flex-wrap: wrap;
        }

        .page-btn {
            min-width: 42px;
            height: 42px;
            display: inline-grid;
            place-items: center;
            border-radius: 13px;
            background: #ffffff;
            color: #4338ca;
            font-weight: 800;
            border: 1px solid #e2e8f0;
            transition: 0.3s ease;
        }

        .page-btn:hover,
        .page-btn.active {
            color: #ffffff;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            transform: translateY(-3px);
            box-shadow: 0 12px 28px rgba(99, 102, 241, 0.25);
        }

        @media (max-width: 900px) {
            .booking-summary {
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

            .page-hero {
                padding: 25px 20px;
            }

            .content-card {
                padding: 18px;
            }

            .payment-grid {
                grid-template-columns: 1fr;
            }

            .payment-grid .full {
                grid-column: auto;
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
                <a class="active" href="bookings">Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="page-hero">
            <div class="hero-content">
                <div class="hero-badge">📋 Booking Management</div>
                <h1 class="hero-title">Manage Bookings</h1>
                <p class="hero-subtitle">
                    Approve or reject customer booking requests, update payment status,
                    manage returns, generate invoices and track complete booking workflow.
                </p>
            </div>
        </div>

        <!-- Summary -->
        <div class="booking-summary">
            <div class="summary-card">
                <div class="summary-label">Bookings On This Page</div>
                <div class="summary-value"><%= bookings.size() %></div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Current Page</div>
                <div class="summary-value"><%= currentPage %></div>
            </div>

            <div class="summary-card">
                <div class="summary-label">Total Pages</div>
                <div class="summary-value"><%= totalPages %></div>
            </div>
        </div>

        <!-- Content -->
        <div class="content-card">

            <div class="top-bar">
                <div>
                    <h2>All Booking Records</h2>
                    <p>Review booking details, payment status and return process.</p>
                </div>
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
                    <div class="empty-icon">📋</div>
                    <h3>No Bookings Found</h3>
                    <p>No customer booking requests are available right now.</p>
                </div>

            <% } else { %>

                <div class="table-wrapper">
                    <table class="modern-table">
                        <tr>
                            <th>Booking</th>
                            <th>Customer</th>
                            <th>Vehicle</th>
                            <th>Dates</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Payment</th>
                            <th>Actions</th>
                        </tr>

                        <% for(Booking b : bookings) { %>
                            <tr>
                                <td>
                                    <span class="booking-code">
                                        <%= safe(b.getBookingCode()) %>
                                    </span>
                                    <br>
                                    <span class="small-muted">ID: <%= b.getId() %></span>
                                </td>

                                <td>
                                    <span class="main-text"><%= safe(b.getCustomerName()) %></span>
                                    <br>
                                    <span class="small-muted"><%= safe(b.getCustomerEmail()) %></span>
                                </td>

                                <td>
                                    <span class="main-text"><%= safe(b.getVehicleName()) %></span>
                                    <br>
                                    <span class="small-muted"><%= safe(b.getVehicleNumber()) %></span>
                                </td>

                                <td>
                                    <span class="main-text">
                                        <%= safe(b.getPickupDate()) %>
                                        to
                                        <%= safe(b.getReturnDate()) %>
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
                                    <div class="action-panel">

                                        <div class="action-buttons">

                                            <% if("PENDING".equals(b.getStatus())) { %>

                                                <form class="inline-form" method="post" action="booking-status">
                                                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <button class="btn btn-success btn-sm" type="submit">
                                                        Approve
                                                    </button>
                                                </form>

                                                <form class="inline-form" method="post" action="booking-status">
                                                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <button class="btn btn-danger btn-sm" type="submit"
                                                            onclick="return confirm('Are you sure you want to reject this booking?')">
                                                        Reject
                                                    </button>
                                                </form>

                                            <% } %>

                                            <% if("APPROVED".equals(b.getStatus())) { %>
                                                <a class="btn btn-warning btn-sm" href="return-add?bookingId=<%= b.getId() %>">
                                                    Return
                                                </a>
                                            <% } %>

                                            <a class="btn btn-primary btn-sm" href="invoice?bookingId=<%= b.getId() %>">
                                                Invoice
                                            </a>

                                        </div>

                                        <form method="post" action="payment-update" class="payment-card">
                                            <div class="payment-card-title">💳 Update Payment</div>

                                            <input type="hidden" name="bookingId" value="<%= b.getId() %>">

                                            <div class="payment-grid">

                                                <select name="paymentStatus">
                                                    <option value="PENDING" <%= selected(b.getPaymentStatus(), "PENDING") %>>PENDING</option>
                                                    <option value="PAID" <%= selected(b.getPaymentStatus(), "PAID") %>>PAID</option>
                                                    <option value="FAILED" <%= selected(b.getPaymentStatus(), "FAILED") %>>FAILED</option>
                                                    <option value="REFUNDED" <%= selected(b.getPaymentStatus(), "REFUNDED") %>>REFUNDED</option>
                                                </select>

                                                <select name="paymentMode">
                                                    <option value="CASH">CASH</option>
                                                    <option value="UPI">UPI</option>
                                                    <option value="CARD">CARD</option>
                                                </select>

                                                <input 
                                                    class="full"
                                                    type="number" 
                                                    step="0.01" 
                                                    min="0"
                                                    name="paidAmount" 
                                                    placeholder="Paid amount"
                                                    value="<%= safe(b.getTotalAmount()) %>">

                                                <button class="btn btn-primary payment-btn full" type="submit">
                                                    Update Payment
                                                </button>

                                            </div>
                                        </form>

                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </table>
                </div>

                <% if(totalPages > 1) { %>
                    <div class="pagination">
                        <% for(int i = 1; i <= totalPages; i++) { %>
                            <a class="page-btn <%= i == currentPage ? "active" : "" %>" href="bookings?page=<%= i %>">
                                <%= i %>
                            </a>
                        <% } %>
                    </div>
                <% } %>

            <% } %>

        </div>

    </div>

</div>

</body>
</html>
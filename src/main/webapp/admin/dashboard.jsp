<%@ page import="java.util.Map" %>
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

    public String stat(Map<String, Object> stats, String key) {
        if (stats == null || stats.get(key) == null) return "0";
        return String.valueOf(stats.get(key));
    }
%>

<%
    Map<String,Object> stats = (Map<String,Object>) request.getAttribute("stats");
    String userName = safe(session.getAttribute("userName"));
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Online Vehicle Rental Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <style>
        .admin-page {
            min-height: 100vh;
            padding-bottom: 40px;
        }

        .admin-hero {
            margin-top: 30px;
            padding: 32px;
            border-radius: 28px;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.95), rgba(67, 56, 202, 0.9));
            color: #ffffff;
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.22);
            position: relative;
            overflow: hidden;
            animation: fadeUp 0.75s ease both;
        }

        .admin-hero::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -90px;
            top: -90px;
        }

        .admin-hero::after {
            content: "";
            position: absolute;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: rgba(6, 182, 212, 0.25);
            left: 45%;
            bottom: -90px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 22px;
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
            margin-bottom: 14px;
        }

        .hero-title {
            font-size: 34px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .hero-title span {
            color: #67e8f9;
        }

        .hero-subtitle {
            color: #dbeafe;
            max-width: 650px;
            line-height: 1.7;
            font-size: 15px;
        }

        .hero-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
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
            letter-spacing: 0.3px;
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

        .dashboard-section {
            margin-top: 28px;
        }

        .section-heading {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .section-heading h2 {
            color: #0f172a;
            font-size: 26px;
            font-weight: 800;
        }

        .section-heading p {
            color: #64748b;
            font-size: 14px;
            margin-top: 5px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .modern-stat-card {
            position: relative;
            overflow: hidden;
            min-height: 150px;
            padding: 22px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.13);
            transition: 0.35s ease;
            animation: cardPop 0.7s ease both;
        }

        .modern-stat-card:hover {
            transform: translateY(-8px) scale(1.015);
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.18);
        }

        .modern-stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: -90%;
            width: 70%;
            height: 100%;
            background: linear-gradient(120deg, transparent, rgba(255,255,255,0.65), transparent);
            transform: skewX(-22deg);
            transition: 0.75s;
        }

        .modern-stat-card:hover::before {
            left: 125%;
        }

        .modern-stat-card::after {
            content: "";
            position: absolute;
            right: -35px;
            top: -35px;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            opacity: 0.15;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
        }

        @keyframes cardPop {
            from {
                opacity: 0;
                transform: translateY(20px) scale(0.98);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            display: grid;
            place-items: center;
            border-radius: 16px;
            color: #ffffff;
            font-size: 23px;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            box-shadow: 0 12px 28px rgba(99, 102, 241, 0.25);
        }

        .stat-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .stat-number {
            color: #0f172a;
            font-size: 31px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .stat-footer {
            margin-top: 9px;
            color: #94a3b8;
            font-size: 12px;
            font-weight: 600;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-top: 18px;
        }

        .quick-card {
            padding: 22px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.45);
            transition: 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .quick-card:hover {
            transform: translateY(-7px);
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.16);
        }

        .quick-card h3 {
            font-size: 17px;
            color: #0f172a;
            margin-bottom: 8px;
            font-weight: 800;
        }

        .quick-card p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 16px;
        }

        .mini-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 10px 13px;
            border-radius: 13px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            color: #ffffff;
            font-size: 13px;
            font-weight: 700;
            transition: 0.3s ease;
        }

        .mini-btn:hover {
            transform: translateX(4px);
            box-shadow: 0 12px 24px rgba(99, 102, 241, 0.28);
        }

        @media (max-width: 1050px) {
            .stats-grid,
            .quick-actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .hero-title {
                font-size: 29px;
            }
        }

        @media (max-width: 680px) {
            .admin-nav-inner {
                flex-direction: column;
                align-items: center;
            }

            .admin-links {
                justify-content: center;
            }

            .admin-hero {
                padding: 25px 20px;
            }

            .hero-title {
                font-size: 25px;
            }

            .stats-grid,
            .quick-actions-grid {
                grid-template-columns: 1fr;
            }

            .section-heading h2 {
                font-size: 23px;
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
                <a class="active" href="<%=request.getContextPath()%>/admin/dashboard">Dashboard</a>
                <a href="<%=request.getContextPath()%>/admin/vehicles">Vehicles</a>
                <a href="<%=request.getContextPath()%>/admin/bookings">Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="admin-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">⚡ Online Vehicle Rental Portal</div>
                    <h1 class="hero-title">Welcome, <span><%= userName %></span></h1>
                    <p class="hero-subtitle">
                        Manage vehicles, customers, bookings, payments, cancellations,
                        returns, late fines and invoices from one professional dashboard.
                    </p>
                </div>

                <div class="hero-actions">
                    <a class="btn btn-light" href="<%=request.getContextPath()%>/admin/vehicles">Manage Vehicles</a>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/bookings">View Bookings</a>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <div class="dashboard-section">
            <div class="section-heading">
                <div>
                    <h2>Dashboard Overview</h2>
                    <p>Live summary of your vehicle rental system</p>
                </div>
            </div>

            <div class="stats-grid">

                <div class="modern-stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-label">Total Customers</div>
                    <div class="stat-number"><%= stat(stats, "totalCustomers") %></div>
                    <div class="stat-footer">Registered customers</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">🚗</div>
                    <div class="stat-label">Total Vehicles</div>
                    <div class="stat-number"><%= stat(stats, "totalVehicles") %></div>
                    <div class="stat-footer">Cars, bikes and scooters</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-label">Available Vehicles</div>
                    <div class="stat-number"><%= stat(stats, "availableVehicles") %></div>
                    <div class="stat-footer">Ready for booking</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">🔒</div>
                    <div class="stat-label">Booked Vehicles</div>
                    <div class="stat-number"><%= stat(stats, "bookedVehicles") %></div>
                    <div class="stat-footer">Currently booked</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-label">Pending Bookings</div>
                    <div class="stat-number"><%= stat(stats, "pendingBookings") %></div>
                    <div class="stat-footer">Waiting for approval</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">🏁</div>
                    <div class="stat-label">Completed Bookings</div>
                    <div class="stat-number"><%= stat(stats, "completedBookings") %></div>
                    <div class="stat-footer">Successfully completed</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">❌</div>
                    <div class="stat-label">Cancelled Bookings</div>
                    <div class="stat-number"><%= stat(stats, "cancelledBookings") %></div>
                    <div class="stat-footer">Cancelled with rules</div>
                </div>

                <div class="modern-stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-label">Total Revenue</div>
                    <div class="stat-number">₹<%= stat(stats, "totalRevenue") %></div>
                    <div class="stat-footer">Paid booking revenue</div>
                </div>

            </div>
        </div>

        <!-- Quick Actions -->
        <div class="dashboard-section">
            <div class="section-heading">
                <div>
                    <h2>Quick Actions</h2>
                    <p>Fast access to common admin operations</p>
                </div>
            </div>

            <div class="quick-actions-grid">

                <div class="quick-card">
                    <h3>🚘 Vehicle Management</h3>
                    <p>Add, update, delete and manage vehicle availability status.</p>
                    <a class="mini-btn" href="<%=request.getContextPath()%>/admin/vehicles">Open Vehicles →</a>
                </div>

                <div class="quick-card">
                    <h3>📋 Booking Requests</h3>
                    <p>Approve, reject, complete bookings and track customer requests.</p>
                    <a class="mini-btn" href="<%=request.getContextPath()%>/admin/bookings">Open Bookings →</a>
                </div>

                <div class="quick-card">
                    <h3>💳 Payments</h3>
                    <p>Update payment status like pending, paid, failed and refunded.</p>
                    <a class="mini-btn" href="<%=request.getContextPath()%>/admin/bookings">Manage Payments →</a>
                </div>

                <div class="quick-card">
                    <h3>🧾 Invoice & Returns</h3>
                    <p>Handle return details, damage charges, late fine and invoices.</p>
                    <a class="mini-btn" href="<%=request.getContextPath()%>/admin/bookings">View Details →</a>
                </div>

            </div>
        </div>

    </div>

</div>

</body>
</html>
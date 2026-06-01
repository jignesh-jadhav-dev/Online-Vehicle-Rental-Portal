<%@ page import="java.util.*,com.jignesh.model.Vehicle" %>
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

    public String statusClass(String status) {
        if (status == null) return "badge-primary";

        String s = status.toUpperCase();

        if (s.equals("AVAILABLE")) return "badge-success";
        if (s.equals("BOOKED")) return "badge-warning";
        if (s.equals("MAINTENANCE")) return "badge-danger";

        return "badge-primary";
    }
%>

<%
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    if (vehicles == null) {
        vehicles = new ArrayList<Vehicle>();
    }

    Integer cp = (Integer) request.getAttribute("currentPage");
    Integer tp = (Integer) request.getAttribute("totalPages");

    int currentPage = cp == null ? 1 : cp;
    int totalPages = tp == null ? 1 : tp;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Vehicles - Admin Panel</title>
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
            font-size: 34px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .hero-subtitle {
            color: #dbeafe;
            max-width: 650px;
            line-height: 1.7;
            font-size: 15px;
        }

        .vehicle-summary {
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
            vertical-align: middle;
        }

        .modern-table tr {
            transition: 0.25s ease;
        }

        .modern-table tr:hover td {
            background: #f8fafc;
        }

        .vehicle-name {
            font-weight: 800;
            color: #0f172a;
        }

        .vehicle-type-pill {
            display: inline-flex;
            padding: 6px 10px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 12px;
            font-weight: 800;
        }

        .vehicle-number {
            font-weight: 800;
            color: #0f172a;
            background: #f1f5f9;
            padding: 6px 9px;
            border-radius: 10px;
            display: inline-block;
        }

        .rent-text {
            font-weight: 900;
            color: #16a34a;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
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
            .vehicle-summary {
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

            .top-bar {
                align-items: flex-start;
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
                <a class="active" href="vehicles">Vehicles</a>
                <a href="bookings">Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero Section -->
        <div class="page-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">🚗 Vehicle Management</div>
                    <h1 class="hero-title">Manage Vehicles</h1>
                    <p class="hero-subtitle">
                        Add, update, delete and monitor all rental vehicles with status,
                        fuel type, rent per day and availability details.
                    </p>
                </div>

                <a class="btn btn-light" href="vehicle-add">+ Add New Vehicle</a>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="vehicle-summary">
            <div class="summary-card">
                <div class="summary-label">Total Vehicles On This Page</div>
                <div class="summary-value"><%= vehicles.size() %></div>
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

        <!-- Main Content -->
        <div class="content-card">

            <div class="top-bar">
                <div>
                    <h2>Vehicle List</h2>
                    <p>View and manage all vehicles available in the rental system.</p>
                </div>

                <a class="btn btn-primary" href="vehicle-add">Add Vehicle →</a>
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

            <% if(vehicles.isEmpty()) { %>

                <div class="empty-state">
                    <div class="empty-icon">🚘</div>
                    <h3>No Vehicles Found</h3>
                    <p>No vehicle records are available right now. Add your first vehicle to start booking.</p>
                    <br>
                    <a class="btn btn-primary" href="vehicle-add">Add Vehicle</a>
                </div>

            <% } else { %>

                <div class="table-wrapper">
                    <table class="modern-table">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Brand / Model</th>
                            <th>Number</th>
                            <th>Fuel</th>
                            <th>Rent / Day</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>

                        <% for(Vehicle v : vehicles) { %>
                            <tr>
                                <td>#<%= v.getId() %></td>

                                <td>
                                    <span class="vehicle-name">
                                        <%= safe(v.getVehicleName()) %>
                                    </span>
                                </td>

                                <td>
                                    <span class="vehicle-type-pill">
                                        <%= safe(v.getVehicleType()) %>
                                    </span>
                                </td>

                                <td>
                                    <strong><%= safe(v.getBrand()) %></strong>
                                    <br>
                                    <small><%= safe(v.getModel()) %></small>
                                </td>

                                <td>
                                    <span class="vehicle-number">
                                        <%= safe(v.getVehicleNumber()) %>
                                    </span>
                                </td>

                                <td><%= safe(v.getFuelType()) %></td>

                                <td>
                                    <span class="rent-text">
                                        ₹<%= safe(v.getRentPerDay()) %>
                                    </span>
                                </td>

                                <td>
                                    <span class="badge <%= statusClass(v.getStatus()) %>">
                                        <%= safe(v.getStatus()) %>
                                    </span>
                                </td>

                                <td>
                                    <div class="action-buttons">
                                        <a class="btn btn-warning btn-sm" href="vehicle-edit?id=<%= v.getId() %>">
                                            Edit
                                        </a>

                                        <a class="btn btn-danger btn-sm"
                                           onclick="return confirm('Are you sure you want to delete this vehicle?')"
                                           href="vehicle-delete?id=<%= v.getId() %>">
                                            Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </table>
                </div>

                <% if(totalPages > 1) { %>
                    <div class="pagination">
                        <% for(int i = 1; i <= totalPages; i++) { %>
                            <a class="page-btn <%= i == currentPage ? "active" : "" %>" href="vehicles?page=<%= i %>">
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
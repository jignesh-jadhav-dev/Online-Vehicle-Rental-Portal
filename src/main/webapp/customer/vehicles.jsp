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

    public String selected(String currentValue, String optionValue) {
        if (currentValue == null) return "";
        return currentValue.equalsIgnoreCase(optionValue) ? "selected" : "";
    }

    public String badgeClass(String status) {
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

    String type = request.getParameter("type");
    String brand = request.getParameter("brand");
    String fuel = request.getParameter("fuel");
    String minRent = request.getParameter("minRent");
    String maxRent = request.getParameter("maxRent");
    String availableOnly = request.getParameter("availableOnly");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Available Vehicles - Online Vehicle Rental Portal</title>
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

        .vehicle-hero {
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

        .vehicle-hero::before {
            content: "";
            position: absolute;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -110px;
            top: -110px;
        }

        .vehicle-hero::after {
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
            max-width: 730px;
            line-height: 1.7;
            font-size: 15px;
        }

        .hero-counter {
            padding: 18px 22px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.22);
            text-align: center;
            min-width: 145px;
        }

        .hero-counter .count {
            font-size: 34px;
            font-weight: 900;
            color: #67e8f9;
        }

        .hero-counter .label {
            color: #dbeafe;
            font-size: 13px;
            font-weight: 700;
        }

        .filter-card {
            margin-top: 24px;
            padding: 26px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            animation: fadeUp 0.85s ease both;
        }

        .filter-header {
            margin-bottom: 20px;
        }

        .filter-header h2 {
            color: #0f172a;
            font-size: 25px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .filter-header p {
            color: #64748b;
            font-size: 14px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
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

        .checkbox-box {
            height: 48px;
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 12px 14px;
            border-radius: 13px;
            border: 1px solid #cbd5e1;
            background: rgba(255,255,255,0.85);
        }

        .checkbox-box input {
            width: auto;
            accent-color: #6366f1;
            transform: scale(1.2);
        }

        .checkbox-box span {
            color: #0f172a;
            font-size: 14px;
            font-weight: 700;
        }

        .filter-actions {
            margin-top: 22px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        .vehicles-section {
            margin-top: 28px;
        }

        .section-heading {
            display: flex;
            align-items: end;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .section-heading h2 {
            color: #0f172a;
            font-size: 27px;
            font-weight: 900;
            margin-bottom: 5px;
        }

        .section-heading p {
            color: #64748b;
            font-size: 14px;
        }

        .vehicle-grid-modern {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        .modern-vehicle-card {
            position: relative;
            border-radius: 28px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            transition: 0.35s ease;
            animation: fadeUp 0.9s ease both;
        }

        .modern-vehicle-card:hover {
            transform: translateY(-10px) scale(1.01);
            box-shadow: 0 28px 70px rgba(15, 23, 42, 0.2);
        }

        .modern-vehicle-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: -90%;
            width: 70%;
            height: 100%;
            background: linear-gradient(120deg, transparent, rgba(255,255,255,0.6), transparent);
            transform: skewX(-22deg);
            transition: 0.75s;
            z-index: 2;
            pointer-events: none;
        }

        .modern-vehicle-card:hover::before {
            left: 125%;
        }

        .vehicle-image-wrap {
            position: relative;
            height: 210px;
            overflow: hidden;
            background: #e2e8f0;
        }

        .vehicle-image-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.45s ease;
        }

        .modern-vehicle-card:hover .vehicle-image-wrap img {
            transform: scale(1.08);
        }

        .status-floating {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 3;
        }

        .vehicle-content {
            padding: 22px;
        }

        .vehicle-title-row {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .vehicle-title {
            color: #0f172a;
            font-size: 20px;
            font-weight: 900;
            line-height: 1.35;
        }

        .vehicle-type {
            padding: 6px 10px;
            border-radius: 999px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .vehicle-details {
            display: grid;
            gap: 9px;
            margin-top: 14px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            padding-bottom: 8px;
            border-bottom: 1px dashed #cbd5e1;
        }

        .detail-row:last-child {
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

        .vehicle-number {
            background: #f1f5f9;
            padding: 5px 8px;
            border-radius: 10px;
            display: inline-block;
        }

        .price-book-row {
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 13px;
        }

        .price-box {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .price-box span {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
        }

        .price-box strong {
            color: #16a34a;
            font-size: 21px;
            font-weight: 900;
        }

        .not-available-box {
            margin-top: 20px;
            padding: 12px;
            text-align: center;
            border-radius: 15px;
            background: #fee2e2;
            color: #991b1b;
            font-size: 13px;
            font-weight: 900;
        }

        .empty-state {
            text-align: center;
            padding: 48px 20px;
            border-radius: 28px;
            background: rgba(255,255,255,0.88);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
        }

        .empty-state .icon {
            font-size: 54px;
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

        @media (max-width: 1050px) {
            .vehicle-grid-modern {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .hero-title {
                font-size: 32px;
            }
        }

        @media (max-width: 720px) {
            .customer-nav-inner {
                flex-direction: column;
            }

            .customer-links {
                justify-content: center;
            }

            .vehicle-grid-modern {
                grid-template-columns: 1fr;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .vehicle-hero,
            .filter-card {
                padding: 24px 18px;
            }

            .hero-title {
                font-size: 28px;
            }

            .hero-counter {
                width: 100%;
            }

            .filter-actions {
                justify-content: stretch;
            }

            .filter-actions .btn {
                width: 100%;
            }

            .price-book-row {
                flex-direction: column;
                align-items: stretch;
            }

            .price-book-row .btn {
                width: 100%;
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
                <a class="active" href="vehicles">Vehicles</a>
                <a href="my-bookings">My Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="vehicle-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">🔎 Search & Book</div>
                    <h1 class="hero-title">Available <span>Vehicles</span></h1>
                    <p class="hero-subtitle">
                        Search cars, bikes and scooters by type, brand, fuel type and rent range.
                        Choose your vehicle and book it instantly.
                    </p>
                </div>

                <div class="hero-counter">
                    <div class="count"><%= vehicles.size() %></div>
                    <div class="label">Vehicles Found</div>
                </div>
            </div>
        </div>

        <!-- Error Message -->
        <% if(request.getParameter("error") != null) { %>
            <br>
            <div class="alert alert-error">
                <%= safe(request.getParameter("error")) %>
            </div>
        <% } %>

        <!-- Search Filter -->
        <div class="filter-card">
            <div class="filter-header">
                <h2>Search Vehicles</h2>
                <p>Use filters to quickly find your perfect rental vehicle.</p>
            </div>

            <form method="get" action="vehicles">

                <div class="filter-grid">

                    <div class="form-group">
                        <label>Vehicle Type</label>
                        <div class="input-wrap">
                            <span class="input-icon">🚗</span>
                            <select name="type">
                                <option value="">All Types</option>
                                <option value="Car" <%= selected(type, "Car") %>>Car</option>
                                <option value="Bike" <%= selected(type, "Bike") %>>Bike</option>
                                <option value="Scooter" <%= selected(type, "Scooter") %>>Scooter</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Brand</label>
                        <div class="input-wrap">
                            <span class="input-icon">🏷️</span>
                            <input 
                                type="text"
                                name="brand" 
                                placeholder="Honda, Maruti, Hyundai"
                                value="<%= safe(brand) %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Fuel Type</label>
                        <div class="input-wrap">
                            <span class="input-icon">⛽</span>
                            <select name="fuel">
                                <option value="">All Fuel Types</option>
                                <option value="Petrol" <%= selected(fuel, "Petrol") %>>Petrol</option>
                                <option value="Diesel" <%= selected(fuel, "Diesel") %>>Diesel</option>
                                <option value="CNG" <%= selected(fuel, "CNG") %>>CNG</option>
                                <option value="Electric" <%= selected(fuel, "Electric") %>>Electric</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Min Rent</label>
                        <div class="input-wrap">
                            <span class="input-icon">₹</span>
                            <input 
                                type="number" 
                                name="minRent"
                                min="0"
                                placeholder="Example: 500"
                                value="<%= safe(minRent) %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Max Rent</label>
                        <div class="input-wrap">
                            <span class="input-icon">₹</span>
                            <input 
                                type="number" 
                                name="maxRent"
                                min="0"
                                placeholder="Example: 3000"
                                value="<%= safe(maxRent) %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Availability</label>
                        <label class="checkbox-box">
                            <input 
                                type="checkbox" 
                                name="availableOnly"
                                <%= availableOnly == null || "on".equalsIgnoreCase(availableOnly) ? "checked" : "" %>>
                            <span>Available Only</span>
                        </label>
                    </div>

                </div>

                <div class="filter-actions">
                    <a class="btn btn-light" href="vehicles">Reset</a>
                    <button class="btn btn-primary" type="submit">Search Vehicles →</button>
                </div>

            </form>
        </div>

        <!-- Vehicles List -->
        <div class="vehicles-section">

            <div class="section-heading">
                <div>
                    <h2>Vehicle Collection</h2>
                    <p>Choose a vehicle and start your booking process.</p>
                </div>
            </div>

            <% if(vehicles.isEmpty()) { %>

                <div class="empty-state">
                    <div class="icon">🚘</div>
                    <h3>No Vehicles Found</h3>
                    <p>Try changing your search filter or reset filters to view all vehicles.</p>
                    <a class="btn btn-primary" href="vehicles">Reset Search</a>
                </div>

            <% } else { %>

                <div class="vehicle-grid-modern">

                    <% for(Vehicle v : vehicles) { 
                        String imageUrl = "";
                        if (v.getImageUrl() != null && !v.getImageUrl().trim().isEmpty()) {
                            imageUrl = v.getImageUrl();
                        } else {
                            imageUrl = request.getContextPath() + "/assets/no-image.png";
                        }
                    %>

                        <div class="modern-vehicle-card">

                            <div class="vehicle-image-wrap">
                                <img 
                                    src="<%= safe(imageUrl) %>"
                                    alt="<%= safe(v.getVehicleName()) %>"
                                    onerror="this.src='<%=request.getContextPath()%>/assets/no-image.png';">

                                <div class="status-floating">
                                    <span class="badge <%= badgeClass(v.getStatus()) %>">
                                        <%= safe(v.getStatus()) %>
                                    </span>
                                </div>
                            </div>

                            <div class="vehicle-content">

                                <div class="vehicle-title-row">
                                    <h3 class="vehicle-title"><%= safe(v.getVehicleName()) %></h3>
                                    <span class="vehicle-type"><%= safe(v.getVehicleType()) %></span>
                                </div>

                                <div class="vehicle-details">

                                    <div class="detail-row">
                                        <span class="detail-label">Brand</span>
                                        <span class="detail-value"><%= safe(v.getBrand()) %></span>
                                    </div>

                                    <div class="detail-row">
                                        <span class="detail-label">Model</span>
                                        <span class="detail-value"><%= safe(v.getModel()) %></span>
                                    </div>

                                    <div class="detail-row">
                                        <span class="detail-label">Fuel</span>
                                        <span class="detail-value"><%= safe(v.getFuelType()) %></span>
                                    </div>

                                    <div class="detail-row">
                                        <span class="detail-label">Vehicle No.</span>
                                        <span class="detail-value">
                                            <span class="vehicle-number"><%= safe(v.getVehicleNumber()) %></span>
                                        </span>
                                    </div>

                                </div>

                                <% if("AVAILABLE".equals(v.getStatus())) { %>

                                    <div class="price-book-row">
                                        <div class="price-box">
                                            <span>Rent Per Day</span>
                                            <strong>₹<%= safe(v.getRentPerDay()) %></strong>
                                        </div>

                                        <a class="btn btn-primary" href="book?vehicleId=<%= v.getId() %>">
                                            Book Now →
                                        </a>
                                    </div>

                                <% } else { %>

                                    <div class="not-available-box">
                                        This vehicle is currently not available for booking.
                                    </div>

                                <% } %>

                            </div>

                        </div>

                    <% } %>

                </div>

            <% } %>

        </div>

    </div>

</div>

</body>
</html>
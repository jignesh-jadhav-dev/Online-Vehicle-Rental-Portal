<%@ page import="com.jignesh.model.Vehicle" %>
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
    Vehicle v = (Vehicle) request.getAttribute("vehicle");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Vehicle - Online Vehicle Rental Portal</title>
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

        .booking-layout {
            margin-top: 24px;
            display: grid;
            grid-template-columns: 0.9fr 1.1fr;
            gap: 22px;
            align-items: start;
        }

        .vehicle-summary-card,
        .booking-form-card {
            padding: 26px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            animation: fadeUp 0.85s ease both;
        }

        .vehicle-img-box {
            height: 220px;
            border-radius: 24px;
            overflow: hidden;
            background: #e2e8f0;
            margin-bottom: 20px;
            position: relative;
        }

        .vehicle-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.45s ease;
        }

        .vehicle-summary-card:hover .vehicle-img-box img {
            transform: scale(1.06);
        }

        .status-pill {
            position: absolute;
            top: 15px;
            right: 15px;
        }

        .vehicle-title {
            color: #0f172a;
            font-size: 24px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .vehicle-subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .detail-line {
            display: flex;
            justify-content: space-between;
            gap: 14px;
            padding: 12px 0;
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

        .vehicle-number {
            background: #f1f5f9;
            padding: 5px 8px;
            border-radius: 10px;
            display: inline-block;
        }

        .rent-box {
            margin-top: 20px;
            padding: 18px;
            border-radius: 20px;
            background: linear-gradient(135deg, #dcfce7, #ecfeff);
            border: 1px solid #bbf7d0;
        }

        .rent-box span {
            color: #166534;
            font-size: 13px;
            font-weight: 800;
        }

        .rent-box strong {
            display: block;
            color: #0f172a;
            font-size: 30px;
            font-weight: 900;
            margin-top: 4px;
        }

        .booking-form-card h2 {
            color: #0f172a;
            font-size: 26px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .booking-form-card .subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 24px;
        }

        .booking-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap input {
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

        .calculation-box {
            margin-top: 24px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .calc-card {
            padding: 18px;
            border-radius: 20px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            transition: 0.3s ease;
        }

        .calc-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.1);
        }

        .calc-card span {
            color: #64748b;
            font-size: 13px;
            font-weight: 800;
        }

        .calc-card strong {
            display: block;
            color: #0f172a;
            font-size: 28px;
            font-weight: 900;
            margin-top: 5px;
        }

        .total-card {
            background: linear-gradient(135deg, #eef2ff, #ecfeff);
            border-color: #c7d2fe;
        }

        .total-card strong {
            color: #4338ca;
        }

        .booking-note {
            margin-top: 22px;
            padding: 16px;
            border-radius: 18px;
            background: #fff7ed;
            border: 1px solid #fed7aa;
            color: #9a3412;
            font-size: 13px;
            line-height: 1.7;
            font-weight: 600;
        }

        .form-actions {
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
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

        @media (max-width: 950px) {
            .booking-layout {
                grid-template-columns: 1fr;
            }

            .hero-title {
                font-size: 31px;
            }
        }

        @media (max-width: 680px) {
            .customer-nav-inner {
                flex-direction: column;
            }

            .customer-links {
                justify-content: center;
            }

            .booking-hero {
                padding: 25px 20px;
            }

            .vehicle-summary-card,
            .booking-form-card {
                padding: 22px 18px;
            }

            .booking-grid,
            .calculation-box {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: auto;
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

<div class="customer-page">

    <!-- Navbar -->
    <div class="customer-nav">
        <div class="customer-nav-inner">
            <div class="customer-brand">
                🚘 Vehicle <span>Rental</span>
            </div>

            <div class="customer-links">
                <a href="dashboard">Dashboard</a>
                <a href="vehicles">Back to Vehicles</a>
                <a href="my-bookings">My Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="booking-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge">📅 Vehicle Booking</div>
                    <h1 class="hero-title">Book Your <span>Vehicle</span></h1>
                    <p class="hero-subtitle">
                        Select pickup date, return date and pickup location.
                        Your estimated rent will be calculated automatically.
                    </p>
                </div>

                <a class="btn btn-light" href="vehicles">← Browse Vehicles</a>
            </div>
        </div>

        <% if(v == null) { %>

            <div class="missing-box">
                <h2>Vehicle Data Not Found</h2>
                <p>Selected vehicle details are missing. Please go back and select a vehicle again.</p>
                <a class="btn btn-primary" href="vehicles">Back to Vehicles</a>
            </div>

        <% } else { 
            String imageUrl = "";
            if (v.getImageUrl() != null && !v.getImageUrl().trim().isEmpty()) {
                imageUrl = v.getImageUrl();
            } else {
                imageUrl = request.getContextPath() + "/assets/no-image.png";
            }
        %>

            <div class="booking-layout">

                <!-- Vehicle Summary -->
                <div class="vehicle-summary-card">

                    <div class="vehicle-img-box">
                        <img 
                            src="<%= safe(imageUrl) %>"
                            alt="<%= safe(v.getVehicleName()) %>"
                            onerror="this.src='<%=request.getContextPath()%>/assets/no-image.png';">

                        <div class="status-pill">
                            <span class="badge badge-success"><%= safe(v.getStatus()) %></span>
                        </div>
                    </div>

                    <h2 class="vehicle-title"><%= safe(v.getVehicleName()) %></h2>
                    <p class="vehicle-subtitle">
                        <%= safe(v.getBrand()) %> • <%= safe(v.getModel()) %>
                    </p>

                    <div class="detail-line">
                        <span class="detail-label">Vehicle Type</span>
                        <span class="detail-value"><%= safe(v.getVehicleType()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Fuel Type</span>
                        <span class="detail-value"><%= safe(v.getFuelType()) %></span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Vehicle Number</span>
                        <span class="detail-value">
                            <span class="vehicle-number"><%= safe(v.getVehicleNumber()) %></span>
                        </span>
                    </div>

                    <div class="detail-line">
                        <span class="detail-label">Status</span>
                        <span class="detail-value"><%= safe(v.getStatus()) %></span>
                    </div>

                    <div class="rent-box">
                        <span>Rent Per Day</span>
                        <strong>₹<span id="rent"><%= safe(v.getRentPerDay()) %></span></strong>
                    </div>

                </div>

                <!-- Booking Form -->
                <div class="booking-form-card">

                    <h2>Booking Details</h2>
                    <p class="subtitle">Fill your rental dates and pickup location.</p>

                    <% if(request.getParameter("error") != null) { %>
                        <div class="alert alert-error">
                            <%= safe(request.getParameter("error")) %>
                        </div>
                    <% } %>

                    <form method="post" action="book" oninput="calculateRent()">

                        <input type="hidden" name="vehicleId" value="<%= v.getId() %>">

                        <div class="booking-grid">

                            <div class="form-group">
                                <label>Pickup Date</label>
                                <div class="input-wrap">
                                    <span class="input-icon">📅</span>
                                    <input 
                                        type="date" 
                                        id="pickupDate" 
                                        name="pickupDate" 
                                        required
                                        onchange="setReturnMinDate(); calculateRent();">
                                </div>
                                <div class="hint-text">Select the date when you want to pick up the vehicle.</div>
                            </div>

                            <div class="form-group">
                                <label>Return Date</label>
                                <div class="input-wrap">
                                    <span class="input-icon">📅</span>
                                    <input 
                                        type="date" 
                                        id="returnDate" 
                                        name="returnDate" 
                                        required
                                        onchange="calculateRent();">
                                </div>
                                <div class="hint-text">Return date should be same or after pickup date.</div>
                            </div>

                            <div class="form-group full-width">
                                <label>Pickup Location</label>
                                <div class="input-wrap">
                                    <span class="input-icon">📍</span>
                                    <input 
                                        type="text"
                                        name="pickupLocation" 
                                        required 
                                        placeholder="Example: Pune Station, Mumbai Airport, Wakad">
                                </div>
                                <div class="hint-text">Enter a clear pickup location for smooth handover.</div>
                            </div>

                        </div>

                        <!-- Auto Calculation -->
                        <div class="calculation-box">

                            <div class="calc-card">
                                <span>Total Days</span>
                                <strong><span id="days">0</span></strong>
                            </div>

                            <div class="calc-card total-card">
                                <span>Estimated Total</span>
                                <strong>₹<span id="total">0</span></strong>
                            </div>

                        </div>

                        <div class="booking-note">
                            Note: This is a booking request. Admin will approve or reject your booking.
                            If you cancel after approval, cancellation penalty may apply.
                        </div>

                        <div class="form-actions">
                            <a class="btn btn-light" href="vehicles">Cancel</a>
                            <button class="btn btn-success" type="submit">
                                Submit Booking Request →
                            </button>
                        </div>

                    </form>

                </div>

            </div>

        <% } %>

    </div>

</div>

<script>
    function getTodayDate() {
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, "0");
        const dd = String(today.getDate()).padStart(2, "0");
        return yyyy + "-" + mm + "-" + dd;
    }

    function setMinDates() {
        const today = getTodayDate();
        const pickupDate = document.getElementById("pickupDate");
        const returnDate = document.getElementById("returnDate");

        if (pickupDate) {
            pickupDate.min = today;
        }

        if (returnDate) {
            returnDate.min = today;
        }
    }

    function setReturnMinDate() {
        const pickupDate = document.getElementById("pickupDate");
        const returnDate = document.getElementById("returnDate");

        if (pickupDate && returnDate && pickupDate.value) {
            returnDate.min = pickupDate.value;

            if (returnDate.value && returnDate.value < pickupDate.value) {
                returnDate.value = pickupDate.value;
            }
        }
    }

    function calculateRent() {
        const pickup = document.getElementById("pickupDate");
        const ret = document.getElementById("returnDate");
        const rentElement = document.getElementById("rent");

        if (!pickup || !ret || !rentElement) {
            return;
        }

        const p = pickup.value;
        const r = ret.value;
        const rent = parseFloat(rentElement.innerText.replace(/,/g, ""));

        if (p && r && !isNaN(rent)) {
            const d1 = new Date(p);
            const d2 = new Date(r);

            let diff = Math.floor((d2 - d1) / (1000 * 60 * 60 * 24)) + 1;

            if (diff < 1) {
                diff = 0;
            }

            document.getElementById("days").innerText = diff;
            document.getElementById("total").innerText = (diff * rent).toFixed(2);
        } else {
            document.getElementById("days").innerText = "0";
            document.getElementById("total").innerText = "0";
        }
    }

    window.onload = function() {
        setMinDates();
        calculateRent();
    };
</script>

</body>
</html>
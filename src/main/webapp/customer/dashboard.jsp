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
    String userName = safe(session.getAttribute("userName"));
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard - Online Vehicle Rental Portal</title>
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

        .hero-card {
            margin-top: 30px;
            min-height: 360px;
            padding: 38px;
            border-radius: 30px;
            color: #ffffff;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.96), rgba(67, 56, 202, 0.9));
            box-shadow: 0 25px 70px rgba(15, 23, 42, 0.24);
            position: relative;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 26px;
            align-items: center;
            animation: fadeUp 0.75s ease both;
        }

        .hero-card::before {
            content: "";
            position: absolute;
            width: 310px;
            height: 310px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -110px;
            top: -110px;
        }

        .hero-card::after {
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
            margin-bottom: 16px;
        }

        .hero-title {
            font-size: 42px;
            line-height: 1.15;
            font-weight: 900;
            margin-bottom: 14px;
        }

        .hero-title span {
            color: #67e8f9;
        }

        .hero-subtitle {
            color: #dbeafe;
            line-height: 1.8;
            font-size: 15px;
            max-width: 640px;
            margin-bottom: 26px;
        }

        .hero-actions {
            display: flex;
            gap: 13px;
            flex-wrap: wrap;
        }

        .hero-visual {
            position: relative;
            z-index: 1;
            display: grid;
            place-items: center;
        }

        .vehicle-circle {
            width: 270px;
            height: 270px;
            border-radius: 50%;
            display: grid;
            place-items: center;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: inset 0 0 40px rgba(255,255,255,0.09);
            animation: floatVehicle 3s ease-in-out infinite;
        }

        .vehicle-icon {
            font-size: 110px;
            filter: drop-shadow(0 18px 18px rgba(0,0,0,0.25));
        }

        @keyframes floatVehicle {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-14px);
            }
        }

        .dashboard-section {
            margin-top: 28px;
        }

        .section-heading {
            margin-bottom: 18px;
        }

        .section-heading h2 {
            color: #0f172a;
            font-size: 27px;
            font-weight: 900;
            margin-bottom: 6px;
        }

        .section-heading p {
            color: #64748b;
            font-size: 14px;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .feature-card {
            padding: 22px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
            transition: 0.35s ease;
            position: relative;
            overflow: hidden;
            animation: fadeUp 0.85s ease both;
        }

        .feature-card:hover {
            transform: translateY(-8px) scale(1.01);
            box-shadow: 0 25px 60px rgba(15, 23, 42, 0.17);
        }

        .feature-card::before {
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

        .feature-card:hover::before {
            left: 125%;
        }

        .feature-icon {
            width: 52px;
            height: 52px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            color: #ffffff;
            font-size: 25px;
            margin-bottom: 16px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            box-shadow: 0 12px 28px rgba(99, 102, 241, 0.25);
        }

        .feature-card h3 {
            color: #0f172a;
            font-size: 18px;
            font-weight: 900;
            margin-bottom: 9px;
        }

        .feature-card p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.7;
            margin-bottom: 16px;
        }

        .feature-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            font-weight: 800;
            color: #4338ca;
            transition: 0.3s ease;
        }

        .feature-link:hover {
            color: #06b6d4;
            transform: translateX(5px);
        }


        .info-item-icon {
            width: 44px;
            height: 44px;
            border-radius: 15px;
            display: grid;
            place-items: center;
            color: #ffffff;
            font-size: 21px;
            background: linear-gradient(135deg, #22c55e, #14b8a6);
        }

        .info-item h4 {
            color: #0f172a;
            font-size: 14px;
            font-weight: 900;
            margin-bottom: 3px;
        }

        .info-item p {
            color: #64748b;
            font-size: 12px;
            line-height: 1.5;
        }

        @media (max-width: 1050px) {
            .hero-card {
                grid-template-columns: 1fr;
            }

            .hero-visual {
                display: none;
            }

            .feature-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .info-strip {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 680px) {
            .customer-nav-inner {
                flex-direction: column;
            }

            .customer-links {
                justify-content: center;
            }

            .hero-card {
                padding: 28px 22px;
                min-height: auto;
            }

            .hero-title {
                font-size: 30px;
            }

            .hero-actions .btn {
                width: 100%;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }

            .section-heading h2 {
                font-size: 23px;
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
                <a class="active" href="dashboard">Dashboard</a>
                <a href="vehicles">Vehicles</a>
                <a href="my-bookings">My Bookings</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="hero-card">
            <div class="hero-content">
                <div class="hero-badge">✨ Customer Dashboard</div>

                <h1 class="hero-title">
                    Welcome, <span><%= userName %></span>
                </h1>

                <p class="hero-subtitle">
                    Search available vehicles, book rentals, track your booking status,
                    cancel booking with penalty rules, and view invoices in one simple portal.
                </p>

                <div class="hero-actions">
                    <a class="btn btn-primary" href="vehicles">Browse Vehicles →</a>
                    <a class="btn btn-light" href="my-bookings">My Bookings</a>
                </div>
            </div>

            <div class="hero-visual">
                <div class="vehicle-circle">
                    <div class="vehicle-icon">🚗</div>
                </div>
            </div>
        </div>

        <!-- Features -->
        <div class="dashboard-section">

            <div class="section-heading">
                <h2>What You Can Do</h2>
                <p>Quick access to important customer features</p>
            </div>

            <div class="feature-grid">

                <div class="feature-card">
                    <div class="feature-icon">🔎</div>
                    <h3>Search Vehicles</h3>
                    <p>Browse cars, bikes and scooters with rent details, fuel type and availability.</p>
                    <a class="feature-link" href="vehicles">Search Now →</a>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">📅</div>
                    <h3>Book Vehicle</h3>
                    <p>Select pickup and return dates to book your preferred vehicle easily.</p>
                    <a class="feature-link" href="vehicles">Book Now →</a>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">📋</div>
                    <h3>Track Booking</h3>
                    <p>Check pending, approved, cancelled and completed booking status anytime.</p>
                    <a class="feature-link" href="my-bookings">View Status →</a>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🧾</div>
                    <h3>View Invoice</h3>
                    <p>Open invoice details including rent, penalty, fine and final total amount.</p>
                    <a class="feature-link" href="my-bookings">View Invoice →</a>
                </div>

            </div>

        </div>


    </div>

</div>

</body>
</html>
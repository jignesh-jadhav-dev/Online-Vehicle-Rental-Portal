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

    public String selected(String currentValue, String optionValue) {
        if (currentValue == null) return "";
        return currentValue.equalsIgnoreCase(optionValue) ? "selected" : "";
    }
%>

<%
    Vehicle v = (Vehicle) request.getAttribute("vehicle");
    boolean edit = v != null;

    String pageTitle = edit ? "Edit Vehicle" : "Add Vehicle";
    String formAction = edit ? "vehicle-edit" : "vehicle-add";
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= pageTitle %> - Admin Panel</title>
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

        .form-hero {
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

        .form-hero::before {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.11);
            right: -95px;
            top: -95px;
        }

        .form-hero::after {
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

        .form-card {
            margin-top: 24px;
            padding: 28px;
            border-radius: 28px;
            background: rgba(255, 255, 255, 0.86);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            box-shadow: 0 20px 55px rgba(15, 23, 42, 0.14);
            animation: fadeUp 0.85s ease both;
        }

        .form-card-header {
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .form-card-header h2 {
            font-size: 26px;
            color: #0f172a;
            font-weight: 800;
        }

        .form-card-header p {
            color: #64748b;
            font-size: 14px;
            margin-top: 5px;
        }

        .vehicle-form-grid {
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

        .form-actions {
            margin-top: 26px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .preview-box {
            margin-top: 24px;
            padding: 20px;
            border-radius: 22px;
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            display: grid;
            grid-template-columns: 180px 1fr;
            gap: 18px;
            align-items: center;
        }

        .preview-img {
            width: 180px;
            height: 115px;
            object-fit: cover;
            border-radius: 18px;
            background: #e2e8f0;
            border: 1px solid #e2e8f0;
        }

        .preview-info h3 {
            color: #0f172a;
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .preview-info p {
            color: #64748b;
            font-size: 13px;
            line-height: 1.7;
        }

        @media (max-width: 800px) {
            .vehicle-form-grid {
                grid-template-columns: 1fr;
            }

            .preview-box {
                grid-template-columns: 1fr;
            }

            .preview-img {
                width: 100%;
                height: 180px;
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

            .form-hero {
                padding: 25px 20px;
            }

            .form-card {
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
                <a href="bookings">Bookings</a>
                <a href="vehicles">Back</a>
                <a class="logout-link" href="<%=request.getContextPath()%>/logout">Logout</a>
            </div>
        </div>
    </div>

    <div class="container">

        <!-- Hero -->
        <div class="form-hero">
            <div class="hero-content">
                <div>
                    <div class="hero-badge"><%= edit ? "✏️ Update Vehicle" : "➕ New Vehicle" %></div>
                    <h1 class="hero-title"><%= pageTitle %></h1>
                    <p class="hero-subtitle">
                        <%= edit 
                            ? "Update vehicle details like rent, status, fuel type, model and image URL."
                            : "Add a new rental vehicle with complete details like type, brand, model, rent and availability status."
                        %>
                    </p>
                </div>

                <a class="btn btn-light" href="vehicles">← Back to Vehicles</a>
            </div>
        </div>

        <!-- Form Card -->
        <div class="form-card">

            <div class="form-card-header">
                <div>
                    <h2><%= edit ? "Edit Vehicle Details" : "Vehicle Information" %></h2>
                    <p>Fill all required fields carefully. Vehicle number must be unique.</p>
                </div>
            </div>

            <form method="post" action="<%= formAction %>">

                <% if(edit) { %>
                    <input type="hidden" name="id" value="<%= v.getId() %>">
                <% } %>

                <div class="vehicle-form-grid">

                    <div class="form-group">
                        <label>Vehicle Name</label>
                        <div class="input-wrap">
                            <span class="input-icon">🚗</span>
                            <input 
                                type="text"
                                name="vehicleName" 
                                required 
                                placeholder="Example: Maruti Swift"
                                value="<%= edit ? safe(v.getVehicleName()) : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Vehicle Type</label>
                        <div class="input-wrap">
                            <span class="input-icon">🚘</span>
                            <select name="vehicleType" required>
                                <option value="Car" <%= edit ? selected(v.getVehicleType(), "Car") : "" %>>Car</option>
                                <option value="Bike" <%= edit ? selected(v.getVehicleType(), "Bike") : "" %>>Bike</option>
                                <option value="Scooter" <%= edit ? selected(v.getVehicleType(), "Scooter") : "" %>>Scooter</option>
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
                                required 
                                placeholder="Example: Honda"
                                value="<%= edit ? safe(v.getBrand()) : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Model</label>
                        <div class="input-wrap">
                            <span class="input-icon">📌</span>
                            <input 
                                type="text"
                                name="model" 
                                required 
                                placeholder="Example: Activa 6G"
                                value="<%= edit ? safe(v.getModel()) : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Vehicle Number</label>
                        <div class="input-wrap">
                            <span class="input-icon">🔢</span>
                            <input 
                                type="text"
                                name="vehicleNumber" 
                                required 
                                placeholder="Example: MH12AB1234"
                                value="<%= edit ? safe(v.getVehicleNumber()) : "" %>">
                        </div>
                        <div class="hint-text">Use unique vehicle number. Example: MH12AB1001</div>
                    </div>

                    <div class="form-group">
                        <label>Fuel Type</label>
                        <div class="input-wrap">
                            <span class="input-icon">⛽</span>
                            <select name="fuelType" required>
                                <option value="Petrol" <%= edit ? selected(v.getFuelType(), "Petrol") : "" %>>Petrol</option>
                                <option value="Diesel" <%= edit ? selected(v.getFuelType(), "Diesel") : "" %>>Diesel</option>
                                <option value="CNG" <%= edit ? selected(v.getFuelType(), "CNG") : "" %>>CNG</option>
                                <option value="Electric" <%= edit ? selected(v.getFuelType(), "Electric") : "" %>>Electric</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Rent Per Day</label>
                        <div class="input-wrap">
                            <span class="input-icon">₹</span>
                            <input 
                                type="number" 
                                step="0.01" 
                                min="0"
                                name="rentPerDay" 
                                required 
                                placeholder="Example: 1200"
                                value="<%= edit ? safe(v.getRentPerDay()) : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <div class="input-wrap">
                            <span class="input-icon">📊</span>
                            <select name="status" required>
                                <option value="AVAILABLE" <%= edit ? selected(v.getStatus(), "AVAILABLE") : "" %>>AVAILABLE</option>
                                <option value="BOOKED" <%= edit ? selected(v.getStatus(), "BOOKED") : "" %>>BOOKED</option>
                                <option value="MAINTENANCE" <%= edit ? selected(v.getStatus(), "MAINTENANCE") : "" %>>MAINTENANCE</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label>Image URL</label>
                        <div class="input-wrap">
                            <span class="input-icon">🖼️</span>
                            <input 
                                type="url"
                                name="imageUrl" 
                                id="imageUrl"
                                placeholder="Paste vehicle image URL"
                                value="<%= edit && v.getImageUrl() != null ? safe(v.getImageUrl()) : "" %>"
                                oninput="updatePreview()">
                        </div>
                        <div class="hint-text">Optional. You can paste any vehicle image link.</div>
                    </div>

                </div>

                <!-- Image Preview -->
                <div class="preview-box">
                    <img 
                        id="previewImg"
                        class="preview-img"
                        src="<%= edit && v.getImageUrl() != null && !v.getImageUrl().trim().isEmpty() ? safe(v.getImageUrl()) : "https://via.placeholder.com/350x220?text=Vehicle+Preview" %>"
                        onerror="this.src='https://via.placeholder.com/350x220?text=Vehicle+Preview';"
                        alt="Vehicle Preview">

                    <div class="preview-info">
                        <h3>Vehicle Preview</h3>
                        <p>
                            Image preview will update automatically when you paste an image URL.
                            This makes the admin panel more user-friendly and professional.
                        </p>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="btn btn-light" href="vehicles">Cancel</a>
                    <button class="btn btn-primary" type="submit">
                        <%= edit ? "Update Vehicle →" : "Save Vehicle →" %>
                    </button>
                </div>

            </form>

        </div>

    </div>

</div>

<script>
    function updatePreview() {
        const url = document.getElementById("imageUrl").value;
        const preview = document.getElementById("previewImg");

        if (url.trim() === "") {
            preview.src = "https://via.placeholder.com/350x220?text=Vehicle+Preview";
        } else {
            preview.src = url;
        }
    }
</script>

</body>
</html>
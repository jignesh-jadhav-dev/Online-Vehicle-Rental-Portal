<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    public String safe(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Register - Online Vehicle Rental Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Common CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <!-- Page Specific CSS -->
    <style>
        .register-page {
            min-height: 100vh;
            padding: 35px 18px;
            display: grid;
            place-items: center;
            position: relative;
            overflow: hidden;
        }

        .register-page::before,
        .register-page::after {
            content: "";
            position: absolute;
            border-radius: 50%;
            opacity: 0.45;
            filter: blur(10px);
            animation: floatShape 7s ease-in-out infinite alternate;
            z-index: 0;
        }

        .register-page::before {
            width: 340px;
            height: 340px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            top: -110px;
            right: -90px;
        }

        .register-page::after {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, #f472b6, #f59e0b);
            bottom: -100px;
            left: -90px;
            animation-delay: 1.1s;
        }

        @keyframes floatShape {
            from {
                transform: translateY(0) scale(1);
            }
            to {
                transform: translateY(35px) scale(1.08);
            }
        }

        .register-card {
            width: min(900px, 96%);
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.84);
            backdrop-filter: blur(22px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            border-radius: 28px;
            box-shadow: 0 25px 70px rgba(15, 23, 42, 0.2);
            padding: 35px;
            animation: slideUp 0.8s ease both;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(28px) scale(0.98);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .register-header {
            text-align: center;
            margin-bottom: 28px;
        }

        .register-icon {
            width: 74px;
            height: 74px;
            margin: 0 auto 14px;
            display: grid;
            place-items: center;
            border-radius: 24px;
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            color: white;
            font-size: 34px;
            box-shadow: 0 14px 35px rgba(99, 102, 241, 0.35);
            animation: softBounce 2.2s ease-in-out infinite;
        }

        @keyframes softBounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-8px);
            }
        }

        .register-header h2 {
            font-size: 32px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .register-header p {
            color: #64748b;
            font-size: 14px;
        }

        .register-grid {
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
        .input-wrap textarea {
            padding-left: 44px;
        }

        .input-wrap textarea {
            min-height: 95px;
            resize: vertical;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 14px;
            font-size: 17px;
            opacity: 0.75;
        }

        .password-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }

        .show-password {
            font-size: 12px;
            color: #4338ca;
            cursor: pointer;
            font-weight: 700;
            user-select: none;
        }

        .hint-text {
            margin-top: 6px;
            font-size: 12px;
            color: #64748b;
        }

        .register-btn {
            width: 100%;
            padding: 14px 20px;
            font-size: 15px;
            margin-top: 5px;
        }

        .login-text {
            margin-top: 20px;
            text-align: center;
            color: #64748b;
            font-size: 14px;
        }

        .login-text a {
            color: #4338ca;
            font-weight: 800;
            transition: 0.25s;
        }

        .login-text a:hover {
            color: #06b6d4;
            text-decoration: underline;
        }


        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        @media (max-width: 780px) {
            .register-card {
                padding: 28px 22px;
            }

            .register-grid {
                grid-template-columns: 1fr;
            }

            .register-header h2 {
                font-size: 27px;
            }
        }

        @media (max-width: 460px) {
            .register-page {
                padding: 20px 12px;
            }

            .register-card {
                padding: 24px 18px;
                border-radius: 22px;
            }

            .register-icon {
                width: 62px;
                height: 62px;
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

<div class="register-page">

    <div class="register-card">

        <div class="register-header">
            <div class="register-icon">📝</div>
            <h2>Create Customer Account</h2>
            <p>Register your details and start booking vehicles easily</p>
        </div>

        <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <%= safe(request.getParameter("error")) %>
            </div>
        <% } %>

        <form action="<%=request.getContextPath()%>/register" method="post">

            <div class="register-grid">

                <div class="form-group">
                    <label>Full Name</label>
                    <div class="input-wrap">
                        <span class="input-icon">👤</span>
                        <input 
                            type="text"
                            name="name" 
                            required 
                            placeholder="Enter your full name"
                            autocomplete="name">
                    </div>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <span class="input-icon">📧</span>
                        <input 
                            type="email" 
                            name="email" 
                            required 
                            placeholder="Enter your email"
                            autocomplete="email">
                    </div>
                </div>

                <div class="form-group">
                    <label>Mobile Number</label>
                    <div class="input-wrap">
                        <span class="input-icon">📱</span>
                        <input 
                            type="tel" 
                            name="mobile" 
                            required 
                            placeholder="Enter mobile number"
                            pattern="[0-9]{10}"
                            maxlength="10"
                            title="Please enter 10 digit mobile number"
                            autocomplete="tel">
                    </div>
                    <div class="hint-text">Enter 10 digit mobile number.</div>
                </div>

                <div class="form-group">
                    <label>Driving License Number</label>
                    <div class="input-wrap">
                        <span class="input-icon">🪪</span>
                        <input 
                            type="text" 
                            name="licenseNo" 
                            required 
                            placeholder="Enter driving license number">
                    </div>
                </div>

                <div class="form-group full-width">
                    <label>Address</label>
                    <div class="input-wrap">
                        <span class="input-icon">📍</span>
                        <textarea 
                            name="address" 
                            required 
                            placeholder="Enter your complete address"></textarea>
                    </div>
                </div>

                <div class="form-group full-width">
                    <div class="password-row">
                        <label>Password</label>
                        <span class="show-password" onclick="togglePassword()">Show Password</span>
                    </div>

                    <div class="input-wrap">
                        <span class="input-icon">🔒</span>
                        <input 
                            type="password" 
                            name="password" 
                            id="password"
                            required 
                            placeholder="Create a strong password"
                            minlength="6"
                            autocomplete="new-password">
                    </div>
                    <div class="hint-text">Use at least 6 characters. Example: Jignesh@123</div>
                </div>

            </div>

            <button class="btn btn-primary register-btn" type="submit">
                Create Account →
            </button>

        </form>

        <p class="login-text">
            Already registered?
            <a href="<%=request.getContextPath()%>/login.jsp">Login Here</a>
        </p>


    </div>

</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById("password");
        const toggleText = document.querySelector(".show-password");

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            toggleText.innerText = "Hide Password";
        } else {
            passwordInput.type = "password";
            toggleText.innerText = "Show Password";
        }
    }
</script>

</body>
</html>
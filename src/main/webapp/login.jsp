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
    <title>Login - Online Vehicle Rental Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Common CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/style.css">

    <!-- Page Specific CSS -->
    <style>
        .auth-page {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 25px;
            position: relative;
            overflow: hidden;
        }

        .auth-page::before,
        .auth-page::after {
            content: "";
            position: absolute;
            width: 330px;
            height: 330px;
            border-radius: 50%;
            filter: blur(10px);
            opacity: 0.45;
            animation: floatOrb 7s ease-in-out infinite alternate;
            z-index: 0;
        }

        .auth-page::before {
            background: linear-gradient(135deg, #6366f1, #06b6d4);
            top: -90px;
            left: -90px;
        }

        .auth-page::after {
            background: linear-gradient(135deg, #f472b6, #f59e0b);
            bottom: -100px;
            right: -90px;
            animation-delay: 1.2s;
        }

        @keyframes floatOrb {
            from {
                transform: translateY(0) scale(1);
            }
            to {
                transform: translateY(35px) scale(1.08);
            }
        }

        .login-container {
            width: min(980px, 96%);
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            background: rgba(255, 255, 255, 0.78);
            backdrop-filter: blur(22px);
            border: 1px solid rgba(255, 255, 255, 0.45);
            border-radius: 28px;
            box-shadow: 0 25px 70px rgba(15, 23, 42, 0.22);
            overflow: hidden;
            position: relative;
            z-index: 1;
            animation: loginPop 0.8s ease both;
        }

        @keyframes loginPop {
            from {
                opacity: 0;
                transform: translateY(28px) scale(0.98);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .login-left {
            padding: 45px;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.96), rgba(67, 56, 202, 0.92));
            color: #ffffff;
            position: relative;
            overflow: hidden;
        }

        .login-left::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.12);
            right: -80px;
            bottom: -80px;
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 25px;
        }

        .login-left h1 {
            font-size: 42px;
            line-height: 1.15;
            margin-bottom: 18px;
            font-weight: 800;
        }

        .login-left p {
            color: #dbeafe;
            font-size: 15px;
            line-height: 1.8;
            max-width: 430px;
        }

        .feature-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 28px;
        }

        .feature-pills span {
            padding: 9px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.13);
            color: #ffffff;
            font-size: 12px;
            font-weight: 600;
        }

        .login-right {
            padding: 45px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .login-icon {
            width: 72px;
            height: 72px;
            margin: 0 auto 14px;
            display: grid;
            place-items: center;
            border-radius: 22px;
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

        .login-header h2 {
            font-size: 30px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .login-header p {
            color: #64748b;
            font-size: 14px;
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
            opacity: 0.7;
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

        .login-btn {
            width: 100%;
            margin-top: 5px;
            padding: 14px 20px;
            font-size: 15px;
        }

        .register-text {
            margin-top: 20px;
            text-align: center;
            color: #64748b;
            font-size: 14px;
        }

        .register-text a {
            color: #4338ca;
            font-weight: 800;
            transition: 0.25s;
        }

        .register-text a:hover {
            color: #06b6d4;
            text-decoration: underline;
        }

        .demo-box {
            margin-top: 24px;
            padding: 15px;
            border-radius: 16px;
            background: #f8fafc;
            border: 0px dashed #cbd5e1;
            color: #475569;
            font-size: 13px;
            line-height: 1.7;
        }

        .demo-box strong {
            color: #0f172a;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
        }

        @media (max-width: 850px) {
            .login-container {
                grid-template-columns: 1fr;
            }

            .login-left {
                display: none;
            }

            .login-right {
                padding: 32px 24px;
            }
        }

        @media (max-width: 480px) {
            .login-header h2 {
                font-size: 25px;
            }

            .auth-page {
                padding: 15px;
            }
        }
        
.video-left {
    padding: 0 !important;
    position: relative;
    overflow: hidden;
    min-height: 620px;
    height: 100%;
    background: linear-gradient(135deg, #eef2ff, #f8fafc);
    display: flex;
    align-items: center;
    justify-content: center;
}

.login-video {
    width: 100%;
    height: 100%;
    min-height: 620px;
    object-fit: contain;
    object-position: center center;
    display: block;
    background: linear-gradient(135deg, #eef2ff, #f8fafc);
}

.video-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(
        135deg,
        rgba(15, 23, 42, 0.02),
        rgba(99, 102, 241, 0.05)
    );
    pointer-events: none;
}

.login-container {
    align-items: stretch;
}

.login-right {
    display: flex;
    flex-direction: column;
    justify-content: center;
}

@media (max-width: 850px) {
    .video-left {
        display: none;
    }

    .login-container {
        grid-template-columns: 1fr;
    }
}        
        
        
    </style>
</head>

<body>

<div class="auth-page">

    <div class="login-container">

<!-- Login video -->    
   <div class="login-left video-left">

    <video 
        id="loginVideo"
        class="login-video"
        autoplay
        muted
        loop
        playsinline
        preload="auto">

        <source src="<%=request.getContextPath()%>/assets/video/vehicle-rental.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>

    <div class="video-overlay"></div>

</div>	

        <!-- Login Form Section -->
        <div class="login-right">

            <div class="login-header">
                <div class="login-icon">🚘</div>
                <h2>Welcome Back</h2>
                <p>Login to continue to your dashboard</p>
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

            <form action="<%=request.getContextPath()%>/login" method="post">

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
                            placeholder="Enter your password"
                            autocomplete="current-password">
                    </div>
                </div>

                <button class="btn btn-primary login-btn" type="submit">
                    Login Now →
                </button>

            </form>

            <p class="register-text">
                New customer?
                <a href="<%=request.getContextPath()%>/register.jsp">Create Account</a>
            </p>

        </div>

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
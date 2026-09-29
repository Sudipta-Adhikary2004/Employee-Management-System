<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Employee Management System</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Modern Design CSS -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body class="login-body">
    <div class="login-card">
        <div class="login-header">
            <div class="login-icon">
                <i class="fa-solid fa-cubes-notch fa-spin-slow"></i>
            </div>
            <h1 class="login-title">Enterprise Portal</h1>
            <p class="login-subtitle">Employee Management System</p>
        </div>

        <%-- Beautiful slide-in Error message --%>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="alert alert-danger" id="errorAlert">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><%= error %></span>
            </div>
        <%
            }
        %>

        <form action="LoginServlet" method="POST" class="login-form">
            <div class="form-group">
                <label for="uname" class="form-label">Username</label>
                <div style="position: relative;">
                    <i class="fa-regular fa-user" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
                    <input type="text" id="uname" name="uname" class="form-control" style="padding-left: 2.75rem;" placeholder="Enter your username" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="pass" class="form-label">Password</label>
                <div style="position: relative;">
                    <i class="fa-solid fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
                    <input type="password" id="pass" name="pass" class="form-control" style="padding-left: 2.75rem;" placeholder="••••••••" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary login-btn">
                <span>Sign In</span>
                <i class="fa-solid fa-arrow-right-to-bracket"></i>
            </button>
        </form>
    </div>
</body>
</html>

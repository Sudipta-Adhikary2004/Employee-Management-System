<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Employee" %>
<%
    // Session and Security check
    User currentUser = (User) session.getAttribute("user");
    Employee employee = (Employee) session.getAttribute("employee");
    if (currentUser == null || !"EMPLOYEE".equalsIgnoreCase(currentUser.getRole()) || employee == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get initials for avatar
    String empName = employee.getEname();
    String initials = empName != null && empName.length() > 0 ? empName.substring(0, Math.min(2, empName.length())).toUpperCase() : "EM";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Portal - Dashboard</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Modern Design CSS -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fa-solid fa-cubes-notch"></i>
                    <span>EMS Portal</span>
                </div>
                <div class="sidebar-subtitle">Employee Hub</div>
            </div>

            <ul class="sidebar-menu">
                <li class="sidebar-menu-item active">
                    <a href="employee-dashboard.jsp">
                        <i class="fa-solid fa-address-card"></i>
                        <span>My Profile</span>
                    </a>
                </li>
                <li class="sidebar-menu-item">
                    <a href="change-password.jsp">
                        <i class="fa-solid fa-key"></i>
                        <span>Change Password</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <div class="sidebar-user">
                    <div class="sidebar-avatar"><%= initials %></div>
                    <div class="sidebar-user-info">
                        <span class="sidebar-user-name"><%= empName %></span>
                        <span class="sidebar-user-role">Employee</span>
                    </div>
                    <a href="LogoutServlet" title="Log Out" style="margin-left: auto; color: rgba(255,255,255,0.6);"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
                </div>
            </div>
        </aside>

        <!-- Main Body Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title-group">
                    <h2>Welcome, <%= empName %>!</h2>
                    <p>Access and verify your official corporate profile details.</p>
                </div>
                <div class="header-actions">
                    <span style="font-size: 0.9rem; color: var(--text-secondary); background: #fff; padding: 0.5rem 1rem; border-radius: 20px; border: 1px solid var(--border-color); font-weight: 500;">
                        <i class="fa-solid fa-circle-check" style="color: var(--success); margin-right: 0.25rem;"></i>
                        Account Active
                    </span>
                </div>
            </header>

            <!-- Profile Info Grid -->
            <section class="profile-card">
                <div class="profile-avatar-large"><%= initials %></div>
                <h3 class="profile-name"><%= empName %></h3>
                <span class="profile-role-tag"><%= employee.getDesig() != null ? employee.getDesig() : "Staff Associate" %></span>

                <div class="profile-details-grid">
                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Employee ID</span>
                        <span class="profile-detail-value">#<%= employee.getEmpid() %></span>
                    </div>

                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Official Email</span>
                        <span class="profile-detail-value"><%= employee.getEmail() %></span>
                    </div>

                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Phone Number</span>
                        <span class="profile-detail-value"><%= employee.getPhno() != null ? employee.getPhno() : "Not Provided" %></span>
                    </div>

                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Department</span>
                        <span class="profile-detail-value"><%= employee.getDept() != null ? employee.getDept() : "Not Assigned" %></span>
                    </div>

                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Date of Joining</span>
                        <span class="profile-detail-value"><%= employee.getDoj() != null ? employee.getDoj().toString() : "N/A" %></span>
                    </div>

                    <div class="profile-detail-item">
                        <span class="profile-detail-label">Compensation Tier</span>
                        <span class="profile-detail-value">₹<%= String.format("%,.2f", employee.getSal()) %> / year</span>
                    </div>
                </div>
            </section>
        </main>
    </div>
</body>
</html>

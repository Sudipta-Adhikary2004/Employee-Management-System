<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Session and Security check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());
    String userName = currentUser.getUname();
    String initials = userName != null && userName.length() > 0 ? userName.substring(0, Math.min(2, userName.length())).toUpperCase() : "US";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - Employee Management System</title>
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Modern Design CSS -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="app-container">
        <!-- Dynamic Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fa-solid fa-cubes-notch"></i>
                    <span>EMS Portal</span>
                </div>
                <div class="sidebar-subtitle"><%= isAdmin ? "Enterprise Suite" : "Employee Hub" %></div>
            </div>

            <ul class="sidebar-menu">
                <% if (isAdmin) { %>
                    <li class="sidebar-menu-item">
                        <a href="admin-dashboard.jsp">
                            <i class="fa-solid fa-chart-pie"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="ViewEmployeeServlet">
                            <i class="fa-solid fa-users"></i>
                            <span>Employee List</span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="add-employee.jsp">
                            <i class="fa-solid fa-user-plus"></i>
                            <span>Add Employee</span>
                        </a>
                    </li>
                <% } else { %>
                    <li class="sidebar-menu-item">
                        <a href="employee-dashboard.jsp">
                            <i class="fa-solid fa-address-card"></i>
                            <span>My Profile</span>
                        </a>
                    </li>
                <% } %>
                <li class="sidebar-menu-item active">
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
                        <span class="sidebar-user-name"><%= userName %></span>
                        <span class="sidebar-user-role"><%= currentUser.getRole() %></span>
                    </div>
                    <a href="LogoutServlet" title="Log Out" style="margin-left: auto; color: rgba(255,255,255,0.6);"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
                </div>
            </div>
        </aside>

        <!-- Main Body Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title-group">
                    <h2>Change Password</h2>
                    <p>Update your authentication password to keep your account secure.</p>
                </div>
                <div class="header-actions">
                    <a href="<%= isAdmin ? "admin-dashboard.jsp" : "employee-dashboard.jsp" %>" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Back to Portal</span>
                    </a>
                </div>
            </header>

            <section class="dashboard-panel" style="max-width: 600px; margin: 0 auto; width: 100%;">
                <div class="panel-header">
                    <h3 class="panel-title">Update Security Credentials</h3>
                </div>

                <%-- Dynamic Status notifications --%>
                <%
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    if (error != null) {
                %>
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span><%= error %></span>
                    </div>
                <%
                    }
                    if (success != null) {
                %>
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        <span><%= success %></span>
                    </div>
                <%
                    }
                %>

                <form action="ChangePasswordServlet" method="POST" style="display: flex; flex-direction: column; gap: 1.5rem;">
                    <div class="form-group">
                        <label for="oldPass" class="form-label">Current Password *</label>
                        <input type="password" id="oldPass" name="oldPass" class="form-control" placeholder="••••••••" required>
                    </div>

                    <div class="form-group">
                        <label for="newPass" class="form-label">New Password *</label>
                        <input type="password" id="newPass" name="newPass" class="form-control" placeholder="••••••••" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPass" class="form-label">Confirm New Password *</label>
                        <input type="password" id="confirmPass" name="confirmPass" class="form-control" placeholder="••••••••" required>
                    </div>

                    <div class="form-footer" style="margin-top: 1rem;">
                        <a href="<%= isAdmin ? "admin-dashboard.jsp" : "employee-dashboard.jsp" %>" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-shield-halved"></i>
                            <span>Update Password</span>
                        </button>
                    </div>
                </form>
            </section>
        </main>
    </div>
</body>
</html>

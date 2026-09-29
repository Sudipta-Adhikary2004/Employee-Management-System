<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.EmployeeDAO" %>
<%
    
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }

    
    EmployeeDAO empDAO = new EmployeeDAO();
    int totalEmployees = empDAO.getTotalEmployeesCount();
    double avgSalary = empDAO.getAverageSalary();
    int deptCount = empDAO.getDepartmentCount();

    
    String userName = currentUser.getUname();
    String initials = userName != null && userName.length() > 0 ? userName.substring(0, Math.min(2, userName.length())).toUpperCase() : "AD";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Employee Management System</title>
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
               
            </div>

            <ul class="sidebar-menu">
                <li class="sidebar-menu-item active">
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
                        <span class="sidebar-user-name"><%= userName %></span>
                        <span class="sidebar-user-role">Administrator</span>
                    </div>
                    <a href="LogoutServlet" title="Log Out" style="margin-left: auto; color: rgba(255,255,255,0.6);"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
                </div>
            </div>
        </aside>

        <!-- Main Body Content -->
        <main class="main-content">
            <header class="page-header">
                <div class="page-title-group">
                    <h2>Welcome Back, Admin!</h2>
                    <p>System metrics overview and fast action shortcuts.</p>
                </div>
                <div class="header-actions">
                    <span style="font-size: 0.9rem; color: var(--text-secondary); background: #fff; padding: 0.5rem 1rem; border-radius: 20px; border: 1px solid var(--border-color); font-weight: 500;">
                        <i class="fa-regular fa-calendar-check" style="color: var(--primary); margin-right: 0.25rem;"></i>
                        Today is <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(new java.util.Date()) %>
                    </span>
                </div>
            </header>

            <!-- Metrics Cards Grid -->
            <section class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-info">
                        <h4>Total Directory</h4>
                        <div class="metric-value"><%= totalEmployees %></div>
                    </div>
                    <div class="metric-icon">
                        <i class="fa-solid fa-users-viewfinder"></i>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-info">
                        <h4>Average Salary</h4>
                        <div class="metric-value">₹<%= String.format("%,.2f", avgSalary) %></div>
                    </div>
                    <div class="metric-icon">
                        <i class="fa-solid fa-wallet"></i>
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-info">
                        <h4>Departments</h4>
                        <div class="metric-value"><%= deptCount %></div>
                    </div>
                    <div class="metric-icon">
                        <i class="fa-solid fa-sitemap"></i>
                    </div>
                </div>
            </section>

            <!-- Detailed Content Panel -->
            <section class="dashboard-panel" style="margin-top: 1rem;">
                <div class="panel-header">
                    <h3 class="panel-title">Quick Actions Panel</h3>
                </div>
                <p style="color: var(--text-secondary); margin-bottom: 1.5rem; font-size: 0.95rem;">Select from the actions below to manage employee directories or alter database structures.</p>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.5rem;">
                    <a href="ViewEmployeeServlet" class="btn btn-secondary" style="height: 120px; flex-direction: column; gap: 0.5rem; justify-content: center; border-radius: var(--radius-lg);">
                        <i class="fa-solid fa-address-book" style="font-size: 2rem; color: var(--primary);"></i>
                        <span style="font-weight: 700; font-family: 'Outfit';">View &amp; Edit Employees</span>
                    </a>
                    
                    <a href="add-employee.jsp" class="btn btn-secondary" style="height: 120px; flex-direction: column; gap: 0.5rem; justify-content: center; border-radius: var(--radius-lg);">
                        <i class="fa-solid fa-user-plus" style="font-size: 2rem; color: var(--secondary);"></i>
                        <span style="font-weight: 700; font-family: 'Outfit';">Add New Roster</span>
                    </a>

                    <a href="change-password.jsp" class="btn btn-secondary" style="height: 120px; flex-direction: column; gap: 0.5rem; justify-content: center; border-radius: var(--radius-lg);">
                        <i class="fa-solid fa-shield-halved" style="font-size: 2rem; color: var(--success);"></i>
                        <span style="font-weight: 700; font-family: 'Outfit';">Security &amp; Password</span>
                    </a>
                </div>
            </section>
        </main>
    </div>
</body>
</html>

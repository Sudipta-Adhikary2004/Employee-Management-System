<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Session and Security check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get Admin name initials for avatar
    String userName = currentUser.getUname();
    String initials = userName != null && userName.length() > 0 ? userName.substring(0, Math.min(2, userName.length())).toUpperCase() : "AD";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Employee - Employee Management System</title>
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
                <div class="sidebar-subtitle">Enterprise Suite</div>
            </div>

            <ul class="sidebar-menu">
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
                <li class="sidebar-menu-item active">
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
                    <h2>Add New Employee</h2>
                    <p>Create a profile and generate initial login credentials automatically.</p>
                </div>
                <div class="header-actions">
                    <a href="ViewEmployeeServlet" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span>Roster Directory</span>
                    </a>
                </div>
            </header>

            <section class="dashboard-panel" style="max-width: 800px; margin: 0 auto; width: 100%;">
                <div class="panel-header">
                    <h3 class="panel-title">Employee Profile Registration</h3>
                </div>

                <%-- Beautiful slide-in alert messages --%>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span><%= error %></span>
                    </div>
                <%
                    }
                %>

                <form action="AddEmployeeServlet" method="POST" class="form-grid">
                    <div class="form-group">
                        <label for="ename" class="form-label">Employee Name</label>
                        <input type="text" id="ename" name="ename" class="form-control" placeholder="Jane Doe" required>
                    </div>

                    <div class="form-group">
                        <label for="phno" class="form-label">Phone Number</label>
                        <input type="text" id="phno" name="phno" class="form-control" placeholder="+1 (555) 123-4567">
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="jane.doe@company.com" required>
                    </div>

                    <div class="form-group">
                        <label for="dept" class="form-label">Department</label>
                        <select id="dept" name="dept" class="form-control" required>
                            <option value="">--Select Department--</option>
                            <option value="HR">HR</option>
                            <option value="IT">IT</option>
                            <option value="Sales">Sales</option>
                            <option value="Finance">Finance</option>
                            <option value="Marketing">Marketing</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="desig" class="form-label">Designation</label>
                        <input type="text" id="desig" name="desig" class="form-control" placeholder="Senior Specialist">
                    </div>

                    <div class="form-group">
                        <label for="doj" class="form-label">Date of Joining</label>
                        <input type="date" id="doj" name="doj" class="form-control" required>
                    </div>

                    <div class="form-group form-group-full">
                        <label for="sal" class="form-label">Salary (INR)</label>
                        <input type="number" step="0.01" id="sal" name="sal" class="form-control" placeholder="50000.00" required>
                    </div>

                    <div class="form-group form-group-full form-footer">
                        <a href="ViewEmployeeServlet" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-user-plus"></i>
                            <span>Register Employee</span>
                        </button>
                    </div>
                </form>
            </section>
        </main>
    </div>
</body>
</html>

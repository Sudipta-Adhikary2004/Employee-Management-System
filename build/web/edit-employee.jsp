<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Employee" %>
<%
    // Session and Security check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Retrieve employee object from request
    Employee emp = (Employee) request.getAttribute("employee");
    if (emp == null) {
        response.sendRedirect("ViewEmployeeServlet");
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
    <title>Edit Employee - Employee Management System</title>
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
                <li class="sidebar-menu-item active">
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
                    <h2>Edit Employee Profile</h2>
                    <p>Modify record for employee ID #<%= emp.getEmpid() %>.</p>
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
                    <h3 class="panel-title">Update Profile Details</h3>
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

                <form action="UpdateEmployeeServlet" method="POST" class="form-grid">
                    <!-- Hidden input for Employee ID -->
                    <input type="hidden" name="empid" value="<%= emp.getEmpid() %>">

                    <div class="form-group">
                        <label class="form-label">Employee ID</label>
                        <div class="form-control" style="background-color: #f1f5f9; border-color: #cbd5e1; font-weight: 700; color: var(--text-secondary);">
                            #<%= emp.getEmpid() %>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="ename" class="form-label">Employee Name</label>
                        <input type="text" id="ename" name="ename" class="form-control" value="<%= emp.getEname() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="phno" class="form-label">Phone Number</label>
                        <input type="text" id="phno" name="phno" class="form-control" value="<%= emp.getPhno() != null ? emp.getPhno() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" value="<%= emp.getEmail() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="dept" class="form-label">Department</label>
                        <select id="dept" name="dept" class="form-control" required>
                            <option value="HR" <%= "HR".equals(emp.getDept()) ? "selected" : "" %>>HR</option>
                            <option value="IT" <%= "IT".equals(emp.getDept()) ? "selected" : "" %>>IT</option>
                            <option value="Sales" <%= "Sales".equals(emp.getDept()) ? "selected" : "" %>>Sales</option>
                            <option value="Finance" <%= "Finance".equals(emp.getDept()) ? "selected" : "" %>>Finance</option>
                            <option value="Marketing" <%= "Marketing".equals(emp.getDept()) ? "selected" : "" %>>Marketing</option>
                            <option value="Admin" <%= "Admin".equals(emp.getDept()) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="desig" class="form-label">Designation</label>
                        <input type="text" id="desig" name="desig" class="form-control" value="<%= emp.getDesig() != null ? emp.getDesig() : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="doj" class="form-label">Date of Joining</label>
                        <input type="date" id="doj" name="doj" class="form-control" value="<%= emp.getDoj() != null ? emp.getDoj().toString() : "" %>" required>
                    </div>

                    <div class="form-group">
                        <label for="sal" class="form-label">Salary (INR)</label>
                        <input type="number" step="0.01" id="sal" name="sal" class="form-control" value="<%= emp.getSal() %>" required>
                    </div>

                    <div class="form-group form-group-full form-footer">
                        <a href="ViewEmployeeServlet" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk"></i>
                            <span>Save Changes</span>
                        </button>
                    </div>
                </form>
            </section>
        </main>
    </div>
</body>
</html>

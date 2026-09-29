<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Employee" %>
<%@ page import="model.User" %>
<%
    // Session and Security check
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Retrieve parameters passed by ViewEmployeeServlet
    List<Employee> employeeList = (List<Employee>) request.getAttribute("employeeList");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    String sortBy = (String) request.getAttribute("sortBy");
    String sortOrder = (String) request.getAttribute("sortOrder");
    String search = (String) request.getAttribute("search");
    if (search == null) {
        search = "";
    }
    
    // Toggle sort order helper
    String nextSortOrder = "ASC".equals(sortOrder) ? "DESC" : "ASC";
    
    // Get Admin name initials for avatar
    String userName = currentUser.getUname();
    String initials = userName != null && userName.length() > 0 ? userName.substring(0, Math.min(2, userName.length())).toUpperCase() : "AD";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Employees - Employee Management System</title>
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
                    <h2>Employee Directory</h2>
                    <p>Manage, sort, search, and delete staff accounts.</p>
                </div>
                <div class="header-actions">
                    <a href="add-employee.jsp" class="btn btn-primary">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Add Employee</span>
                    </a>
                </div>
            </header>

            <!-- Table Filter & Search Controls -->
            <section class="dashboard-panel">
                <div class="table-filter-panel">
                    <form action="ViewEmployeeServlet" method="GET" class="search-box" id="searchForm">
                        <!-- Keep sorting parameters active while searching -->
                        <input type="hidden" name="sortBy" value="<%= sortBy %>">
                        <input type="hidden" name="sortOrder" value="<%= sortOrder %>">
                        
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" name="search" id="directorySearch" class="form-control" 
                               placeholder="Search name, email, department..." 
                               value="<%= search %>" autocomplete="off">
                    </form>
                    
                    <div style="font-size: 0.88rem; color: var(--text-secondary);">
                        <% if (!search.isEmpty()) { %>
                            Showing results for "<strong><%= search %></strong>" 
                            <a href="ViewEmployeeServlet?sortBy=<%= sortBy %>&sortOrder=<%= sortOrder %>" style="margin-left: 0.5rem; color: var(--error);"><i class="fa-solid fa-circle-xmark"></i> Clear</a>
                        <% } %>
                    </div>
                </div>

                <%
                    if (employeeList == null || employeeList.isEmpty()) {
                %>
                    <div style="text-align: center; padding: 3rem 1.5rem; background: #f8fafc; border-radius: var(--radius-md); border: 2px dashed var(--border-color);">
                        <i class="fa-solid fa-users-slash" style="font-size: 3rem; color: #94a3b8; margin-bottom: 1rem;"></i>
                        <h4 style="margin-bottom: 0.25rem;">No Employees Found</h4>
                        <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">We couldn't find any employees matching your search criteria.</p>
                        <a href="add-employee.jsp" class="btn btn-secondary">Register New Employee</a>
                    </div>
                <%
                    } else {
                %>
                    <div class="table-container">
                        <table class="custom-table" id="employeeTable">
                            <thead>
                                <tr>
                                    <th>
                                        <a href="ViewEmployeeServlet?page=<%= currentPage %>&sortBy=empid&sortOrder=<%= "empid".equals(sortBy) ? nextSortOrder : "ASC" %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>">
                                            ID 
                                            <% if ("empid".equals(sortBy)) { %>
                                                <i class="fa-solid <%= "ASC".equals(sortOrder) ? "fa-caret-up" : "fa-caret-down" %>" style="color: var(--primary);"></i>
                                            <% } else { %>
                                                <i class="fa-solid fa-sort" style="opacity: 0.3;"></i>
                                            <% } %>
                                        </a>
                                    </th>
                                    <th>
                                        <a href="ViewEmployeeServlet?page=<%= currentPage %>&sortBy=ename&sortOrder=<%= "ename".equals(sortBy) ? nextSortOrder : "ASC" %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>">
                                            Name 
                                            <% if ("ename".equals(sortBy)) { %>
                                                <i class="fa-solid <%= "ASC".equals(sortOrder) ? "fa-caret-up" : "fa-caret-down" %>" style="color: var(--primary);"></i>
                                            <% } else { %>
                                                <i class="fa-solid fa-sort" style="opacity: 0.3;"></i>
                                            <% } %>
                                        </a>
                                    </th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                    <th>
                                        <a href="ViewEmployeeServlet?page=<%= currentPage %>&sortBy=dept&sortOrder=<%= "dept".equals(sortBy) ? nextSortOrder : "ASC" %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>">
                                            Department 
                                            <% if ("dept".equals(sortBy)) { %>
                                                <i class="fa-solid <%= "ASC".equals(sortOrder) ? "fa-caret-up" : "fa-caret-down" %>" style="color: var(--primary);"></i>
                                            <% } else { %>
                                                <i class="fa-solid fa-sort" style="opacity: 0.3;"></i>
                                            <% } %>
                                        </a>
                                    </th>
                                    <th>Designation</th>
                                    <th>Joining Date</th>
                                    <th>
                                        <a href="ViewEmployeeServlet?page=<%= currentPage %>&sortBy=sal&sortOrder=<%= "sal".equals(sortBy) ? nextSortOrder : "ASC" %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>">
                                            Salary 
                                            <% if ("sal".equals(sortBy)) { %>
                                                <i class="fa-solid <%= "ASC".equals(sortOrder) ? "fa-caret-up" : "fa-caret-down" %>" style="color: var(--primary);"></i>
                                            <% } else { %>
                                                <i class="fa-solid fa-sort" style="opacity: 0.3;"></i>
                                            <% } %>
                                        </a>
                                    </th>
                                    <th style="text-align: right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Employee emp : employeeList) {
                                        String dept = emp.getDept() != null ? emp.getDept() : "";
                                        String deptClass = "badge-default";
                                        if ("HR".equalsIgnoreCase(dept)) deptClass = "badge-hr";
                                        else if ("IT".equalsIgnoreCase(dept)) deptClass = "badge-it";
                                        else if ("Sales".equalsIgnoreCase(dept)) deptClass = "badge-sales";
                                        else if ("Finance".equalsIgnoreCase(dept)) deptClass = "badge-finance";
                                        else if ("Marketing".equalsIgnoreCase(dept)) deptClass = "badge-marketing";
                                        else if ("Admin".equalsIgnoreCase(dept)) deptClass = "badge-admin";
                                %>
                                    <tr>
                                        <td><strong>#<%= emp.getEmpid() %></strong></td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                <div style="width: 32px; height: 32px; border-radius: 50%; background: #e0e7ff; color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem;">
                                                    <%= emp.getEname().substring(0, Math.min(1, emp.getEname().length())).toUpperCase() %>
                                                </div>
                                                <span style="font-weight: 600;"><%= emp.getEname() %></span>
                                            </div>
                                        </td>
                                        <td><%= emp.getPhno() != null ? emp.getPhno() : "-" %></td>
                                        <td><%= emp.getEmail() %></td>
                                        <td><span class="badge <%= deptClass %>"><%= dept %></span></td>
                                        <td style="color: var(--text-secondary); font-weight: 500;"><%= emp.getDesig() != null ? emp.getDesig() : "-" %></td>
                                        <td><%= emp.getDoj() != null ? emp.getDoj().toString() : "-" %></td>
                                        <td style="font-family: 'Outfit'; font-weight: 600; color: hsl(224, 40%, 15%);">₹<%= String.format("%,.2f", emp.getSal()) %></td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; gap: 0.25rem;">
                                                <a href="EditEmployeeServlet?empid=<%= emp.getEmpid() %>" class="btn-action edit" title="Edit Profile">
                                                    <i class="fa-regular fa-pen-to-square"></i>
                                                </a>
                                                <a href="#" 
                                                   onclick="showDeleteModal(event, 'DeleteEmployeeServlet?empid=<%= emp.getEmpid() %>', '<%= emp.getEname().replace("'", "\\'") %>')" 
                                                   class="btn-action delete" title="Delete Employee">
                                                    <i class="fa-regular fa-trash-can"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination Navigation Footer -->
                    <div class="pagination-panel">
                        <div class="pagination-info">
                            Page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong>
                        </div>
                        
                        <div class="pagination-controls">
                            <% if (currentPage > 1) { %>
                                <a href="ViewEmployeeServlet?page=<%= currentPage - 1 %>&sortBy=<%= sortBy %>&sortOrder=<%= sortOrder %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>" class="pagination-btn">
                                    <i class="fa-solid fa-chevron-left" style="margin-right: 0.5rem;"></i> Previous
                                </a>
                            <% } else { %>
                                <span class="pagination-btn disabled">
                                    <i class="fa-solid fa-chevron-left" style="margin-right: 0.5rem;"></i> Previous
                                </span>
                            <% } %>

                            <% if (currentPage < totalPages) { %>
                                <a href="ViewEmployeeServlet?page=<%= currentPage + 1 %>&sortBy=<%= sortBy %>&sortOrder=<%= sortOrder %>&search=<%= java.net.URLEncoder.encode(search, "UTF-8") %>" class="pagination-btn">
                                    Next <i class="fa-solid fa-chevron-right" style="margin-left: 0.5rem;"></i>
                                </a>
                            <% } else { %>
                                <span class="pagination-btn disabled">
                                    Next <i class="fa-solid fa-chevron-right" style="margin-left: 0.5rem;"></i>
                                </span>
                            <% } %>
                        </div>
                    </div>
                <%
                    }
                %>
            </section>
        </main>
    </div>

    <!-- Premium Custom Confirmation Modal -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <div class="modal-warning-icon">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <h3 class="modal-title">Delete Employee Account?</h3>
            </div>
            <div class="modal-body">
                Are you sure you want to permanently delete <strong id="deleteEmployeeName">the employee</strong>? <br>
                This action is irreversible and will remove their profile and login credentials.
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Yes, Delete Employee</a>
            </div>
        </div>
    </div>

    <!-- Client-side Fast Live Searching Script & Custom Modal Controls -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var searchInput = document.getElementById("directorySearch");
            
            // Client side fast table filtration (KeyUp fallback)
            searchInput.addEventListener("keyup", function() {
                var value = this.value.toLowerCase().trim();
                var tableRows = document.querySelectorAll("#employeeTable tbody tr");
                
                tableRows.forEach(function(row) {
                    var text = row.textContent.toLowerCase();
                    if (text.indexOf(value) > -1) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            });

            // Trigger actual server side query when user hits Enter
            var searchForm = document.getElementById("searchForm");
            searchForm.addEventListener("submit", function() {
                // Ensure form submits query parameter properly
            });
        });

        // Delete Confirmation Modal Handling
        var deleteModal = document.getElementById("deleteModal");
        var deleteEmployeeNameStr = document.getElementById("deleteEmployeeName");
        var confirmDeleteBtn = document.getElementById("confirmDeleteBtn");

        function showDeleteModal(event, url, empName) {
            event.preventDefault();
            deleteEmployeeNameStr.textContent = empName;
            confirmDeleteBtn.setAttribute("href", url);
            deleteModal.classList.add("active");
        }

        function closeDeleteModal() {
            deleteModal.classList.remove("active");
        }

        // Close on clicking outside the modal card
        deleteModal.addEventListener("click", function(event) {
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        });
    </script>
</body>
</html>

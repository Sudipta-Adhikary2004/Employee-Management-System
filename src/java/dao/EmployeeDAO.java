package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Employee;

public class EmployeeDAO {

    
    public boolean addEmployee(Employee emp, String username, String password) {
        String insertEmp = "INSERT INTO emp (ename, phno, email, dept, desig, doj, sal) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertLogin = "INSERT INTO login (empid, uname, pass, role) VALUES (?, ?, ?, 'EMPLOYEE')";
        
        Connection conn = null;
        PreparedStatement psEmp = null;
        PreparedStatement psLogin = null;
        ResultSet rsKeys = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); 
            
           
            psEmp = conn.prepareStatement(insertEmp, Statement.RETURN_GENERATED_KEYS);
            psEmp.setString(1, emp.getEname());
            psEmp.setString(2, emp.getPhno());
            psEmp.setString(3, emp.getEmail());
            psEmp.setString(4, emp.getDept());
            psEmp.setString(5, emp.getDesig());
            psEmp.setDate(6, emp.getDoj());
            psEmp.setDouble(7, emp.getSal());
            
            int affectedRows = psEmp.executeUpdate();
            if (affectedRows == 0) {
                conn.rollback();
                return false;
            }
            
            
            rsKeys = psEmp.getGeneratedKeys();
            int newEmpId = 0;
            if (rsKeys.next()) {
                newEmpId = rsKeys.getInt(1);
            } else {
                conn.rollback();
                return false;
            }
            
           
            psLogin = conn.prepareStatement(insertLogin);
            psLogin.setInt(1, newEmpId);
            psLogin.setString(2, username);
            psLogin.setString(3, password);
            
            psLogin.executeUpdate();
            
            conn.commit(); 
            
           
            String subject = "Welcome to the Company! Your Account is Created";
            String body = "Dear " + emp.getEname() + ",\n\n"
                    + "Your profile has been created successfully. Below are your login credentials:\n"
                    + "Username: " + username + "\n"
                    + "Password: " + password + "\n\n"
                    + "Please log in to the Employee Portal and update your password immediately.\n\n"
                    + "Best Regards,\nAdmin Team";
            DBConnection.sendEmail(emp.getEmail(), subject, body);
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            closeResources(rsKeys, psEmp, psLogin, conn);
        }
    }

    
    public Employee getEmployeeById(int empid) {
        String sql = "SELECT * FROM emp WHERE empid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, empid);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Employee(
                        rs.getInt("empid"),
                        rs.getString("ename"),
                        rs.getString("phno"),
                        rs.getString("email"),
                        rs.getString("dept"),
                        rs.getString("desig"),
                        rs.getDate("doj"),
                        rs.getDouble("sal")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    
    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE emp SET ename = ?, phno = ?, email = ?, dept = ?, desig = ?, doj = ?, sal = ? WHERE empid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, emp.getEname());
            ps.setString(2, emp.getPhno());
            ps.setString(3, emp.getEmail());
            ps.setString(4, emp.getDept());
            ps.setString(5, emp.getDesig());
            ps.setDate(6, emp.getDoj());
            ps.setDouble(7, emp.getSal());
            ps.setInt(8, emp.getEmpid());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                
                String subject = "Alert: Your Employee Profile is Updated";
                String body = "Dear " + emp.getEname() + ",\n\n"
                        + "Your profile details have been updated by the Administrator. If you did not request this, please contact support.\n\n"
                        + "Updated Profile Summary:\n"
                        + "Name: " + emp.getEname() + "\n"
                        + "Department: " + emp.getDept() + "\n"
                        + "Designation: " + emp.getDesig() + "\n"
                        + "Salary: $" + emp.getSal() + "\n\n"
                        + "Best Regards,\nHR Team";
                DBConnection.sendEmail(emp.getEmail(), subject, body);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    
    public boolean deleteEmployee(int empid) {
        String sql = "DELETE FROM emp WHERE empid = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, empid);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public List<Employee> getEmployees(int start, int limit, String sortBy, String sortOrder) {
        return getEmployees(start, limit, sortBy, sortOrder, null);
    }

    
    public List<Employee> getEmployees(int start, int limit, String sortBy, String sortOrder, String search) {
        List<Employee> list = new ArrayList<>();
        
        
        String validSortBy = "empid";
        if ("ename".equalsIgnoreCase(sortBy) || "dept".equalsIgnoreCase(sortBy) || "sal".equalsIgnoreCase(sortBy)) {
            validSortBy = sortBy;
        }
        
        
        String validSortOrder = "ASC";
        if ("DESC".equalsIgnoreCase(sortOrder)) {
            validSortOrder = "DESC";
        }
        
        boolean hasSearch = (search != null && !search.trim().isEmpty());
        String sql;
        if (hasSearch) {
            sql = "SELECT * FROM emp WHERE ename LIKE ? OR email LIKE ? OR dept LIKE ? OR desig LIKE ? ORDER BY " + validSortBy + " " + validSortOrder + " LIMIT ? OFFSET ?";
        } else {
            sql = "SELECT * FROM emp ORDER BY " + validSortBy + " " + validSortOrder + " LIMIT ? OFFSET ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (hasSearch) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
                ps.setString(4, searchPattern);
                ps.setInt(5, limit);
                ps.setInt(6, start);
            } else {
                ps.setInt(1, limit);
                ps.setInt(2, start);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Employee(
                        rs.getInt("empid"),
                        rs.getString("ename"),
                        rs.getString("phno"),
                        rs.getString("email"),
                        rs.getString("dept"),
                        rs.getString("desig"),
                        rs.getDate("doj"),
                        rs.getDouble("sal")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public int getTotalEmployeesCount() {
        return getTotalEmployeesCount(null);
    }

    // 6a. COUNT with SEARCH: Get total employee count matching search criteria
    public int getTotalEmployeesCount(String search) {
        boolean hasSearch = (search != null && !search.trim().isEmpty());
        String sql = hasSearch 
            ? "SELECT COUNT(*) FROM emp WHERE ename LIKE ? OR email LIKE ? OR dept LIKE ? OR desig LIKE ?"
            : "SELECT COUNT(*) FROM emp";
            
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            if (hasSearch) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
                ps.setString(4, searchPattern);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    
    public double getAverageSalary() {
        String sql = "SELECT AVG(sal) FROM emp";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getDepartmentCount() {
        String sql = "SELECT COUNT(DISTINCT dept) FROM emp";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    
    private void closeResources(ResultSet rs, Statement st1, Statement st2, Connection conn) {
        if (rs != null) { try { rs.close(); } catch (SQLException e) {} }
        if (st1 != null) { try { st1.close(); } catch (SQLException e) {} }
        if (st2 != null) { try { st2.close(); } catch (SQLException e) {} }
        if (conn != null) { try { conn.close(); } catch (SQLException e) {} }
    }
}

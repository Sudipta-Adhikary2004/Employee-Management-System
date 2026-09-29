package servlet;

import dao.EmployeeDAO;
import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Employee;

@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final EmployeeDAO empDAO = new EmployeeDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 
        
        String ename = request.getParameter("ename");
        String phno = request.getParameter("phno");
        String email = request.getParameter("email");
        String dept = request.getParameter("dept");
        String desig = request.getParameter("desig");
        String dojStr = request.getParameter("doj");
        String salStr = request.getParameter("sal");

        
        if (ename == null || ename.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Employee Name and Email are mandatory.");
            request.getRequestDispatcher("add-employee.jsp").forward(request, response);
            return;
        }

        try {
            Date doj = Date.valueOf(dojStr);
            double sal = Double.parseDouble(salStr);

            Employee emp = new Employee(ename, phno, email, dept, desig, doj, sal);

            
            String username = email.split("@")[0];
            String password = "emp" + (int)(Math.random() * 9000 + 1000); 

            boolean success = empDAO.addEmployee(emp, username, password);

            if (success) {
                
                request.setAttribute("email", email);
                request.setAttribute("ename", ename);
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                
                request.getRequestDispatcher("SendMailServlet").forward(request, response);
                
            } else {
                request.setAttribute("error", "Error creating employee profile. The email may already exist.");
                request.getRequestDispatcher("add-employee.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid Date or Numeric Salary format.");
            request.getRequestDispatcher("add-employee.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server Error: " + e.getMessage());
            request.getRequestDispatcher("add-employee.jsp").forward(request, response);
        }
    }
}
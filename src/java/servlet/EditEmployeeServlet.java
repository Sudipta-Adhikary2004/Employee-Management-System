package servlet;

import dao.EmployeeDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;
import model.User;

@WebServlet("/EditEmployeeServlet")
public class EditEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final EmployeeDAO empDAO = new EmployeeDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String empidStr = request.getParameter("empid");
        if (empidStr != null) {
            try {
                int empid = Integer.parseInt(empidStr);
                Employee emp = empDAO.getEmployeeById(empid);
                if (emp != null) {
                    request.setAttribute("employee", emp);
                    request.getRequestDispatcher("edit-employee.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("ViewEmployeeServlet");
    }
}

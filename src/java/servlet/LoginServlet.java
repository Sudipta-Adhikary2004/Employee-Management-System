package servlet;

import dao.EmployeeDAO;
import dao.LoginDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;
import model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LoginDAO loginDAO = new LoginDAO();
    private final EmployeeDAO empDAO = new EmployeeDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String uname = request.getParameter("uname");
        String pass = request.getParameter("pass");

        User user = loginDAO.validateUser(uname, pass);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else if ("EMPLOYEE".equalsIgnoreCase(user.getRole())) {
                Employee employee = empDAO.getEmployeeById(user.getEmpid());
                session.setAttribute("employee", employee);
                response.sendRedirect("employee-dashboard.jsp");
            } else {
                request.setAttribute("error", "Unknown User Role.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid Username or Password.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}

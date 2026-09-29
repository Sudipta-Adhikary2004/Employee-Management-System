package servlet;

import dao.EmployeeDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;
import model.User;

@WebServlet("/ViewEmployeeServlet")
public class ViewEmployeeServlet extends HttpServlet {
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

        
        int page = 1;
        int limit = 5; 
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        
        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "empid";
        }
        String sortOrder = request.getParameter("sortOrder");
        if (sortOrder == null || sortOrder.trim().isEmpty()) {
            sortOrder = "ASC";
        }

        
        String search = request.getParameter("search");
        if (search != null) {
            search = search.trim();
        }

        int totalRecords = empDAO.getTotalEmployeesCount(search);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);
        if (totalPages == 0) totalPages = 1;

        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int start = (page - 1) * limit;

        List<Employee> employeeList = empDAO.getEmployees(start, limit, sortBy, sortOrder, search);

        
        request.setAttribute("employeeList", employeeList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("search", search != null ? search : "");

        request.getRequestDispatcher("view-employees.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

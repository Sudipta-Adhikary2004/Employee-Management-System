package servlet;

import dao.LoginDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LoginDAO loginDAO = new LoginDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        if (oldPass == null || newPass == null || confirmPass == null || 
            oldPass.isEmpty() || newPass.isEmpty() || confirmPass.isEmpty()) {
            request.setAttribute("error", "All fields are mandatory.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "New Password and Confirm Password do not match.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        boolean success = loginDAO.changePassword(currentUser.getEmpid(), oldPass, newPass);

        if (success) {
            
            currentUser.setPass(newPass);
            session.setAttribute("user", currentUser);
            request.setAttribute("success", "Password updated successfully!");
        } else {
            request.setAttribute("error", "Incorrect Old Password.");
        }
        
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}

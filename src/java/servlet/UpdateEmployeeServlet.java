package servlet;

import dao.EmployeeDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;
import model.User;

@WebServlet("/UpdateEmployeeServlet")
public class UpdateEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final EmployeeDAO empDAO = new EmployeeDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
        String ename = request.getParameter("ename");
        String phno = request.getParameter("phno");
        String email = request.getParameter("email");
        String dept = request.getParameter("dept");
        String desig = request.getParameter("desig");
        String dojStr = request.getParameter("doj");
        String salStr = request.getParameter("sal");

        try {
            int empid = Integer.parseInt(empidStr);
            Date doj = Date.valueOf(dojStr);
            double sal = Double.parseDouble(salStr);

            Employee emp = new Employee(empid, ename, phno, email, dept, desig, doj, sal);
            boolean success = empDAO.updateEmployee(emp);

            if (success) {
                
                String subject = "Profile Update Alert - Employee Management System";
                String body = "Dear " + ename + ",\n\n"
                            + "Your profile details have been updated by the Administrator.\n\n"
                            + "Updated Details:\n"
                            + "Department: " + dept + "\n"
                            + "Designation: " + desig + "\n"
                            + "Salary: " + sal + "\n"
                            + "Phone: " + phno + "\n\n"
                            + "If you did not expect this change, please contact HR immediately.\n\n"
                            + "Best Regards,\nHR Team";

                sendEmail(email, subject, body);

                response.sendRedirect("ViewEmployeeServlet");
            } else {
                request.setAttribute("error", "Failed to update employee details. The email might be in use.");
                request.setAttribute("employee", emp);
                request.getRequestDispatcher("edit-employee.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error parsing updated fields. Ensure correct values are filled.");
            e.printStackTrace();
            response.sendRedirect("ViewEmployeeServlet");
        }
    }

   
    private void sendEmail(String to, String subject, String body) {
        final String username = "sudiptaadhikary652@gmail.com"; 
        final String password = "kxzp soze tngk qvme"; 

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("java.net.preferIPv4Stack", "true"); // IPv4 fix

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
            System.out.println("Update email sent successfully to: " + to);
        } catch (MessagingException e) {
            System.out.println("Email sending failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
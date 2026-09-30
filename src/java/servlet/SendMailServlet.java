package servlet;

import java.io.IOException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SendMailServlet")
public class SendMailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String to = (String) request.getAttribute("email");
        String ename = (String) request.getAttribute("ename");
        String username = (String) request.getAttribute("username");
        String password = (String) request.getAttribute("password");

        String subject = "Welcome to Employee Management System";
        String message = "Hello " + ename + ",\n\n"
                       + "Your account has been created successfully.\n"
                       + "Username: " + username + "\n"
                       + "Password: " + password + "\n\n"
                       + "Please login and change your password immediately.";

        final String from = "xyz@gmail.com"; // sender email address
        final String appPassword = "AbcD"; // App password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, appPassword);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);
            msg.setText(message);
            
            Transport.send(msg);
            response.sendRedirect("ViewEmployeeServlet");
            
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Employee added, but email failed: " + e.getMessage());
            request.getRequestDispatcher("ViewEmployeeServlet").forward(request, response);
        }
    }
}

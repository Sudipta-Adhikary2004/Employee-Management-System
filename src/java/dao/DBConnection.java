package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/employee_management?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    
    private static final String PASSWORD = ""; 

    private static final Properties mailProperties = new Properties();
    private static final java.util.concurrent.ExecutorService emailExecutor = java.util.concurrent.Executors.newCachedThreadPool();

    static {
        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        
        try (java.io.InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (is != null) {
                mailProperties.load(is);
                System.out.println("Email properties loaded successfully from mail.properties");
            } else {
                System.out.println("mail.properties not found in classpath. Using default SMTP settings.");
                
                mailProperties.put("mail.smtp.host", "smtp.gmail.com");
                mailProperties.put("mail.smtp.port", "587");
                mailProperties.put("mail.smtp.auth", "true");
                mailProperties.put("mail.smtp.starttls.enable", "true");
                mailProperties.put("mail.smtp.ssl.protocols", "TLSv1.2");
                mailProperties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
                mailProperties.put("mail.smtp.user", "your-email@gmail.com");
                mailProperties.put("mail.smtp.password", "your-app-password");
            }
        } catch (Exception e) {
            System.err.println("Error loading mail.properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    
    public static boolean sendEmail(final String recipientEmail, final String subject, final String emailBody) {
        final String senderEmail = mailProperties.getProperty("mail.smtp.user", "your-email@gmail.com");
        final String senderPassword = mailProperties.getProperty("mail.smtp.password", "your-app-password");

        
        if (senderEmail.equals("your-email@gmail.com") || senderPassword.equals("your-app-password")) {
            System.out.println("--- EMAIL NOTIFICATION (SMTP not configured) ---");
            System.out.println("To: " + recipientEmail);
            System.out.println("Subject: " + subject);
            System.out.println("Body:\n" + emailBody);
            System.out.println("------------------------------------------------");
            return true; 
        }

       
        emailExecutor.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    Session session = Session.getInstance(mailProperties, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(senderEmail, senderPassword);
                        }
                    });

                    Message message = new MimeMessage(session);
                    message.setFrom(new InternetAddress(senderEmail));
                    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                    message.setSubject(subject);
                    message.setText(emailBody);

                    Transport.send(message);
                    System.out.println("Email sent successfully to " + recipientEmail + " in background thread.");
                } catch (Exception e) {
                    System.err.println("Failed to send email to " + recipientEmail + " in background thread: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        });

        
        return true;
    }
}

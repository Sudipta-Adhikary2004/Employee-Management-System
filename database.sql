CREATE DATABASE IF NOT EXISTS employee_management;
USE employee_management;

CREATE TABLE IF NOT EXISTS emp (
    empid INT AUTO_INCREMENT PRIMARY KEY,
    ename VARCHAR(100) NOT NULL,
    phno VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    dept VARCHAR(100),
    desig VARCHAR(100),
    doj DATE,
    sal DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS login (
    empid INT PRIMARY KEY,
    uname VARCHAR(50) UNIQUE NOT NULL,
    pass VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    FOREIGN KEY (empid) REFERENCES emp(empid) ON DELETE CASCADE
);

-- Seed initial Admin User
INSERT INTO emp (empid, ename, phno, email, dept, desig, doj, sal)
VALUES (1, 'Admin User', '9999999999', 'admin@gmail.com', 'Admin', 'System Admin', CURDATE(), 50000.00)
ON DUPLICATE KEY UPDATE ename=ename;

INSERT INTO login (empid, uname, pass, role)
VALUES (1, 'admin', 'admin123', 'ADMIN')
ON DUPLICATE KEY UPDATE empid=empid;

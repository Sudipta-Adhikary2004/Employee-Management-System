package model;

import java.io.Serializable;
import java.sql.Date;

public class Employee implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int empid;
    private String ename;
    private String phno;
    private String email;
    private String dept;
    private String desig;
    private Date doj;
    private double sal;

    
    public Employee() {}

    public Employee(int empid, String ename, String phno, String email, String dept, String desig, Date doj, double sal) {
        this.empid = empid;
        this.ename = ename;
        this.phno = phno;
        this.email = email;
        this.dept = dept;
        this.desig = desig;
        this.doj = doj;
        this.sal = sal;
    }

    public Employee(String ename, String phno, String email, String dept, String desig, Date doj, double sal) {
        this.ename = ename;
        this.phno = phno;
        this.email = email;
        this.dept = dept;
        this.desig = desig;
        this.doj = doj;
        this.sal = sal;
    }

    
    public int getEmpid() {
        return empid;
    }

    public void setEmpid(int empid) {
        this.empid = empid;
    }

    public String getEname() {
        return ename;
    }

    public void setEname(String ename) {
        this.ename = ename;
    }

    public String getPhno() {
        return phno;
    }

    public void setPhno(String phno) {
        this.phno = phno;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDept() {
        return dept;
    }

    public void setDept(String dept) {
        this.dept = dept;
    }

    public String getDesig() {
        return desig;
    }

    public void setDesig(String desig) {
        this.desig = desig;
    }

    public Date getDoj() {
        return doj;
    }

    public void setDoj(Date doj) {
        this.doj = doj;
    }

    public double getSal() {
        return sal;
    }

    public void setSal(double sal) {
        this.sal = sal;
    }
}

package entity;

public class Employee {
    public Employee(Integer empId, String empName, Integer deptId, String gender, String email) {
        this.empId = empId;
        this.empName = empName;
        this.deptId = deptId;
        this.gender = gender;
        this.email = email;
    }

    public Employee() {
    }

    private Integer empId;

    private String empName;

    private Integer deptId;

    private String gender;

    private String email;

    private Department department;

    @Override
    public String toString() {
        return "Employee{" +
                "empId=" + empId +
                ", empName='" + empName + '\'' +
                ", deptId=" + deptId +
                ", gender='" + gender + '\'' +
                ", email='" + email + '\'' +
                ", department=" + department +
                '}';
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public Integer getDeptId() {
        return deptId;
    }

    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }
}
package service;

import entity.Employee;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.List;

@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:mybatisConfig.xml","classpath:springMVC.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class EmployeeServiceTest {


    @Autowired
    EmployeeService employeeService;
    @Test
    public void testgetAllDept(){
        Employee employee = new Employee();
        employee.setEmpName("zangshan");
        int result = employeeService.addEmp(employee);
        System.out.println(result);
    }

    @Test
    public void testEMPCount(){
        boolean result = employeeService.checkUser("mawenzhe1");
        System.out.println(result);
    }

    @Test
    public void testEMPDelete(){
        int i = employeeService.deleteOneEmp(471);
        System.out.println("影响的行数"+i);
    }
    @Test
    public void testEmpDeleteMultiply(){
        List<String> empList = new ArrayList<>();
        empList.add("443");
        empList.add("444");
        employeeService.deleteMultiPlyEmp(empList);
    }

    @Test
    public void testEmpFuzzySearch(){
        List<Employee> employeeList = employeeService.fuzzySearchByEmpName("测试");
        System.out.println(employeeList.size());
        for (Employee employee : employeeList) {
            System.out.println(employee);

        }
    }
}


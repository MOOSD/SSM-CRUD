package dao;

import entity.Department;
import entity.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

@RunWith(value = SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class daoTest {
    //声明成员变量
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSessionBATCH;
    @Test
    public void testDEPT(){
        Department department = new Department(null,"文化部");
        departmentMapper.insertSelective(department);


    }
    @Test
    public void testEMPInsert(){
        Employee employee =  new Employee(null , "uuid" , 1 , "M" , "mawenzhe"+"@ncwu.com");
        employeeMapper.insertSelective(employee);
    }

    @Test
    public void testEMPInsert1000(){

        EmployeeMapper batchEmployeeMapper = sqlSessionBATCH.getMapper(EmployeeMapper.class);

        for(int i=0 ; i<300 ; i++){
            String uuid = UUID.randomUUID().toString().substring(0,5)+i;
            Employee employee =  new Employee(null , uuid , 1 , "M" , uuid+"@ncwu.com");
            batchEmployeeMapper.insertSelective(employee);
        }

    }

    @Test
    public void testEMPUpdate(){
        Employee employee =  new Employee(1 , "mawenzhe" , 1 , "M" , "mawenzhe@ncwu.com");

        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    @Test
    public void testEMPSelectWithExample(){
        List<Employee> employeeList = employeeMapper.selectByExampleWithDept(null);
        System.out.println(employeeList);
    }



}

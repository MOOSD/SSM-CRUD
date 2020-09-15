package service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:mybatisConfig.xml","classpath:springMVC.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class departmentServiceTest {

    @Autowired
    DepartmentService deptService;
    @Test
    public void testgetAllDept(){
        System.out.println(deptService.getAllDepartment());
    }
}

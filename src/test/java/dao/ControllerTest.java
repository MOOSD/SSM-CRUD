package dao;

import com.github.pagehelper.PageInfo;
import entity.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:mybatisConfig.xml","classpath:springMVC.xml"})
public class ControllerTest {
    @Autowired
    WebApplicationContext context;

    MockMvc mockMvc;
    //测试之前先对mockMVC进行初始化
    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
        System.out.println("mockMvc已被初始化");
    }

    @Test
    public void ShowEMP() throws Exception {

        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();
        System.out.println("result"+result);
        //获取request对象
        MockHttpServletRequest request = result.getRequest();
        System.out.println(request);
        PageInfo pageInfo = (PageInfo)request.getAttribute("pageInfo");


        System.out.println("页面大小"+pageInfo.getPageSize());
        System.out.println("当前页面"+pageInfo.getPageNum());
        System.out.println("总页数"+pageInfo.getPages());
        System.out.println("总记录数"+pageInfo.getTotal());
        System.out.println("显示的页码");
        int[] navigatepageNums = pageInfo.getNavigatepageNums();
        for (int i : navigatepageNums){
            System.out.println(" " + i);
        }
        //获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list){
            System.out.println(employee);
        }


    }
}

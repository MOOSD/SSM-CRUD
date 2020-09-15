package controller;

import entity.Department;
import entity.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import service.DepartmentService;

import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    @ResponseBody
    @RequestMapping(value = "depts")
    public Message getAllDept(){
        List<Department> department = departmentService.getAllDepartment();

        return Message.success().add("depts",department);
    }


}

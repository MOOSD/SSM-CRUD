package controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import entity.Employee;
import entity.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import service.EmployeeService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.net.http.HttpRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 员工相关的控制器
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;
    //模糊查询
    @ResponseBody
    @RequestMapping(value = "/search/{empName}",method=RequestMethod.GET)
    public Message fuzzySearch(@PathVariable(value = "empName") String empName){
        PageHelper.startPage(1,9);
        List<Employee> employeeList = employeeService.fuzzySearchByEmpName(empName);
        PageInfo page = new PageInfo(employeeList);
        //返回查询结果
        return Message.success().add("emp",page);
    }

    //单个/批量删除
    @ResponseBody
    @RequestMapping(value="/emp/{empId}",method = RequestMethod.DELETE)
    public Message deleteEmp(@PathVariable(value = "empId") String empId){
        //处理url

        String[] empIdArray = empId.split("-");
        if (empIdArray.length == 1){
            //单个删除
            int i = employeeService.deleteOneEmp(Integer.parseInt(empIdArray[0]));
            if (i==1){
                return Message.success();
            }
        }else{
            //多个删除
            List<Integer> empIdList = new ArrayList<>();
            for (String id : empIdArray) {
                empIdList.add(Integer.parseInt(id));
            }
            employeeService.deleteMultiPlyEmp(empIdList);
        }

        return Message.fail();
    }


    //修改一名员工
    //修改使用put
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Message alertEmp(Employee employee , HttpServletRequest request){
        System.out.println(request.getParameter("deptId"));
        System.out.println(employee);
        int i = employeeService.updateOneEmp(employee);
        if(i>=1){
            return Message.success();
        }
        return Message.fail();

    }


    @ResponseBody
    @RequestMapping(value = "/emp/{id}" ,method = RequestMethod.GET)
    //查询一位员工
    public Message getOneEmp(@PathVariable("id") Integer empId){
        Employee employee = employeeService.selectEmpByPri(empId);
        return Message.success().add("emp",employee);
    }


    //检查用户名是否可用，可用返回success，不可用返回fail
    @ResponseBody
    @RequestMapping("/checkuser")
    public Message checkUser(@RequestParam(value = "empName") String empName){
        boolean checkResult = employeeService.checkUser(empName);

        if(checkResult){
            return Message.success();
        }
        return Message.fail();
    }

    @ResponseBody
    @RequestMapping(value = "/emps/{empName}/{pageNum}",method = RequestMethod.GET)
    public Message showEmployee(@PathVariable String empName, @PathVariable(value = "pageNum") Integer pageNum){
        //查询判断
        if(empName.equals("total")){
            empName = "";
        }
        //分页-
        PageHelper.startPage(pageNum,9);
        List<Employee> employeeList = employeeService.getTotalEmp(empName);
        //使用pageInfo包装查询结果
        PageInfo page = new PageInfo(employeeList,5);
        //将封装好的页面数据放到Message中
        return Message.success().add("emp",page);
    }

    //添加一名员工
    //添加操作，POST方式，URI中不带有保存的数据
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Message addOneEmployee(@Valid Employee employee,BindingResult bindingResult){
        //如果校验失败
        if(bindingResult.hasErrors()){
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            Map<String,Object> map = new HashMap<>();
            for (FieldError fieldError : fieldErrors) {
                System.out.println("错误的字段名"+fieldError.getField());
                System.out.println("错误信息"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Message.fail().add("errorMessage",map);
        }
        else{
            //添加之前先查询，若查询到相同的员工则不进行添加
            int result = employeeService.addEmp(employee);
            return Message.success().add("result",result);
        }

    }


//    @RequestMapping("/empsOld")
//    public String showEmployeeOld(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
//
//        //分页
//        PageHelper.startPage(pn,9);
//        List<Employee> employeeList = employeeService.getTotalEmp();
//        //使用pageInfo包装查询结果
//        PageInfo page = new PageInfo(employeeList,5);
//        //将封装好的页面数据存放到request域中
//        model.addAttribute("pageInfo",page);
//
//        return "list";
//    }
}

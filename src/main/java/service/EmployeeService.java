package service;

import dao.EmployeeMapper;
import entity.Employee;
import entity.EmployeeExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {
    @Autowired
    private EmployeeMapper employeeMapper;

    /**
     * 查询所有员工
     * @return
     */
    public List<Employee> getTotalEmp(String empName){
        String likeString = "%"+empName+"%";
        //调用复杂查询方法，查询所有员工
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //添加模糊查询
        criteria.andEmpNameLike(likeString);
        //设置按照id升序
        example.setOrderByClause("emp_id ASC");

        
        List<Employee> employees = employeeMapper.selectByExampleWithDept(example);
        return employees;
    }

    /**
     * 添加员工
     * @param employee
     * @return
     */
    public int addEmp(Employee employee){
        return employeeMapper.insertSelective(employee);
    }


    /**
     * 检查员工数量
     */
    public boolean checkUser(String empName){
        //实例化复杂查询对象
        EmployeeExample example = new EmployeeExample();
        //
        EmployeeExample.Criteria criteria = example.createCriteria();
        //按照名称作为条件进行查询
        criteria.andEmpNameEqualTo(empName);

        long count = employeeMapper.countByExample(example);
        return count == 0;
    }
    /**
     * 按照员工ID查询
     */
    public Employee selectEmpByPri(Integer empId){
        Employee employee = employeeMapper.selectByPrimaryKeyWithDept(empId);
        return employee;
    }
    /**
     * 更新员工
     */
    public int updateOneEmp(Employee employee){
        return employeeMapper.updateByPrimaryKeySelective(employee);
    }
    /**
     * 删除单个员工
     */
    public int deleteOneEmp(int pk){
        int i = employeeMapper.deleteByPrimaryKey(pk);
        return i;
    }
    /**
     * 批量删除员工
     */
    public int deleteMultiPlyEmp(List empIdList){
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(empIdList);
        int i = employeeMapper.deleteByExample(example);
        return i;
    }
    /**
     * 模糊查询
     */
    public List<Employee> fuzzySearchByEmpName(String empName){
        String likeString = "%"+empName+"%";
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameLike(likeString);
        List<Employee> employeeList = employeeMapper.selectByExampleWithDept(example);
        return employeeList;
    }
}

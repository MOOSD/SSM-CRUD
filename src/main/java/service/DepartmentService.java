package service;

import dao.DepartmentMapper;
import entity.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    DepartmentMapper departmentDao;

    public List<Department> getAllDepartment(){
        List<Department> departments = departmentDao.selectByExample(null);
        return departments;
    }
}

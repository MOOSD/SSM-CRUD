<%--
  Created by IntelliJ IDEA.
  User: 77064
  Date: 2020/9/5
  Time: 19:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--引入标签库--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    pageContext.setAttribute("ProjectPath",request.getContextPath());
%>
<html>
<head>

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>员工列表</title>
    <script type="text/javascript" src="${ProjectPath}/static/bootstrap/js/bootstrap.js"></script>
    <script type="text/javascript" src="${ProjectPath}/static/js/jquery-3.5.1.js"></script>
    <link href="${ProjectPath}/static/bootstrap/css/bootstrap.css" rel="stylesheet">
</head>
<body>
<div class="container">
<%--    标题--%>
    <div class="row">
        <div class="col-md-8">
            <h1>SSM——CURD</h1>
        </div>
    </div>
<%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>

        </div>
    </div>
<%--    表格数据--%>
    <div class="row" style="margin-top: 20px; height: 600px;">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>departmentName</th>
                    <th colspan>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <td>${emp.empId}</td>
                        <td>${emp.empName}</td>
                        <td>${emp.gender}</td>
                        <td>${emp.email}</td>
                        <td>${emp.department.deptName}</td>
                        <td>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
<%--    显示分页信息--%>
    <div class="row">
        <%--        页面信息--%>
        <div class="col-md-6">
            <p>当前${pageInfo.pageNum}页,共${pageInfo.pages}页,包含${pageInfo.total}条记录</p>
        </div>
        <%--        分页条--%>
        <div class="col-md-6 col-md-offset-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li><a href="${ProjectPath}/emps?pn=1">首页</a></li>
                        <li>
                            <a href="${ProjectPath}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${!pageInfo.hasPreviousPage}">
                        <li style="visibility: hidden"><a href="${ProjectPath}/emps?pn=1">首页</a></li>
                        <li class="disabled">
                            <a href="#" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach items="${pageInfo.navigatepageNums}" var="pageNumber">
                        <c:if test="${pageNumber == pageInfo.pageNum}">
                            <li class="active"><a href="#">${pageNumber}</a> </li>
                        </c:if>
                        <c:if test="${pageNumber != pageInfo.pageNum}">
                            <li><a href="${ProjectPath}/emps?pn=${pageNumber}">${pageNumber}</a> </li>
                        </c:if>
                    </c:forEach>

                    <c:if test="${!pageInfo.hasNextPage}">
                        <li class="disabled">
                            <a href="#" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        <li style="visibility: hidden"><a href="${ProjectPath}/emps?pn=${pageInfo.pages}" aria-label="Last">末页</a></li>
                    </c:if>
                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${ProjectPath}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                        <li><a href="${ProjectPath}/emps?pn=${pageInfo.pages}" aria-label="Last">末页</a></li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>

</div>


</body>
</html>

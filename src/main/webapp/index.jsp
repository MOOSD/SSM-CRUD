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
    <title>员工列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
<%--    加载Jquery的js文件--%>
    <script type="text/javascript" src="${ProjectPath}/static/js/jquery-3.5.1.js"></script>

<%--    加载BootStrap的js文件--%>
    <script type="text/javascript" src="${ProjectPath}/static/bootstrap/js/bootstrap.js"></script>

<%--    连接BootStrap的css文件--%>
    <link href="${ProjectPath}/static/bootstrap/css/bootstrap.css" rel="stylesheet">

    <script>
        //声明全局变量
        var TotalPage = 0;
        var TotalRecord = 0;
        var PageSize = 0;
        var PageNum = 0;
    //页面加载完成之后执行
        $(function(){

            //发起ajax请求，请求第一页
            showPage(1);

            //点击新增按钮点击事件
            $("#addEmpButton").click(function () {
                //重置模态框
                resetForm();
                //启动模态框
                $("#empAddPage").modal({});
                //获取到部门信息
                getAllDept($("#selectDept"));
            });

            //给模态框中的提交按钮添加点击事件
            $("#confirmAdd").click(function () {
                confirmAddClickEvent();
            });

            //给添加框增加OnChange事件
            $("#empNameInput").blur(function () {
                empInputBlurEvent();
            });

            //给修改按钮增加点击事件
            $(document).on("click",".editButton",function () {
                //查询员工信息，显示员工信息
                //从按钮中获取员工id
                getEmp($(this).attr("empId"));

                //启动模态框
                $("#empUpdatePage").modal({});

                //将员工id作为属性放到更新按钮上
                $("#confirmUpdate").attr("empId",$(this).attr("empId"));
                //获取到部门信息,并且添加到下拉列表
                getAllDept($("#selectUpdateDept"));
            });
            //为更新提交按钮添加点击事件
            $("#confirmUpdate").on("click",function () {
                confirmUpdateEvent();
            });
            //为删除按钮增加点击事件
            $(document).on("click",".deleteButton",function () {
                var button = $(this);
                //根据按钮状态执行是否发送删除请求
                DeleteEvent(button);

                //按钮变换
                buttonChange(button);
            });
            //给全选的checkBox添加点击事件
            $("#checkAll").on("click",function () {
                CheckAllEvent();
            });
            //给每一条checkBox都添加点击事件
            $(document).on("click",".checkItem",function () {
                checkItemEvent();
            });
            //给全删按钮添加点击事件
            $("#deleteEmpButton").on("click",function () {
                deleteAllButtonEvent($(this));
                deleteAllButtonChange($(this));
            });
            //搜索按钮添加点击事件
            $("#searchBar button").on("click",function(){
                showPage(1);
            })
        });
    //函数定义

        //更改全部删除按钮样式
        function deleteAllButtonChange(button){
            if($(".checkItem:checked").length!=0 && button.attr("waitConfirm")=="false"){
                //添加新属性
                button.attr("waitConfirm",true);
                //移除属性，并且更换文本与颜色
                button.removeClass("btn-danger");
                button.addClass("btn-warning");
                button.text("确认");

                //添加移除焦点的事件
                button.on("blur",function () {
                    //添加新属性
                    button.attr("waitConfirm",false);
                    //移除老属性
                    button.removeClass("btn-warning");
                    button.addClass("btn-danger");
                    button.text("删除");
                })
            }

        }
        //删除按钮增加点击事件
        function deleteAllButtonEvent(button) {
            if(button.attr("waitConfirm")=="true"&&$(".checkItem:checked").length!=0){
                var url = "";
                //获取被选中的列
                $.each($(".checkItem:checked"),function (i,element) {
                    url += $(this).parents("tr").children("td:eq(1)").text()+"-";
                });
                url = url.substring(0,url.length-1);
                //发送点击事件
                console.log(url);
                $.ajax({
                    url:"${ProjectPath}/emp/"+url,
                    data:"_method=DELETE",
                    type:"POST",
                    success:function () {
                        //更改按钮状态
                        //添加新属性
                        button.attr("waitConfirm",false);
                        //移除老属性
                        button.removeClass("btn-warning");
                        button.addClass("btn-danger");
                        button.text("删除");
                        //刷新页面
                        showPage(PageNum);
                    }

                })
            }
            else{
                return;
            }

        }
        //给checkItem添加单击事件
        function checkItemEvent(){
            $("#checkAll").prop("checked",$(".checkItem:checked").length == $(".checkItem").length);
        }
        //给checkBoxAll添加单击事件
        function CheckAllEvent(){
            $(".checkItem").prop("checked",$("#checkAll").prop("checked"));
        }
        //判断按钮状态，并且发送请求
        function DeleteEvent(button){
            var waitConfirm = button.attr("waitConfirm");
            var id = button.attr("empid");
            if(waitConfirm == "true"){
                //发送请求
                $.ajax({
                    url:"${ProjectPath}/emp/"+id,
                    data:"_method=DELETE",
                    type:"POST",
                    success:function () {
                        //刷新此页
                        showPage(PageNum);
                    }
                })
            }else{
                return
            }
        }
        //切换按钮样式
        function buttonChange(button) {
            //添加新属性
            button.attr("waitConfirm",true);
            //移除属性，并且更换文本与颜色
            button.removeClass("btn-danger");
            button.addClass("btn-warning");
            //获取span元素
            var children = button.children("span");
            children.removeClass("glyphicon-remove");
            children.addClass("glyphicon-ok");
            button.html("");
            button.append(children).append(" 确定");


            //添加移除焦点的事件
            button.on("blur",function () {
                //添加新属性
                button.attr("waitConfirm",false);
                //移除老属性
                button.removeClass("btn-warning");
                button.addClass("btn-danger");
                button.text("");
                button.append($("<span aria-hidden='true'></span>").addClass("glyphicon glyphicon-remove" ))
                    .append(" 删除");
            })
        }
        //更新按钮提交的事件
        function confirmUpdateEvent(){
            //验证邮箱是否合法
            //校验邮箱
            var emailInput  = $("#emailUpdateInput");
            var empEmail = emailInput.val();
            var regEmail = /^([a-zA-Z]|[0-9])(\w|\-)+@[a-zA-Z0-9]+\.([a-zA-Z]{2,4})$/;
            emailFlag = regEmail.test(empEmail);
            if(emailFlag){
                verifyElement(emailInput,"success","邮箱格式正确");
                //序列化表单
                var formContext = $("#empUpdatePage form").serialize();
                console.log(formContext);
                //发送Ajax请求
                $.ajax({
                    url:"${ProjectPath}/emp/"+$("#confirmUpdate").attr("empId"),
                    data:formContext+"&_method=PUT",
                    type:"POST",
                    success:function (result) {
                        if(result.code==100){
                            //隐藏模态框
                        $("#empUpdatePage").modal("hide");
                        //再次发送页面请求
                            showPage(PageNum);
                        }
                    }
                })

            }else{
                verifyElement(emailInput,"error","请检查邮箱格式");
            }
        }
        //查询单个员工信息
        function getEmp(empId) {
            $.ajax({
                url:"${ProjectPath}/emp/"+empId,
                type:"GET",
                success:function (data) {
                    //数据显示
                    console.log("员工数据");
                    console.log(data);
                    //数据展示
                    showEmpInfo(data);
                }
            });
        }
        //显示修改页面的默认信息
        function showEmpInfo(data){
            $("#empNameText").text(data.data.emp.empName);
            $("#emailUpdateInput").val(data.data.emp.email);
            $("#empUpdatePage input[name=gender]").val([data.data.emp.gender]);
            $("#empUpdatePage select").val([data.data.emp.deptId])
        }
        //重置表单内容
        function resetForm(){
            //重置模态框
            $("#empAddPage form")[0].reset();
            verifyElement($("#empNameInput"),"reset","用户名要求6~16个字母或者2~5个汉字之内。");
            verifyElement($("#emailInput"),"reset","请输入邮箱");
        }
        //员工信息输入栏Blur事件
        function empInputBlurEvent(){
            //获取到员工输入信息
            var empNameElement = $("#empNameInput");
            var empName = empNameElement.val();
            var submitButton = $("#confirmAdd");
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2e80-\u9fff]{2,5})/;
            //判断用户名是否符合规则
            if(regName.test(empName)){
                //发送Post请求
                $.ajax({
                    url:"${ProjectPath}/checkuser",
                    type:"POST",
                    data:{empName:empName},
                    dataType:"json",
                    success:function (data) {
                        //清除之前的信息
                        submitButton.removeAttr("check-result");
                        if(data.code == 200){
                            //修改表框颜色
                            verifyElement(empNameElement,"error","员工名已存在");
                            //给点击按钮增加一条自定义属性
                            submitButton.attr("check-result","error");
                        }
                        if(data.code == 100){
                            //修改表框颜色
                            verifyElement(empNameElement,"success","员工名可用");
                            submitButton.attr("check-result","success");
                        }
                    }
                });
            }else{
                verifyElement(empNameElement,"error","用户名要求6~16个字母或者2~5个汉字之内。");
            }
        }
        //查询部门信息的ajax
        function getAllDept(SelectElement) {
            $.ajax({
                url:"${ProjectPath}/depts",
                type: "POST",
                dataType: "json",
                success:function (data) {
                    //获取下拉列表
                    buildDeptSelect(data,SelectElement);
                }
            })
        }
        //根据页号显示页面
        function showPage(pageNum) {
            //获取搜索框的值
            var searchValue = $("#searchBar input").val();
            if(searchValue==""){
                searchValue = "total";
            }
            console.log("请求的页码是："+pageNum);
            $.ajax({
                url:"${ProjectPath}/emps/"+searchValue+"/"+pageNum,  //指定发送规定url
                type:"GET",                //指定发送的方式
                dataType:"json",                //处理接收到的参数的方式
                success:function (data) {
                    //调试信息
                    console.log("页面数据信息");
                    console.log(data);
                    //给全局变量赋值
                    TotalPage = data.data.emp.pages;
                    TotalRecord = data.data.emp.total;
                    PageSize = data.data.emp.pageSize;
                    PageNum = data.data.emp.pageNum;
                    //页面处理
                    buildEpmList(data);
                    buildPageInfo(data);
                    buildPageNav(data);
                    //表单处理
                    checkItemEvent();
                }
            })
        }
        //更新表格中的值
        function buildEpmList(data) {
            //清空之前的内容
            $("#empTable tbody").empty();
            //获取返回JSON中的List
            var list = data.data.emp.list;
            //遍历此数据
            $.each(list,function (i,element) {
                var checkBox = $("<td></td>").append($("<input type='checkBox' class='checkItem'/>"));
                var tdEmpID = $("<td></td>").append(element.empId);
                var tdEmpName = $("<td></td>").append(element.empName);
                var tdGender = $("<td></td>").append((element.gender =='M')?"男":"女");
                var tdEmail = $("<td></td>").append(element.email);
                var tdDeptName = $("<td></td>").append(element.department.deptName);
                //创建编辑按钮的时候，会添加两条自定义属性
                var tdButton = $("<td></td>")
                                .append($("<button></button>").addClass("btn btn-primary btn-sm editButton").attr("empId",element.empId)
                                    .append($("<span aria-hidden='true'></span>").addClass("glyphicon glyphicon-pencil"))
                                    .append(" 修改"))
                                .append("  ")
                                .append($("<button></button>").addClass("btn btn-danger btn-sm deleteButton").attr("empId",element.empId)
                                    .append($("<span aria-hidden='true'></span>").addClass("glyphicon glyphicon-remove" ))
                                    .append(" 删除").attr("waitConfirm",false));
                $("<tr></tr>")
                    .append(checkBox)
                    .append(tdEmpID)
                    .append(tdEmpName)
                    .append(tdGender)
                    .append(tdEmail)
                    .append(tdDeptName)
                    .append(tdButton)
                    .appendTo("#empTable tbody");
            })
        }
        //显示页面信息
        function buildPageInfo(data) {
            var pageInfoArea = $("#pageInfoArea");
            pageInfoArea.empty();
            //显示数据(从全局变量中获取)
            pageInfoArea.append($("<p></p>").append("当前"+PageNum+"页,共"+TotalPage+"页,包含条"+TotalRecord+"记录"));
        }
        //显示导航信息
        function buildPageNav(data) {
            //清空之前的区域
            var pageNavArea = $("#pageNavArea");
            pageNavArea.empty();
            var navTb = $("<nav></nav>").attr("aria-label","Page navigation");
            var pageUl = $("<ul></ul>").addClass("pagination");
            var fristPageLi = $("<li></li>").append($("<a></a>").attr("href","#").html("首页"));
            var lastPageLi = $("<li></li>").append($("<a></a>").attr("href","#").html("末页"));
            var previousPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append($("<span></span>").attr("aria-hidden","true").html("&laquo;")));
            var nextPageLi = $("<li></li>").append($("<a></a>").attr("href","#").append($("<span></span>").attr("aria-hidden","true").html("&raquo;")));
            //遍历表格
            $.each(data.data.emp.navigatepageNums,function (i,element) {
                var normalLi = $("<li></li>").append($("<a></a>").attr("href","#").html(element));
                //不使用超链接，而是使用点击事件来发送ajax请求
                normalLi.on("click",function () {
                    showPage(element); //问题

                });
                if(element == data.data.emp.pageNum) {
                    normalLi.addClass("active");
                }
                pageUl.append(normalLi);
            });

            //添加特殊跳转页
            if(!data.data.emp.hasPreviousPage){ //如果没有前页
                previousPageLi.addClass("disabled");
                fristPageLi.attr("style","visibility: hidden");
            }else{
                //为向前翻页添加点击事件
                previousPageLi.on("click",function () {
                    showPage(data.data.emp.pageNum-1);
                });
                fristPageLi.on("click",function () {
                    showPage(1);
                });
            }
            if(!data.data.emp.hasNextPage){ //如果没有后页
                //无法向后翻页
                nextPageLi.addClass("disabled");
                lastPageLi.attr("style","visibility: hidden");
            }else{
                //给向后翻页添加点击事件
                nextPageLi.on("click",function () {
                    showPage(data.data.emp.pageNum+1);
                });
                lastPageLi.on("click",function () {
                    showPage(data.data.emp.pages);
                });
            }

            pageUl.append(nextPageLi).append(lastPageLi).prepend(previousPageLi).prepend(fristPageLi);

            navTb.append(pageUl);
            pageNavArea.append(navTb);

        }
        //更新下拉列表
        function buildDeptSelect(data,selectElement) {
            var selectDept =  selectElement;
            selectDept.empty();
            //清空下拉列表
            $.each(data.data.depts,function(i,element) {
                var deptOption = $("<option></option>").html(element.deptName).attr("value",element.deptId);
                selectDept.append(deptOption);
            });


        }
        //confirmAdd点击事件
        function confirmAddClickEvent(){
            //校验数据
            if(verifyEmpData()){
                //发送Ajax
                $.ajax({
                    async:"true",
                    url:"${ProjectPath}/emp",
                    type:"POST",
                    data:$("#empAddPage form").serialize(),
                    dataType:"json",
                    success:function () {
                        //隐藏模态框
                        $("#empAddPage").modal("hide");
                        //再次计算总页数
                        var lastPage = 0;
                        lastPage = Math.ceil((TotalRecord+1)/PageSize);
                        //页面跳转到最后一页
                        showPage(lastPage);
                    }
                });
            }
            else{
                return false;
            }

        }
        //员工数据校验(使用正则表达式)
        function verifyEmpData() {
            var nameFlag = false ,emailFlag = false ,nameFlage2 = false;
            //校验元素获取
            var empNameInput = $("#empNameInput");
            var emailInput = $("#emailInput");
            //获取按钮中，用户名的校验值
            var CheckResult = $("#confirmAdd").attr("check-result");


            //校验用户名
            var empName = empNameInput.val();
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2e80-\u9fff]{2,5})/;
            nameFlag=regName.test(empName);
            if(nameFlag){
                //检查是否重名
                if(CheckResult=="success"){
                    nameFlage2 = true;
                    verifyElement(empNameInput,"success","用户名可用");
                }else{
                    nameFlage2 = false;
                    verifyElement(empNameInput,"error","员工名已存在");
                }
            }else{
                verifyElement(empNameInput,"error","用户名要求6~16个字母或者2~5个汉字之内。");
            }
            //校验邮箱
            var empEmail = emailInput.val();
            var regEmail = /^([a-zA-Z]|[0-9])(\w|\-)+@[a-zA-Z0-9]+\.([a-zA-Z]{2,4})$/;
            emailFlag = regEmail.test(empEmail);
            if(emailFlag){
                verifyElement(emailInput,"success","邮箱格式正确");

            }else{
                verifyElement(emailInput,"error","请检查邮箱格式");
            }

            //返回结果
            if(nameFlag&&emailFlag&&nameFlage2){
                return true;
            }
            return false;
        }
        //校验某个元素，给其添加提示效果
        function verifyElement(element,status,msg) {
            var eParent = element.parent().parent();
            var eNext = element.next();
            //移除直接祖父元素中的状态信息
            eParent.removeClass("has-error has-success");
            //根据状态改变直接祖父元素中的状态信息
            if("success" == status){
                eParent.addClass("has-success");
            }
            if("error" == status){
                eParent.addClass("has-error");
            }
            if("reset" == status){
                eParent.removeClass("has-success has-error");
            }

            //设置后一个同级元素的InnerText
            eNext.text(msg);
        }

    </script>
</head>
<body>
<%--员工修改的模态框--%>
<div class="modal fade" id="empUpdatePage" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <%--                    text empname--%>
                    <div class="form-group">
                        <label for="empNameInput" class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empNameText">员工姓名</p>
                        </div>

                    </div>
                    <%--                    text email--%>
                    <div class="form-group">
                        <label for="emailInput" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="emailUpdateInput" placeholder="***@nucw.com" aria-describedby="helpBlock4">
                            <span class="help-block" id="helpBlock4">请输入邮箱</span>
                        </div>
                    </div>
                    <%--                    单选框gender--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadioUpdate1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadioUpdate2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <%--                       下拉列表，deptId--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="deptId" id="selectUpdateDept">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="confirmUpdate">更新</button>
            </div>
        </div>
    </div>
</div>
<%--员工添加的模态框--%>

<div class="modal fade" id="empAddPage" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
<%--                    text empname--%>
                    <div class="form-group" id="empNameArea">
                        <label for="empNameInput" class="col-sm-2 control-label">EmpName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empNameInput" placeholder="EmpName" aria-describedby="helpBlock1">
                            <span class="help-block" id="helpBlock1">用户名要求6~16个字母或者2~5个汉字之内。</span>
                        </div>

                    </div>
<%--                    text email--%>
                    <div class="form-group" id="emailArea">
                        <label for="emailInput" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="emailInput" placeholder="***@nucw.com" aria-describedby="helpBlock2">
                            <span class="help-block" id="helpBlock2">请输入邮箱</span>
                        </div>

                    </div>
<%--                    单选框gender--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadio1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="inlineRadio2" value="F"> 女
                            </label>
                        </div>
                    </div>
<%--                       下拉列表，deptId--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Department</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="deptId" id="selectDept">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="confirmAdd">新增</button>
            </div>
        </div>
    </div>
</div>
<%--主容器--%>
<div class="container">
    <%--    标题--%>
    <div class="row">
        <div class="col-md-8">
            <h1>SSM——CURD</h1>
        </div>
    </div>
<%--        搜索框--%>
    <div class="row">
        <div class="col-md-8 col-md-offset-4">
            <form class="form-inline" id="searchBar">
                <input type="search" class="form-control"  placeholder="按姓名查询">
                <button type="submit" class="btn btn-default btn-lg">
                    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>
                </button>
            </form>
        </div>
    </div>
    <%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="addEmpButton">新增</button>
            <button class="btn btn-danger" id="deleteEmpButton" waitconfirm="false">删除</button>

        </div>
    </div>
    <%--    表格数据--%>
    <div class="row" style="margin-top: 20px; height: 600px;">
        <div class="col-md-12">
            <table class="table table-hover" id="empTable">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="checkAll"></th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>departmentName</th>
                        <th colspan>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--    显示分页信息--%>
    <div class="row">
        <%--        页面信息--%>
        <div class="col-md-6" id="pageInfoArea">

        </div>
        <%--        分页条--%>
        <div class="col-md-6 col-md-offset-6" id="pageNavArea">

        </div>
    </div>

</div>


</body>
</html>

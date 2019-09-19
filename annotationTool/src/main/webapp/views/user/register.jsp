<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import="com.mysql.jdbc.Driver" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>实体及关系标注工具</title>
    <link Rel="SHORTCUT ICON" href="http://download.easyicon.net/png/1202904/32/">
	<link rel="stylesheet" href="css/bootstrap.min.css">
    <link href="css/jquery-accordion-menu.css" rel="stylesheet" type="text/css"/>
    <link href="//cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
    <link href="css/index.css" rel="stylesheet" type="text/css">
    <link href="css/text.css" rel="stylesheet" type="text/css">
	<link href="css/smartMenu.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/tether.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/jquery-accordion-menu.js" ></script>

</head>
<body>
<%
	ArrayList<String> users = new ArrayList<String>();

	Connection conn = null;
    //加载数据库驱动类
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    //数据库连接URL
    String url="jdbc:mysql://localhost:3306/kg";
	//数据库用户名和密码
	String user = "root";
	String password = "****";
	//根据数据库参数取得一个数据库连接值
	conn = DriverManager.getConnection(url, user, password);

	//判断是否登录，如果登录按照用户名查询
	String sql = "select * from user"; // 查询数据的sql语句
	Statement st = (Statement) conn.createStatement(); //创建用于执行静态sql语句的Statement对象，st属局部变量

	ResultSet rs = st.executeQuery(sql); //执行sql查询语句，返回查询数据的结果集
	System.out.println("最后的查询结果为：");
	while (rs.next()) { // 判断是否还有下一个数据
		users.add(rs.getString("username"));
		//name = rs.getString("username");
		System.out.println(rs.getString("username"));
		// 根据字段名获取相应的值
	}
%>
<div id="content">
    <div id="leftMenu">
        <div id="menuBar">
            <div id="jquery-accordion-menu" class="jquery-accordion-menu black">
                <div class="jquery-accordion-menu-header" id="form">标注工具</div>
                <ul id="demo-list">
                    <li class="active homeLoad"><a href="uploadFile"><i class="fa fa-file-text "></i>开始标注 </a></li>
                    <li class="anno"><a href="#"><i class="fa fa-tags"></i>实体及关系标注 </a>
                    </li>

                    <li><a href="#"><i class="fa fa-question-circle"></i>说明文档 </a>
                    	<ul class="submenu">
		                    <li><a href="http://180.76.145.135:8888/fu/filedownload?fileID=87513e5d35334178a93a390d87f73fda"><i class="fa fa-angle-double-right"></i>实体标注标签集 </a></li>
		                    <li><a href="http://180.76.145.135:8888/fu/filedownload?fileID=3e64890866424479b9fa5051e4964750"><i class="fa fa-angle-double-right"></i>关系标注标签集 </a></li>     
		                </ul>
		            </li>
                </ul>
				<ul id="user">
					<li class="active"><a href="register"><i class="fa fa-user-plus"></i>注册 </a></li>
					<li><a href="login"><i class="fa fa-arrow-right"></i>登录 </a></li>
				</ul>
            </div>
        </div>
    </div>

    <div id="main">	
    	<div class="userinfo">
			<ul>
			<form id="register" role="form" method="POST" action="/annotationTool/registerCheck">	
				<li>
					<p>用 户 名</p>
					<input name="user" class="name" type="text" placeholder="输入用户名"/>
				</li>
				<li>
					<p>密 码</p>
					<input name="passwd" class="password" type="password" placeholder="输入密码"/>
				</li>
				<li>
					<p>确 认 密 码</p>
					<input class="passwordConfirm" type="password" placeholder="确认密码 "/>
				</li>
			</form>	
				<li>
					<a id="reg"><input class="registerBtn btn btn-primary btn-lg" style="width: 15%;margin-left:40px;" type="button" value="注册"/></a>
				</li>
			</ul>
		</div>
    </div>
</div>
</body>
<script>
	$("#reg").click(function(){
		if($(".name").val() == "") {
			alert("用户名为空！")
			$(".name").focus();
			return false;
		}
		if(($(".name").val().indexOf(",") >= 0)||($(".name").val().indexOf("]") >= 0)||($(".name").val().indexOf("[") >= 0)) 
		{ 
			alert("用户名包含非法字符！")
			$(".name").focus();
			return false;
		} 
		if(($(".password").val().indexOf(",") >= 0)||($(".password").val().indexOf("]") >= 0)||($(".password").val().indexOf("[") >= 0)) 
		{ 
			alert("密码包含非法字符！")
			$(".password").focus();
			return false;
		} 
		if($(".password").val() == 0) {
			alert("密码为空！")
			$(".password").focus();
			return false;
		}
		else if($(".password").val() != $(".passwordConfirm").val()) {
			alert("密码不一致！")
			$(".passwordConfirm").focus();
			return false;
		}
		
		var users = "<%= users%>";
		var name;
		var flag = 0;
		var result = users.split(",");
		for(var i = 0; i < result.length; i++){	
			if(i == 0){
				name = result[i].replace("[","");
			}
			else if(i ==  result.length-1){
				name = result[i].replace("]","");
				name = name.replace(" ","");
			}
			else {
				name = result[i].replace(" ","");
			}
			if($(".name").val() == name) {
				flag = 1;
			}
		}
		if(flag == 1) {
			alert("用户名已存在！");
			$(".name").focus();
			return false;
		}
		alert("注册成功！");
		$("#register").submit();
	});
</script>
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery("#jquery-accordion-menu").jqueryAccordionMenu();

    });

    $(function () {
    	var flag1 = 0;
        //顶部导航切换
        $("#demo-list li").click(function () {
            $("#demo-list li.active").removeClass("active")
            $(this).addClass("active");
        })  
    })
</script>
<script src="js/jquery-smartMenu.js"></script>
<script type="text/javascript" src="js/biaozhu.js"></script>

</html>
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
			ArrayList<String> passwords = new ArrayList<String>();

			Connection conn = null;
		    //加载数据库驱动类
		    Class.forName("com.mysql.jdbc.Driver").newInstance();
		    //数据库连接URL
		    String url="jdbc:mysql://localhost:3306/kg";
		    //数据库用户名和密码
		    String user="root";
		    String password="****"; 
		    //根据数据库参数取得一个数据库连接值
		    conn =  DriverManager.getConnection(url,user,password);
		   
		    //判断是否登录，如果登录按照用户名查询
		    String sql = "select * from user";		// 查询数据的sql语句
		    Statement st = (Statement) conn.createStatement();	//创建用于执行静态sql语句的Statement对象，st属局部变量
			
		    ResultSet rs = st.executeQuery(sql);	//执行sql查询语句，返回查询数据的结果集
		  //  System.out.println("最后的查询结果为：");
		    while (rs.next()) {	// 判断是否还有下一个数据
		    	users.add(rs.getString("username"));
		    	passwords.add(rs.getString("password"));
		    	
		    	/* System.out.println(rs.getString("username"));
		    	System.out.println(rs.getString("password")); */
		    }
		%>
<div id="content">
    <div id="leftMenu">
        <div id="menuBar">
            <div id="jquery-accordion-menu" class="jquery-accordion-menu black">
                <div class="jquery-accordion-menu-header" id="form">标注工具</div>
                <ul id="demo-list">
                    <li class="homeLoad"><a href="uploadFile"><i class="fa fa-file-text "></i>开始标注 </a></li>
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
					<li><a href="register"><i class="fa fa-user-plus"></i>注册 </a></li>
					<li class="active"><a href="login"><i class="fa fa-arrow-right"></i>登录 </a></li>
				</ul>
            </div>
        </div>
    </div>

    <div id="main">	
		<div class="userinfo">
			<ul>
				<form id="login" role="form" method="POST"
					action="/annotationTool/loginCheck">
					<li>
						<p>用 户 名</p> 
						<input name="user" class="name" type="text" placeholder="输入用户名" />
					</li>
					<li>
						<p>密 码</p> 
						<input name="passwd" class="password" type="password" placeholder="输入密码" />
					</li>
				</form>
				<li><a id="log"><input class="loginBtn btn btn-primary btn-lg" style="width: 15%;margin-left:40px;" type="button" value="登录" /></a></li>
				<!-- <li><a id="log"><button type="button" class="btn btn-primary" style="margin-left:30px;">登陆</button></a></li> -->
			</ul>
		</div>
    </div>
</div>
</body>
<script>
	$("#log").click(function(){
		if($(".name").val() == "") {
			alert("用户名为空！")
			$(".name").focus();
			return false;
		}
		if($(".password").val() == 0) {
			alert("密码为空！")
			$(".password").focus();
			return false;
		}
		
		var users = "<%= users%>";
		var passwords = "<%= passwords%>";
		var x;
		var name;
		var password;
		var flag1 = 0;
		var flag2 = 0;
		var result1 = users.split(",");
		var result2 = passwords.split(",");
		for(var i = 0; i < result1.length; i++){	
			if(i == 0){
				name = result1[i].replace("[","");
			}
			else if(i ==  result1.length-1){
				name = result1[i].replace("]","");
				name = name.replace(" ","");
			}
			else {
				name = result1[i].replace(" ","");
			}
			if($(".name").val() == name) {
				x = i;
				flag1 = 1;
			}
		}
		if(flag1 == 0) {
			alert("用户名不存在！")
			$(".name").focus();
			return false;
		}
		
		if(x == 0){
			password = result2[x].replace("[","");
		}
		else if(x == result2.length - 1){
			password = result2[x].replace("]","");
			password = password.replace(" ","");
		}
		else {
			password = result2[x].replace(" ","");
		}
		if($(".password").val() == password) {
			flag2 = 1;
		}
		if(flag2 == 0) {
			alert("密码错误！")
			$(".password").focus();
			return false;
		}
		if((flag1 == 1)||(flag2 == 1)) {
			alert("登录成功！");
			$("#login").submit();
		}
			
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
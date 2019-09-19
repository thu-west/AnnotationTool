<!DOCTYPE html>
<%@page pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import="com.mysql.jdbc.Driver" %>
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
<div id="content">
    <div id="leftMenu">
        <div id="menuBar">
            <div id="jquery-accordion-menu" class="jquery-accordion-menu black">
                <div class="jquery-accordion-menu-header" id="form">标注工具</div>
                 <ul id="demo-list">
                    <li class="homeLoad"><a href="uploadFile"><i class="fa fa-file-text "></i>开始标注 </a></li>
                    <li class="active anno"><a href="#"><i class="fa fa-tags"></i>实体及关系标注 </a>
                    </li>

                    <li><a href="#"><i class="fa fa-question-circle"></i>说明文档 </a>
                    	<ul class="submenu">
		                    <li><a href="http://180.76.145.135:8888/fu/filedownload?fileID=87513e5d35334178a93a390d87f73fda"><i class="fa fa-angle-double-right"></i>实体标注标签集 </a></li>
		                    <li><a href="http://180.76.145.135:8888/fu/filedownload?fileID=3e64890866424479b9fa5051e4964750"><i class="fa fa-angle-double-right"></i>关系标注标签集 </a></li>     
		                </ul>
		            </li>
                </ul>
				<ul id="user">
					<%if (request.getSession().getAttribute("sessionusername")==null)
        	 		 {
        			%>
						<li><a href="register"><i class="fa fa-user-plus"></i>注册 </a></li>
						<li><a href="login"><i class="fa fa-arrow-right"></i>登录 </a></li>
					<%}
         			 else
         		    { 
						String name = request.getSession().getAttribute("sessionusername").toString();
					%>
						<li><a href="#"><i class="fa fa-user"></i>你好，<%= name%> </a></li>
						<li><a href="logout"><i class="fa fa-arrow-left"></i>注销 </a></li>
			      	   
					<%}%> 
				</ul>
            </div>
        </div>
    </div>
    <div id="oprate">
    	<div class="modelButton">
			<!-- <input id="/d" class="button btn btn-primary" type="button" value="疾病" style="background: red;"></input> -->
			
			<%
				if(request.getSession().getAttribute("sessionusername") != null) {
					String username = request.getSession().getAttribute("sessionusername").toString();

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
				   // String sql = "select * from entity_label where username = \'" + username + "\'";		// 查询数据的sql语句
				    String sql = "select * from entity_label where username = 'admin'";
				  //  String sql = "select * from entity_label where user_id in (select id from user where username = \'"+ username+"\')";		// 查询数据的sql语句
				    Statement st = (Statement) conn.createStatement();	//创建用于执行静态sql语句的Statement对象，st属局部变量
					
				    ResultSet rs = st.executeQuery(sql);	//执行sql查询语句，返回查询数据的结果集
				   // System.out.println("最后的查询结果为：");
				    while (rs.next()) {	// 判断是否还有下一个数据
					   
					// 根据字段名获取相应的值
						String content = rs.getString("content");
				   		String tag = rs.getString("tag");
				  		String color = rs.getString("color"); 
			%>
			  	<input id=<%= tag%> class="button btn btn-primary" type="button" value=<%= content%> style="background: <%= color%>;"></input>
			   
			<%
			    }
		    }	
			%>
			<li class="add addlab" style="list-style: none;"><a href="#" onclick="show_btn();"><i class="fa fa-plus-circle"></i>添加实体标签</a></li>
		</div>
		
		
		<div class="relationButton" >
			<input class="relbutton btn btn-primary" type="button" value="TrIS"></input>
			<input class="relbutton btn btn-primary" type="button" value="TrWS"></input>
			<input class="relbutton btn btn-primary" type="button" value="TrID"></input>
			<input class="relbutton btn btn-primary" type="button" value="TrWD"></input>
			<input class="relbutton btn btn-primary" type="button" value="TeRD"></input>	
			<%
				if(request.getSession().getAttribute("sessionusername") != null) {
				String username = request.getSession().getAttribute("sessionusername").toString();

				Connection conn = null;
				//加载数据库驱动类
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				//数据库连接URL
				String url="jdbc:mysql://localhost:3306/kg";
				//数据库用户名和密码
				String user="root";
				String password="****"; 
				/* String user="root";
				String  password="liu2015"; */
				//根据数据库参数取得一个数据库连接值
				conn =  DriverManager.getConnection(url,user,password);
				//out.print("取得一个数据库连接:\n");
				//out.print(conn.toString());
						   
				//判断是否登录，如果登录按照用户名查询
				String sql = "select * from relation_label where username = \'" + username + "\'";		// 查询数据的sql语句
				Statement st = (Statement) conn.createStatement();	//创建用于执行静态sql语句的Statement对象，st属局部变量
							
				ResultSet rs = st.executeQuery(sql);	//执行sql查询语句，返回查询数据的结果集
			//	System.out.println("最后的查询结果为：");
				while (rs.next()) {	// 判断是否还有下一个数据
							   
					System.out.println(rs.getString("label"));
					// 根据字段名获取相应的值
					String label = rs.getString("label");
			%>
			  	<input class="relbutton btn btn-primary" type="button" value=<%= label%>></input>
			   
			<%
					}
				}	
			%>
			<li class="add addrel" style="list-style: none;"><a href="#" onclick="show_rel();"><i class="fa fa-plus-circle"></i>添加关系标签</a></li>
		</div>
		
    </div>
    <div id="middle">	
		<div id="article" class="article">
		    <p>     在开始标注前，可以先对要标注的文字进行一些修改。</p>
			<form class="form-inline edit"action="/annotationTool/biaozhu" method="post">
			<textarea id="edit-message" class="edit-message" name="edit-message" >${message}</textarea>
			</form>
			<input type="button" id="button-submitedit" class="btn btn-default button-submitedit"  value = "确认" style="margin-top:250px;margin-left:90%;" ></input>
		
	      
  </div>
  </div>
    
    <div id="right">		
	    <div class="search">
			<ul id="myTab" class="nav nav-tabs">
				<li class="active"><a class="base" href="#" data-toggle="tab">百度</a></li>
				<li><a class="base" href="#" data-toggle="tab">百度</a></li>
				<li><a class="base" href="#" data-toggle="tab">百度</a></li>
			</ul>
			<div class="input-group"  style="margin-top: 5%;">
				<input type="text" class="form-control searchCont" placeholder="选择相关知识库" style="width: 70%; margin-right: 5%;">			 
				<button class="btn btn-primary searchConfirm" type="button">搜索</button>
			</div><!-- /input-group -->
		</div>
		<div class="reltable">
			<table border="1" summary="关系列表">
				<tr class="list">
					<th></th>
					<th>实体1</th>
					<th>实体2</th>
					<th>关系</th>
				</tr>
			</table>
		</div>
    </div>
</div>


</body>

<script type="text/javascript">
 
</script>
<script src="js/jquery-smartMenu.js"></script>
<script type="text/javascript" src="js/biaozhu.js"></script>

</html>
<!DOCTYPE html>
<%@page pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
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

    <div id="main">	
    	<div class="help">
    		<p>**********************************************************</p>
	    	<h4 style="font-weight: 600; margin-bottom: 1%;">使用说明</h4>
	    	<p>欢迎使用本系统！</p>
	    	<p>点击开始标注开始标注</p>
	    	<p>可以自定义添加或删除实体标签以及关系标签</p>
	    	<p></p>
	    	<p>**********************************************************</p>
	    	<div class="file">
		    	<form class="form-inline labelForm" role="form" action="/annotationTool/edit" method="post" enctype="multipart/form-data">
					<!-- <div class="form-group">
						<label class="sr-only" for="inputfile">文件输入</label>
						<input class="inputFile" type="file" name="file" id="inputfile">
					</div> -->
					<button type="submit" class="btn btn-default submit">开始标注</button>
				</form>
			</div>
    	</div>
    </div>
</div>
</body>

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
        
        $(".submit").click(function () {
        	if($("#inputfile").val() == "") {
        		alert("未选择文件！");
        		$("#inputfile").focus();
        		return false;
        	}
			$(".labelForm").submit();
        })  
    })
</script>
<script src="js/jquery-smartMenu.js"></script>
<script type="text/javascript" src="js/biaozhu.js"></script>

</html>
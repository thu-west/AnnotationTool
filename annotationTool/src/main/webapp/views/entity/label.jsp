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
	<link rel="stylesheet" href="css/jquery-labelauty.css">
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/tether.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/jquery-accordion-menu.js" ></script>
	<script type="text/javascript" src="js/jquery.form.js"></script>
<style>
input.labelauty + label { font: 12px "Microsoft Yahei";}
</style>
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
				    //out.print("取得一个数据库连接:\n");
				    //out.print(conn.toString());
				   
				    //判断是否登录，如果登录按照用户名查询
				   // String sql = "select * from entity_label where username = \'" + username + "\'";		// 查询数据的sql语句
				    String sql = "select * from entity_label where username = 'admin'";
				  //  String sql = "select * from entity_label where user_id in (select id from user where username = \'"+ username+"\')";		// 查询数据的sql语句
				    Statement st = (Statement) conn.createStatement();	//创建用于执行静态sql语句的Statement对象，st属局部变量
					
				    ResultSet rs = st.executeQuery(sql);	//执行sql查询语句，返回查询数据的结果集
				    System.out.println("最后的查询结果为：");
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
				System.out.println("最后的查询结果为：");
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
		<form class="form-inline labelForm" action="/annotationTool/edit" method="post"></form>
		  <form class="submit-form" id="submit-form" name="submit-form" method="post">
		   <p class="message" id="orignal-message">${message[0]}</p>
		   <%-- <br>
		    <p class="message" id="orignal-message">主诉：${message[1]}</p>
		    <p class="message" id="orignal-message">既往病史：${message[2]}</p>
		    <br> --%>
		    <div class="assist-message">
		    <p>患者年龄：${message[13]}</p>
		    <p>患者性别：${message[14]}</p>
		    <p>主诉：${message[1]}</p>
		    <p>既往史：${message[2]}</p>
		    <p>传染病史：${message[3]}</p>
		    <p>遗传病史：${message[4]}</p>
		    <p>吸烟史：${message[5]}</p>
			<p>饮酒史：${message[6]}</p>
			<p>外伤史：${message[8]}</p>
			<p>手术史：${message[9]}</p>
			<p>超声心电图（床旁）：${message[10]}</p>
			<p>入院诊断：${message[11]}</p>
			<p>出院诊断：${message[12]}</p>
            </div>
	         <div id="middle-option" class="middle-option"> 
			   <div class="info_table">
			         是否急性起病？
			   <br>
			   <ul class="dowebok">
               <li id="box"><input type="radio" name="acute" value="1" data-labelauty="是"></li>                  
               <li id="box"><input type="radio" name="acute" value="2"data-labelauty="否"></li>
			   </ul> 
			   <br>   
			       胸痛程度？
			   <br>
			   <ul class="dowebok">
               <li id="box"><input type="radio" name="pain_level" value="1" data-labelauty="无痛"></li>
               <li id="box"><input type="radio" name="pain_level" value="2" data-labelauty="隐痛（轻度） "></li>             
               <li id="box"><input type="radio" name="pain_level" value="3" data-labelauty="钝痛（中度）"></li>
               <li id="box"><input type="radio" name="pain_level" value="4" data-labelauty="剧痛（重度） "></li>            
			   </ul>
			   <br>
                                            发作频率？
               <br>
               <ul class="dowebok">                           
               <li id="box"><input type="radio" name="pain_frequency" value="1" data-labelauty="无痛"></li>
               <li id="box"><input type="radio" name="pain_frequency" value="2" data-labelauty="偶发 "></li>           
               <li id="box"><input type="radio" name="pain_frequency" value="3" data-labelauty="阵发"></li>
               <li id="box"><input type="radio" name="pain_frequency" value="4" data-labelauty="持续"></li>
               </ul>
               <br>
                                          病史（多选）：
              <br>                         
              <ul class="dowebok">
			  <li id="box"><input type="checkbox" name="history" value="1" data-labelauty="高血压"></li>
              <li id="box"><input type="checkbox" name="history" value="2" data-labelauty="糖尿病 "></li>
              <li id="box"><input type="checkbox" name="history" value="3" data-labelauty="冠心病家族史"></li>
              <li id="box"><input type="checkbox" name="history" value="4" data-labelauty="高脂血症  "></li>
              <li id="box"><input type="checkbox" name="history" value="5" data-labelauty="吸烟 "></li>
              <li id="box"><input type="checkbox" name="history" value="6" data-labelauty="饮酒 "></li>
              <li id="box"><input type="checkbox" name="history" value="7" data-labelauty="马凡综合征/主动脉疾病病史、手术史或家族史 "></li>
              <li id="box"><input type="checkbox" name="history" value="8" data-labelauty="近期（1个月内）手术或骨折、长期制动、严重外伤 "></li>
              <li id="box"><input type="checkbox" name="history" value="9" data-labelauty="PE或静脉血栓栓塞病史 "></li>
              <li id="box"><input type="checkbox" name="history" value="10" data-labelauty="肿瘤  "></li>
              <li id="box"><input type="checkbox" name="history" value="11" data-labelauty="风湿热  "></li>
              <li id="box"><input type="checkbox" name="history" value="12" data-labelauty="病毒感染前驱症状  "></li>
              <li id="box"><input type="checkbox" name="history" value="13" data-labelauty="受凉 淋雨 疲劳 醉酒 病毒感染  "></li>
              <li id="box"><input type="checkbox" name="history" value="14" data-labelauty="肺炎 肺结核 肺梗死  "></li>
	          </ul>
	          <br>
              UCG（多选）：
              <br>  
              <ul>                
              <li id="box"><input type="checkbox" name="UCG" value="1" data-labelauty="节段性室壁运动异常"></li>
              <li id="box"><input type="checkbox" name="UCG" value="2" data-labelauty="室壁瘤"></li>          
              <li id="box"><input type="checkbox" name="UCG" value="3" data-labelauty="乳头肌功能失调"></li>
              <li id="box"><input type="checkbox" name="UCG" value="4"data-labelauty="舒张功能减低"></li>
              <li id="box"><input type="checkbox" name="UCG" value="5"data-labelauty="心包积液"></li>
              <li id="box"><input type="checkbox" name="UCG" value="6"data-labelauty="胸腔积液"></li>
              <li id="box"><input type="checkbox" name="UCG" value="7"data-labelauty="主动脉瓣关闭不全"></li>
              <li id="box"><input type="checkbox" name="UCG" value="8"data-labelauty="右室扩大"></li>
              <li id="box"><input type="checkbox" name="UCG" value="9"data-labelauty="右室壁运动异常"></li>
              <li id="box"><input type="checkbox" name="UCG" value="10"data-labelauty="肺动脉扩张"></li>
              <li id="box"><input type="checkbox" name="UCG" value="11"data-labelauty="肺动脉内血栓"></li>
              <li id="box"><input type="checkbox" name="UCG" value="12"data-labelauty="主动脉（弓）壁分离回声带（真假腔）"></li>
              <li id="box"><input type="checkbox" name="UCG" value="13"data-labelauty="肺动脉高压或肺动脉收缩压≥40mmHg"></li>
              <li id="box"><input type="checkbox" name="UCG" value="14"data-labelauty="主动脉瓣狭窄"></li>             
              <li id="box"><input type="checkbox" name="UCG" value="15"data-labelauty="非对称性室间隔增厚"></li>
              <li id="box"><input type="checkbox" name="UCG" value="16"data-labelauty="全心增大"></li>
              </ul>
              <br>
                  LVEF(请输入数字):
                  <input type="text" name="LVEF">
                  <br>
                  <br>
                                                     疾病名称：

                  <select name="disease_name">
                   <option value ="1">稳定型冠心病</option>
                   <option value ="2">不稳定型冠心病</option>
                   <option value="3">急性心肌梗死</option>
                   <option value="4">二尖瓣狭窄</option>
                   <option value="5">二尖瓣关闭不全</option>
                   <option value="6">主动脉瓣狭窄</option>
                   <option value="7">主动脉瓣关闭不全</option>
                   <option value="8">心肌炎</option>
                   <option value="9">心包炎</option>
                   <option value="10">肥厚性心肌病</option>
                   <option value="11">扩张型心肌病</option>
                   <option value="12">限制型心肌病</option>
                   <option value="13">X综合征</option>
                   <option value="14">主动脉夹层</option>
                   <option value="15">急性肺栓塞</option>
                   <option value="16">肺动脉高压</option>
                   <option value="17">支气管炎</option>
                   <option value="18">肺炎</option>
                   <option value="19">胸膜炎</option>
                   <option value="20">气胸</option>
                   <option value="21">血胸</option>
                   <option value="22">胸膜肿瘤</option>
                   <option value="23">肺癌</option>
                   <option value="24">纵膈炎</option>
                   <option value="25">纵膈气肿</option>
                   <option value="26">纵膈肿瘤</option>
                   <option value="27">食管反流</option>         
                   <option value="28">食管炎</option>
                   <option value="29">食管癌</option>
                   <option value="30">食管裂孔疝</option>
                   <option value="31">消化性溃疡</option>                   
                   <option value="32">胃炎</option>
                   <option value="33">胰腺炎</option>
                   <option value="34">膈下脓肿</option>
                   <option value="35">肝脓肿</option>
                   <option value="36">脾梗死</option>
                   <option value="37">胆结石</option>
                   <option value="38">胆囊炎</option>
                   <option value="39">外伤/劳损</option>
                   <option value="40">胸壁肿瘤</option>
                   <option value="41">多发性骨髓瘤</option>
                   <option value="42">肋间神经炎</option>                   
                   <option value="43">带状疱疹</option>
                   <option value="44">胸壁软组织炎</option>
                   <option value="45">焦虑/抑郁/神经官能症/更年期综合征</option>                   
                 </select> 
                 <br>
                 <br>
                  
                 </div>   
               </div>              
            <div id="middle-button" class="middle-button"> 
            
			  <input id="label_submit" type="button" class="btn btn-default label-submit" value="提交" ></input>
		      <input id="data_next" type="button" class="btn btn-default data-next" value="下一条"></input>  
	        </div>
	        </form> 
	        </div>
      </div>
    
    <div id="right">		
	    <div class="search">
			<ul id="myTab" class="nav nav-tabs">
				<li class="active"><a class="base" href="#" data-toggle="tab">百度</a></li>
				<li><a class="base" href="#" data-toggle="tab">百度</a></li>
				<li><a class="base" href="#" data-toggle="tab">百度</a></li>
			<!-- 	<li><a class="base" href="#" data-toggle="tab">百度</a></li> -->
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

<!-- 模态框（Modal） -->
	<div>
	<div class="modal fade" id="btnModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×
					</button>
					<h4 class="modal-title" id="myModalLabel">添加实体标签</h4>
					<div class="selector">
						<div class="append">
							<label>颜 色</label>
							<input class="selectColor" type="color" />
						</div>
						<div class="append">
							<label>内 容</label>
							<input class="selectText" type="text" placeholder="疾病" />
						</div>
						<div class="append">
							<label>符 号</label>
							<input class="selectId" type="text" placeholder="/d" />
						</div>
					</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary confirmBtn" data-dismiss="modal">确认添加</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	</div>
	</div>
	<div>
	<div class="modal fade" id="relModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×
					</button>
					<h4 class="modal-title" id="myModalLabel">添加关系标签</h4>
				</div>
				<div class="modal-body">
					<div class="append">
						<label>内 容</label>
						<input class="selectTextrel" style="margin-top: 0;" type="text" placeholder="TrIS" />
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary confirmRel" data-dismiss="modal">确认添加</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
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
        
        $(".anno").click(function () {
        	if(flag1 == 0) {
        		//$("#oprate").show(500, show_operate());
	        	$("#middle").animate({width:"50%", left: "30%"}, 500);
	        	$("#leftMenu").animate({width:"10%"}, 500);   
	        	flag1 = 1;
        	}	
        	else {
        		//$("#oprate").hide(500, hide_operate());
	        	$("#middle").animate({width:"65%", left: "15%"}, 500);
	        	$("#leftMenu").animate({width:"15%"}, 500);
	        	flag1 = 0;
        	}
        })
       
    })
    function show_btn() {
         $('#btnModal').modal('show');
    }
    function show_rel() {
         $('#relModal').modal('show');
    }
</script>
<script src="js/jquery-labelauty.js"></script>
<script>
$(function(){
	$(':input').labelauty();
});
</script>
<script src="js/jquery-smartMenu.js"></script>
<script type="text/javascript" src="js/biaozhu.js"></script>

</html>
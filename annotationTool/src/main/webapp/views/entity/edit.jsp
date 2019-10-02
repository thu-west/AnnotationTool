<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import ="annotation.model.EntityLabel" %>
<%@page import ="annotation.model.RelationLabel" %>
<%@page import ="java.util.*" %>
<html lang="en">
<head>
	<%@ include file="/views/_headers.jsp" %>
    <title>实体及关系标注工具</title>
</head>
<body>
<div id="content">
	<%@ include file="/views/_menu.jsp" %>
    <div id="oprate">
    	<div class="modelButton">
			<!-- <input id="/d" class="button btn btn-primary" type="button" value="疾病" style="background: red;"></input> -->
			<%
				List<EntityLabel> entity_labels = (List<EntityLabel>)request.getAttribute("entity_labels");
				if (entity_labels != null) {
					for(EntityLabel label : entity_labels) {
			%>
					<input id=<%= label.getTag() %> class="button btn btn-primary" type="button" value=<%= label.getContent() %> style="background: <%= label.getColor() %>;"></input>
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
				List<RelationLabel> relation_labels = (List<RelationLabel>)request.getAttribute("relation_labels");
				if (relation_labels != null) {
					for(RelationLabel label : relation_labels) {
			%>
					<input class="relbutton btn btn-primary" type="button" value=<%= label.getLabel() %>></input>
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                        <li><a
                                href="http://180.76.145.135:8888/fu/filedownload?fileID=87513e5d35334178a93a390d87f73fda"><i
                                    class="fa fa-angle-double-right"></i>实体标注标签集 </a></li>
                        <li><a
                                href="http://180.76.145.135:8888/fu/filedownload?fileID=3e64890866424479b9fa5051e4964750"><i
                                    class="fa fa-angle-double-right"></i>关系标注标签集 </a></li>
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
                    <li><a href="#"><i class="fa fa-user"></i>你好，<%= name %> </a></li>
                    <li><a href="logout"><i class="fa fa-arrow-left"></i>注销 </a></li>
                <%}%> 
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
	jQuery(document).ready(function () {
		jQuery("#jquery-accordion-menu").jqueryAccordionMenu();
	});

	$(function () {
		//顶部导航切换
		$("#demo-list li").click(function () {
			$("#demo-list li.active").removeClass("active")
			$(this).addClass("active");
		})
	})
</script>
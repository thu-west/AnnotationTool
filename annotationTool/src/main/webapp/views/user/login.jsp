<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<%@ include file="/views/_headers.jsp" %>
	<title>实体及关系标注工具</title>
</head>

<body>
	<div id="content">
		<%@ include file="/views/_menu.jsp" %>

		<div id="main">
			<div class="userinfo">
				<ul>
					<form id="login" role="form" method="POST" action="/annotationTool/loginCheck">
						<li>
							<p>用 户 名</p>
							<input name="user" class="name" type="text" placeholder="输入用户名" />
						</li>
						<li>
							<p>密 码</p>
							<input name="passwd" class="password" type="password" placeholder="输入密码" />
						</li>
					</form>
					<li><a id="log"><input class="loginBtn btn btn-primary btn-lg" style="width: 15%;margin-left:40px;"
								type="button" value="登录" /></a></li>
					<!-- <li><a id="log"><button type="button" class="btn btn-primary" style="margin-left:30px;">登陆</button></a></li> -->
				</ul>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	$('#log').click(function () {
		if ($(".name").val() == "") {
			alert("用户名为空！")
			$(".name").focus();
			return false;
		}
		if ($(".password").val() == 0) {
			alert("密码为空！")
			$(".password").focus();
			return false;
		}
		$('#login').submit();
	});
</script>

</html>

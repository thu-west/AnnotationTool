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
					<form id="register" role="form" method="POST" action="/annotationTool/registerCheck">
						<li>
							<p>用 户 名</p>
							<input name="user" class="name" type="text" placeholder="输入用户名" />
						</li>
						<li>
							<p>密 码</p>
							<input name="passwd" class="password" type="password" placeholder="输入密码" />
						</li>
						<li>
							<p>确 认 密 码</p>
							<input class="passwordConfirm" type="password" placeholder="确认密码 " />
						</li>
					</form>
					<li>
						<a id="reg"><input class="registerBtn btn btn-primary btn-lg"
								style="width: 15%;margin-left:40px;" type="button" value="注册" /></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
<script>
	$("#reg").click(function () {
		if ($(".name").val() == "") {
			alert("用户名为空！")
			$(".name").focus();
			return false;
		}
		if (($(".name").val().indexOf(",") >= 0) || ($(".name").val().indexOf("]") >= 0) || ($(".name").val().indexOf("[") >= 0)) {
			alert("用户名包含非法字符！")
			$(".name").focus();
			return false;
		}
		if (($(".password").val().indexOf(",") >= 0) || ($(".password").val().indexOf("]") >= 0) || ($(".password").val().indexOf("[") >= 0)) {
			alert("密码包含非法字符！")
			$(".password").focus();
			return false;
		}
		if ($(".password").val() == 0) {
			alert("密码为空！")
			$(".password").focus();
			return false;
		}
		else if ($(".password").val() != $(".passwordConfirm").val()) {
			alert("密码不一致！")
			$(".passwordConfirm").focus();
			return false;
		}

		$("#register").submit();
	});
</script>

</html>

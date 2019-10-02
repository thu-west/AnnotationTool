<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<%@ include file="/views/_headers.jsp" %>
	<title>提示</title>
</head>

<body>
	<div id="content">
		<%@ include file="/views/_menu.jsp" %>

		<div id="main">
            <p class="message">${message}</p>
		</div>
	</div>
</body>

</html>

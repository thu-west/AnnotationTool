<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <%@ include file="/views/_headers.jsp" %>
    <title>自动实体识别</title>
</head>

<body>
    <body>
        <div id="content">
            <%@ include file="/views/_menu.jsp" %>

            <div id="main">
                <h3>识别结果：</h3>
                ${result}
            </div>
        </div>
    </body>
</body>

</html>
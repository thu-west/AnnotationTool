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
			<div class="help">
				<p>**********************************************************</p>
				<h4 style="font-weight: 600; margin-bottom: 1%;">使用说明</h4>
				<p>欢迎使用本系统！</p>
				<p>点击开始标注开始标注</p>
				<p>可以自定义添加或删除实体标签以及关系标签</p>
				<p></p>
				<p>**********************************************************</p>
				<div class="file">
					<form class="form-inline labelForm" role="form" action="/annotationTool/edit" method="post"
						enctype="multipart/form-data">
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
	$(function () {
		$(".submit").click(function () {
			if ($("#inputfile").val() == "") {
				alert("未选择文件！");
				$("#inputfile").focus();
				return false;
			}
			$(".labelForm").submit();
		})
	})
</script>

</html>
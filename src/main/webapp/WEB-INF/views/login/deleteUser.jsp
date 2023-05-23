<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴(일반)</title>
</head>
<body>
<c:set var = "user_id" value="${user_id}"/>
	<div id = "container" align="center" >
		${user_id}
		<h1>${user_id}님회원탈퇴</h1>
		<form action="<%=request.getContextPath()%>/deleteOk.go">
			<table>
				<tr>
					<th>
					비번입력
					</th>
				</tr>
				<tr>
					<td>
						<input type="password" name="user_pwd">
					</td>
				</tr>
				<tr>
					<td>
						<input type = "submit" value ="사원삭제"
						onclick="if(confirm('혼또니 삭제?')){location.href='user_deleteOk.go?user_id=${user_id}'}else{return;}"> 
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
</head>
<body>

		<div>
		<form method="post" action="<%=request.getContextPath()%>/id_search.go">
		    <table>
		        <tr>
		            <th>이메일 입력</th>
		            <td><input name="user_email"/></td>
		        </tr>
		        
		    </table>
		</form>
		</div>


</body>
</html>
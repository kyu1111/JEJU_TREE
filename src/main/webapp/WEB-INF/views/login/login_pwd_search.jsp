<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<div>
		<form method="post" action="<%=request.getContextPath()%>/pwd_search.go">
		    <table>
		        <tr>
		            <th>아이디 입력</th>
		            <td><input name="user_id"/></td>
		        </tr>
		        
		        <tr>
		            <th>이메일 입력</th>
		            <td><input name="user_email"/></td>
		        </tr>
		        <tr>
		            
		            <td colspan="2"><input type="submit" value="제출하기"/></td>
		        </tr>
		    </table>
		</form>
		</div>

</body>
</html>
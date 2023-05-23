<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

    <form method="post" action="<%=request.getContextPath() %>/emailChange.go">
        <input type="hidden" value="${id }" name="id">
        <table>
           <tr>
               <th>이메일 인증키 입력</th>
               <td><input name="emailKey" placeholder=""></td>
               <td><input type="submit" value="제출"></td>
           </tr>
        </table>
    </form>

</body>
</html>
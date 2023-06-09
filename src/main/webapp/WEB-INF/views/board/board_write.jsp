<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">

</head>
<body>
    <div align="center">
        <hr width="65%" color="gray">
            <h3>BOARD 테이블 게시판 글쓰기 폼 페이지</h3>
        <hr width="65%" color="gray">
        <c:set var="user" value="${User }"/>
	    <form method="post" action="<%=request.getContextPath()%>/board_write_ok.go">
	        <table border="1" width="350">
	            <tr>
	                <th>작성자</th>
	                <td> <input name="writer" value="${user.user_id }" readonly> </td>
	            </tr>
	            <tr>
	                <th>닉네임</th>
	                <td> <input name="user_Nickname" value="${user.user_nickname}" readonly> </td>
	            </tr>
	            <tr>
	                <th>글 제목</th>
	                <td> <input name="board_Title"> </td>
	            </tr>
	            <tr>
	                <th>글 내용</th>
	                <td> <textarea name="board_Content" rows="7" cols = "30"></textarea> </td>
	            </tr>
	            <tr>
	                <th>글 내용</th>
	                <td> <textarea name="board_Content" rows="7" cols = "30"></textarea> </td>
	            </tr>
	            
	        </table>
	        <br>
	        <input type="submit" value="글쓰기">&nbsp;&nbsp;
	        <input type="reset" value="다시쓰기">
	    </form>
    </div>

</body>
</html>
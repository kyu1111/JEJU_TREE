<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/board/board_write.css">
</head>
<body>
    <div id="container">
      <%@ include file="../include/navbar.jsp" %>
      <div id = "write_title">POST SUBMISSION</div>
      <div class="title-account">게시글을 등록하여 JEJU TREE에서 일정을 공유하세요.</div>       	
    	<div id = "wirte_form_content">
    	 <c:set var="user" value="${User }"/>
		    <form id = "write_form" method="post" action="<%=request.getContextPath()%>/board_write_ok.go">
		        <table id = "write_form_table">
		            <tr>
		                <th><i class="fas fa-user"></i></th>
		                <td> <input name="writer" value="${user.user_id }" readonly> </td>
		            </tr>
		            <tr>
		                <th><i class="fas fa-user-tag"></i></th>
		                <td> <input name="user_Nickname" value="${user.user_nickname}" readonly> </td>
		            </tr>
		            <tr>
		                <th><i class="fas fa-file-alt"></i></th>
		                <td> <input name="board_Title" placeholder="제목을 입력하세요."> </td>
		            </tr>
		            <tr>
		                <th><i class="fas fa-align-left"></i></th>
		                <td> <textarea name="board_Content" rows="7" cols = "30" placeholder="게시글 내용을 입력하세요."></textarea> </td>
		            </tr>
		        </table>
		        <div id = "button_area">
			        <i class="fas fa-paper-plane"></i><input type="submit" value="write">&nbsp;&nbsp;
			        <i class="fas fa-sync"></i><input type="reset" value="reset">
		        </div>
		    </form>
   		</div>
    </div>
</body>
</html>
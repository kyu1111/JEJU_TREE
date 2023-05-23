<%@page import="com.fasterxml.jackson.annotation.JsonInclude.Include"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제주트리 프로필 수정</title>
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/navbar.css">
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mypage/userProfile.css">
 
</head>
<body>
    <c:set var="user" value="${UserInfo}" />
    <!-- 상단바 설정하기  -->
    <%@ include file="../include/navbar.jsp" %> 
    <div class="userProfile">
    <form method="post" id="frm1">
    
    <table>
        <tr>
            <th>사용자 프로필</th>
            <td> <input value="${user.user_image }" name="user_image"  ></td>
        </tr>
        <tr>
             <th>사용자 닉네임</th>
            <td> <input name="user_nickname" value="${user.user_nickname }"  ></td>
        </tr>
        <tr>
            <th>사용자 아이디</th>
            <td> <input value="${user.user_id }" name="user_id" ></td>
        </tr>
        <tr>
            <th>사용자 전화번호</th>
            <td> <input value="${user.user_phone }" name="user_phone" ></td>
        </tr>
        <tr>
            <th>사용자 현재 비밀번호</th>
            <td> <input type="password" name="user_pwd"  placeholder="현재 비밀번호"></td>
        </tr>
        <tr>
            <th>사용자 변경 비밀번호</th>
            <td> <input type="password" name="db_pwd" placeholder="변경 비밀번호"></td>
        </tr>
        <tr>
            <th>사용자 변경 비밀번호 확인</th>
            <td> <input type="password" name="db_pwd2" placeholder="변경 비밀번호 확인" ></td>
        </tr>
        <tr>
            <th>사용자 이메일</th>
            <td> <input type="text" value="${user.user_email }" name="user_email" ></td>
        </tr>
	</table>
	<input type="hidden" value="${user.user_iskakao }" name="user_iskakao"  >
	<input type="hidden" value="${user.user_like_keyword }" name="user_like_keyword"  >
	<input type="hidden" value="${user.mailKey }" name="mailKey"  >
	<input type="hidden" value="${user.mailAuth }" name="mailAuth"  >
	<input type="hidden" value="${user.is_admin }" name="is_admin"  >
	<input type="hidden" value="${user.id }" name="id"  >
	
	 <input type="submit" value="회원수정" onclick='btn_click("update");'>
	<button type="reset" value="다시작성">다시작성</button>
    <input type="submit" value="회원탈퇴" onclick='btn_click("delete");'>
    
     </form>
	</div>
	  <!-- footer 설정하기  -->
    <%@ include file="../include/footer.jsp" %> 
    
    
<script>

    function btn_click(str){                             
        if(str=="update"){                                 
            frm1.action="updateUser.go";      
        } else{      
        	if(confirm('정말로 회원탈퇴 하시겠습니까?')) {
        		 frm1.action="deleteUser.go";
            } else{return;}     
        }
    }
</script>
    
</body>
</html>
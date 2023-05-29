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
        <c:if test="${user.user_iskakao == 1}">
        <tr>
            <th>사용자 이메일</th>
            <td><input readonly value="${user.user_id}" name="user_id" ></td>
            <span>카카오톡 연동  회원 입니다.</span>
        </tr>
        </c:if>
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
         <!--카카오 계정으로 로그인 해서 연동된 계정 정보를 수정하려 하는 경우.  -->
        <c:if test="${user.user_iskakao == 1}">
        <tr>
            <th>사용자 이메일</th>
            <td><input readonly value="${user.user_email }" name="user_email" ></td>
            <span>카카오톡 연동  회원 입니다.</span>
        </tr>
        </c:if>
        <c:if test="${user.user_iskakao == 0}">
        <tr>
            <th>사용자 이메일</th>
            <td><input value="${user.user_email }" name="user_email" ></td>
        </tr>
        <tr>
        </c:if>
        <c:if test="${user.user_iskakao == 1}">
            <th>사용자 이메일</th>
            <td> <input type="text" value="${user.user_email }" name="user_email" ></td>
        </tr>
        </c:if>
	</table>
	<input type="hidden" value="${user.user_iskakao }" name="user_iskakao"  >
	<input type="hidden" value="${user.user_like_keyword }" name="user_like_keyword"  >
	<input type="hidden" value="${user.mailKey }" name="mailKey"  >
	<input type="hidden" value="${user.mailAuth }" name="mailAuth"  >
	<input type="hidden" value="${user.is_admin }" name="is_admin"  >
	<input type="hidden" value="${user.id}" name="id"  >
	 <input type="submit" value="회원수정" onclick='btn_click("update");'>
	<button type="reset" value="다시작성">다시작성</button>
    <c:if test="${empty Kakao_info}">
    <input type="submit" value="회원탈퇴" onclick='btn_click("delete");'>
    </c:if>
     <!--카카오 계정으로 로그인 했으나 user_join이 1인 경우.(정회원 연동 외어있는 상태)  -->
    <c:if test="${!empty Kakao_info}">
    	<input type="button" value="카카오계정 연동 계정 탈퇴및 연결 해제" onclick="if(confirm('정말로 회원탈퇴 하시겠습니까?(연동 회원가입정보도 소멸됩니다.)')) {
                                               location.href='deletekakaoUser.go?user_email=${kakao_id}&access_Token=${kakao_token}'
                                                   } else{return;}" >
     </c:if> 
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
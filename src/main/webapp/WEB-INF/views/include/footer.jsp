<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
 <meta charset="UTF-8">
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js" integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script> -->
</head>
<body>

   <!-- footer section starts -->
	<footer class="footer">
		<div class="box-container">
			<div class="box">
    		    <i class="fa-solid fa-comments" id="kakao"></i>카카오톡
				<h3>contact info</h3>
				<a href="#">aaaaaaaa@naver.com</a>
				<c:if test="${!empty user_id}">
					<a href="/user_delete.go?user_id=${user_id}">회원탈퇴</a>
				</c:if>
			</div>
		</div>
		<br>
 		<div class="credit"> copyright @ 2023 by <span>JejuTree</span></div>
 		<br>
 		<c:if test="${!empty kakao_session and user_join == 0}">
 			 <a id = "kakaojoin" onclick="openjoinPage('<%=request.getContextPath()%>//kakaoUser_join.go?user_email=${kakao_id}')">카카오톡 회원가입</a>
 		</c:if>
	</footer>
	<!-- footer section ends -->
</body>
</html>
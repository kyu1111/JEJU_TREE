<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/kakaoalert.css">
</head>
<body>
	<c:set var="share_id" value="${param.share_id}" />
	<c:set var="user_email" value="${param.user_email}" />
	<div id="container">
		<div class="kakao_id_title">
			<div class="share_id">카카오 인증 완료</div>
			<div class="title-account">제주 여행의 시작 JEJU TREE</div>
		</div>
		<div class="kakao_id_cont">
            <div class="kakao_id_text">
            	<span class="kakao_id_span">
            		일정 정보를 공유하기 위해
            	</span>
            	<br>
            	<span class="kakao_id_span">
            	     sns연동 회원가입이 필요합니다.
            	</span>
            </div>
            <a id="kakaoJoinbtn" onclick="openKakaojoinPage();">sns 연동 회원가입</a>
		</div>
	</div>
	<script type="text/javascript">
		function openKakaojoinPage(a) {
			let share_id = '${share_id}';
			let user_email = '${user_email}';
			console.log(share_id);
			let ask_result = confirm('추가정보를 입력하여 가입하겠습니까?');
			if (ask_result) {
				 window.open("kakaoUser_join.go?user_email=" + user_email + "&share_id=" + share_id, "_blank");
			     window.close(); // 기존 창 닫기
			     window.open("kakaoUser_join.go?user_email=" + user_email + "&share_id=" + share_id, "_self"); // 새로운 창 열기
			}
		}
	</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:set var="share_id" value="${param.share_id}" />
	${share_id}
	<c:set var="user_email" value="${param.user_email}" />
	${user_email }
	<div id="container">
		<div id="content">
			<h1>카카오 인증이 완료 되었습니다.</h1>
			<h3>일정 공유 기능은 sns연동 회원가입이 필요 합니다.</h3>
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
				location.href = "kakaoUser_join.go?user_email=" + user_email + "&share_id=" + share_id;
			}
		}
	</script>
</body>
</html>

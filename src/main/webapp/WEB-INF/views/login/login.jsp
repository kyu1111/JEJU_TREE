<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false"  pageEncoding="UTF-8"%> 
<%
response.setHeader("Cache-Control", "no-store"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
if (request.getProtocol().equals("HTTP/1.1"))
   response.setHeader("Cache-Control", "no-cache");
%>
<html>
<head>

	<title>login</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/login_main.css">	
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/login_main.js"></script>
</head>
<body>
	<div id="container" align = "center">
	<%@ include file="../include/navbar.jsp" %>
			<div id="login_main">
				<div id="login_title">로그인창</div>
				<div id="login_main_wrap">
					<form method="post" action="<%=request.getContextPath() %>/user_login.do">
							<input type="text" id="user_id" name="id" placeholder="아이디">
							<br>
							<input type="password" id="user_pwd" name="pwd" placeholder="비밀번호">
							<br>
						<div id="login_main_btn">
							<input type="submit" id="login_btn" value="LOGIN">
							<br>
							<a href="javascript:openjoinPage('<%=request.getContextPath() %>/user_join.go')">회원가입</a>
						</div>
					</form>
					<div id="user_info_search">
						<a href="javascript:openSearchPage('<%=request.getContextPath() %>/login/login_id_search.jsp')">아이디 찾기</a>
						<a href="javascript:openSearchPage('<%=request.getContextPath() %>/login/login_pwd_search.jsp')">비밀번호 찾기</a>
						<br>
						<!-- 카카오 로그인 -->
						<a class="p-2" href="https://kauth.kakao.com/oauth/authorize?client_id=b1b9f0baef115c1e6588625cf198429b&redirect_uri=http://localhost:8585/model/kakaologin.go&response_type=code">
						<!-- REST_API키 및 REDIRECT_URi는 본인걸로 수정하세요 -->
						<!-- 저는 redirect_uri을 http://localhost:8080/member/kakaoLogin로 했습니다. -->
						<!-- 본인걸로 수정 시 띄어쓰기 절대 하지 마세요. 오류납니다. -->
						<img src="<%=request.getContextPath() %>/resources/icon/kakao_login_medium_narrow.png" style="height:60px">
			      		<!-- 이미지는 카카오 개발자센터에서 제공하는 login 이미지를 사용했습니다. -->
					</div>
				</div>
			</div>
    	</div>
</body>
</html>

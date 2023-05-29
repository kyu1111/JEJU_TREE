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
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/login_main.js"></script> --%>
</head>
<body>
	<div id="container" align = "center">
	<%@ include file="../include/navbar.jsp" %>
		<c:set var="share_id" value = "${share_id}"/>
			<div id="login_main">
				<div id="login_title">로그인창</div>
				<div id="login_main_wrap">
					<c:if test="${empty share_id}">
					<form method="post" action="<%=request.getContextPath() %>/user_login.go">
					</c:if>
					<c:if test="${!empty share_id}">
					  <c:set var="formatted_share_id" value="${share_id.replace(',', '')}" />
					<form method="post" action="<%=request.getContextPath() %>/invited_user_login.go">
					</c:if>
							<input type="hidden" name="share_id" value="${formatted_share_id}">
							<input type="text" id="user_id" name="user_id" placeholder="아이디">
							<br>
							<input type="password" id="user_pwd" name="user_pwd" placeholder="비밀번호">
							<c:if test="${!empty share_id}">
							<input type="hidden" id = "share_id" name="share_id">
							</c:if>
							<br>
						<div id="login_main_btn">
							<input type="submit" id="login_btn" value="LOGIN">
							<br>
							<c:if test="${empty share_id}">
							<!--일반회원가입 -->
							<a href="javascript:openjoinPage('<%=request.getContextPath() %>/user_join.go')">회원가입</a>
							</c:if>
							<c:if test="${!empty share_id}">
							<!--공유페이지에서 유입된 회원.-->
							<a href="javascript:openjoinPage('<%=request.getContextPath() %>/invitedUser_join.go?share_id=${share_id}')">회원가입</a>
							</c:if>
						</div>
					</form>
					<div id="user_info_search">
						<a href="javascript:openSearchPage('<%=request.getContextPath() %>/login/login_id_search.jsp')">아이디 찾기</a>
						<a href="javascript:openSearchPage('<%=request.getContextPath() %>/login/login_pwd_search.jsp')">비밀번호 찾기</a>
						<br>
						<!-- 카카오 로그인 -->
						<c:if test="${empty share_id}">
						<a class="p-2" href="https://kauth.kakao.com/oauth/authorize?client_id=b1b9f0baef115c1e6588625cf198429b&redirect_uri=http://localhost:8585/model/kakaologin.go&response_type=code">
						<img src="<%=request.getContextPath() %>/resources/icon/kakao_login_medium_narrow.png" style="height:60px">
			      		</a>
			      		</c:if>
			      		<!--공유 화면일시 파라미터로 share_id 같이 주기.-->
			      		<c:if test="${!empty share_id}">
			      		지금 공유 전용 로그인임.
			      		<a class="p-2" href="https://kauth.kakao.com/oauth/authorize?client_id=b1b9f0baef115c1e6588625cf198429b&redirect_uri=http://localhost:8585/model/invited_kakaologin.go&state=${share_id}&response_type=code">
						<img src="<%=request.getContextPath() %>/resources/icon/kakao_login_medium_narrow.png" style="height:60px">
			      		</a>
			      		</c:if>
			      		<!--카카오 로그아웃  -->
			      		<a class="p-2" href="https://kauth.kakao.com/oauth/logout?client_id=b1b9f0baef115c1e6588625cf198429b&logout_redirect_uri=http://localhost:8585/model/logout.go">
			      		<img src="<%=request.getContextPath() %>/resources/icon/kakao_logout.png" style="height:60px">
			      		<!-- 이미지는 카카오 개발자센터에서 제공하는 login 이미지를 사용했습니다. -->
					</div>
				</div>
			</div>
    	</div>
</body>
</html>

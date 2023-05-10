<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false"  pageEncoding="UTF-8"%> 
<html>
<head>
	<title>login</title>
</head>
<body>
<div align = "center">
	<form>
		<h1>캐캐오톡로그인테스트</h1>
		<table>
			<tr>
				<th>아이디</th><td><input name = "id"></td>
			</tr>
			<tr>
				<th>비번</th><td><input type = "password" name="pwd"></td>
			</tr>
			<tr>
				<td colspan="2">
				<!-- 카카오 로그인 -->
				<a class="p-2" href="https://kauth.kakao.com/oauth/authorize?client_id=b1b9f0baef115c1e6588625cf198429b&redirect_uri=http://localhost:8585/model/login.go&response_type=code">
				<!-- REST_API키 및 REDIRECT_URi는 본인걸로 수정하세요 -->
				<!-- 저는 redirect_uri을 http://localhost:8080/member/kakaoLogin로 했습니다. -->
				<!-- 본인걸로 수정 시 띄어쓰기 절대 하지 마세요. 오류납니다. -->
				
					<img src="<%=request.getContextPath() %>/resources/icon/kakao_login_medium_narrow.png" style="height:60px">
			      		<!-- 이미지는 카카오 개발자센터에서 제공하는 login 이미지를 사용했습니다. -->
			
				</a>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var = "path" value = "<%=request.getContextPath()%>"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/navbar.css">    
<%-- <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css"> --%>
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>   --%>
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script> --%>
</head>
<body>
    <div class="navbar">
        <a href="<%=request.getContextPath()%>/MainPage.go"><img src="/model/resources/images/title.png"></a>
        <c:set var = "kakao_session" value="${Kakao_info}"/>
        <c:set var = "normal_session" value="${user_id}"/>
           <c:if test="${!empty user_id}">
           <a href="mypage.go"><font size="4">MYPAGE</font></a>
              <a href="normal_logout.go"><font size="4">LOGOUT</font></a>
              
           </c:if>
           <c:if test="${!empty kakao_session}">
           <c:set var="kakaoInfo" value="${sessionScope.Kakao_info}" />
         <c:set var="kakao_id" value="${kakaoInfo['kakao_id']}"/>
         <c:set var="kakao_token" value="${kakaoInfo['kakao_token']}"/>
         <c:set var="kakao_nickname" value="${kakaoInfo['kakao_nickname']}"/>
         <c:set var="user_join" value="${kakaoInfo['user_join']}"/>
           <!--둘중 하나가 세션에 있으면 로그아웃 창으로 변경 
           1.세션명이 user_id 면 일반회원 로그아웃 태그 제공
           2.두번쨰 로그아웃은 둘중하나는 세션이 있는 상태 이지만 세션이 유저아이디가 아닌경우 이기 떄문에 카카오 로그아웃 경로로 제공 -->
              <%-- ${kakao_nickname}님 안녕하세요
              ${user_join} --%>
              <a href="mypage.go"><font size="4">MYPAGE</font></a>
              <a href="logout.go"><font size="4">LOGOUT</font></a>
              <!--카카오 계정과 함께 로그아웃-->
              <a class="p-2" href="https://kauth.kakao.com/oauth/logout?client_id=b1b9f0baef115c1e6588625cf198429b&logout_redirect_uri=http://localhost:8585/model/logout.go">
                     <img src="<%=request.getContextPath() %>/resources/icon/kakao_logout.png" style="height:60px"></a>
           </c:if>
        <c:if test="${empty kakao_session and empty normal_session}">
        <!--어느 계정으로도 로그인 되지 않은 경우  -->
            <a href="login_page.go"><font size="4">LOGIN</font></a>
        </c:if>

    </div>
</body>
</html>
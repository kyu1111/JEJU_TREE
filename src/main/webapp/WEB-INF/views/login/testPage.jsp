<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:set var="KakaoInfo" value="${KakaoInfo }"/>
	<div align = "center">
	<h1>야호홓모혼</h1>
	<h2>성공쓰</h2>
	<c:if test="${!empty KakaoInfo}">
		<c:forEach items="${KakaoInfo}" var="info">
			  ${info.key} = ${info.value}  
		</c:forEach>
	</c:if>
	<h2></h2>
	</div>
</body>
</html>
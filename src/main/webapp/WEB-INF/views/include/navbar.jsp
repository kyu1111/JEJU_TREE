<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/navbar.css">    
</head>
<body>
    <div class="navbar">
    	<%@ include file="sidemenu1.jsp" %>
        <a href="#"> <font size="6">MY</font> <font size="4">JEJU</font> </a>
        <a href="login_page.go"><font size="5">LOGIN</font></a>
    	<%@ include file="sidemenu2.jsp" %>
    </div>
</body>
</html>

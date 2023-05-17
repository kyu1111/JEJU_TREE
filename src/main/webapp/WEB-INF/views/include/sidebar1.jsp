<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>  
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
    <title>사이드바1</title>
</head>
<body>
<!--화면영역-->
 <div id="sidebar1_page">
     <button class="openbtn1" onclick="openMenu(this.className)">
     	☰ 
     </button>  
 </div>
    <!--사이드 메뉴 영역-->
 <div class="sidebar1">
 	<!--닫기 버튼  -->
 	<div class="sidebar1_header">
 		<a class="closebtn1" onclick="closeMenu(this.className)">X</a>
 	</div>
 	<div class = "sidebar1_content">
     	<div class = "search_Keyword">
     		<form id = "sidebar_search_form" method = "post"  action="<%=request.getContextPath() %>/search_insertok.go">
	     		<input class = "search_keyword" name="search_keyword" placeholder="검색어를 입력하세요" value = "">
	     		&nbsp;&nbsp;<input type="submit" value ="검색">
     		</form>
     	</div>
     	<div class = "search_result1">
     		<c:set var="search_list" value="${List}"/>
     		<c:if test="${!empty search_list }">
     			<c:forEach items="${search_list}" var ="dto">
     				${dto.search_keyword}
     			</c:forEach>
     		</c:if>
     	</div>
     	<%-- <div id="sidebar_location">
	      <div class="location" data-lat="33.4588" data-lng="126.9423">
	         <img
	            src="<%=request.getContextPath()%>/resources/images/markerbackground/jeju1.jpg"
	            alt="제주도1">
	         <p>제주도 관광지 1</p>
	      </div>
	      <div class="location" data-lat="33.489011" data-lng="126.498302">
	         <img
	            src="<%=request.getContextPath()%>/resources/images/markerbackground/jeju2.jpg"
	            alt="제주도2">
	         <p>제주도 관광지 2</p>
	      </div>
	      <!-- More locations can be added here -->
  		 </div> --%>
     </div>
 </div>
</body>
</html>
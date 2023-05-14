<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
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
     		<form id = "sidebar_search_form">
	     		<input placeholder="검색어를 입력하세요">&nbsp;&nbsp;<button type="submit" form="sidebar_search_form">검색하기</button>
     		</form>
     	</div>
     	<div class = "search_result1">
     		<h4 class = "search_title">최근검색어</h4>
     		<span class="btn">모두지우기</span>
     	</div>
     </div>
 </div>
</body>
</html>
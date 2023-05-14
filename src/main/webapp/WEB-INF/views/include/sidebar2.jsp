<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>  
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
    <title>사이드바2</title>
</head>
<body>
    <!--화면영역-->
	<div id="sidebar2_page">
    	<button class="openbtn2" onclick="openMenu(this.className)">
    	☰ 
   		</button>  
	</div>
 	<!--사이드 메뉴 영역-->
	<div class="sidebar2">
		<div class="sidebar2_header">
	    	<a class="closebtn2" onclick="closeMenu(this.className)">X</a>
		</div>
		<div class = "sidebar2_content">
          	<div class = "search_Keyword">
          		검색어를 입력하세요
          		<input placeholder="검색어를 입력하세요">
          	</div>
          	<div class = "search_result">
          	</div>
	    </div>
	</div>           
 </body>
 </html>
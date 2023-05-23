<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <!-- 폰트어썸 cdn링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.0/css/all.min.css" integrity="sha512-10/jx2EXwxxWqCLX/hHth/vu2KY3jCF70dCQB8TSgNjbCVAC/8vai53GfMDrO2Emgwccf2pJqxct9ehpzG+MTw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mypage/mypage.css">
</head>
<body>
   <!-- 상단바 설정하기  -->
   <%@ include file="../include/navbar.jsp" %>
   <div id="mypage_wrap">
       <div class="mypage_box1">
			<p class="box_text title">일정 리스트</p> 
			<div class="myplan_box">
				<c:forEach begin="1" end="5" var="i">
					<a href="<%=request.getContextPath() %>/#" class="">
	  					<span class="planList">${i }</span>
	  					<img src="<%=request.getContextPath() %>/resources/images/image1.jpg" class="plan_img" />
	  					<div class="">여행제목</div>
	  					<div class="">메모</div>
	  					<div class="">여행날짜</div>
					</a>
				</c:forEach>
			</div>
		</div>
       <div class="mypage_box2">
			<p class="box_text title">일정을 친구와 공유하세요</p> 
				<h2>
				  <img src="<%=request.getContextPath() %>/resources/images/mypageLogo.png" class="loggo" />
                                           일정을 친구와 공유하세요
               </h2>
               <div class="mypage_buttons">
 					<button onclick="location.href='userprofile.go'">프로필 수정</button><br><br>
 					<button onclick="location.href=''">찜한 장소</button><br><br>
 					<button class="">카카오톡 초대링크</button>&nbsp;&nbsp;&nbsp;&nbsp;
 					<button>pdf 내보내기</button>
 				</div>
		</div>
       
   </div>
   <!-- footer 영역 설정 -->
   <%@ include file="../include/footer.jsp" %>
   

</body>
</html>
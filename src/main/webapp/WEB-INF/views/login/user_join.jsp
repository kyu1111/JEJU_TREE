<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입(일반)</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/navbar.css">   
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/user_join.css">  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/user_join.js"></script> --%>
</head>
<body>
<!-- 상단바 설정하기  -->
<%@include file="../include/navbar.jsp" %> 
<h2>회원가입(일반)</h2>
<c:set var="share_id" value="${share_id}"/>
<div id = "container">
      <div id="join_title">JOIN</div>
      <div class="title-account">제주 여행의 시작 JEJU TREE</div>
      <div id = "user_join_form_area">
      <c:if test="${empty share_id }">
      <form enctype="multipart/form-data" method="post" name="joinForm" id="joinForm" action="<%=request.getContextPath()%>/user_join_ok.go">
      </c:if>
      <c:if test="${!empty share_id }">
      <form enctype="multipart/form-data" method="post" name="joinForm" id="joinForm" action="<%=request.getContextPath()%>/invitedUser_join_ok.go">
      <!--초대 페이지 일시 초대자 아이디 같이 넘겨 주기  -->
      <input type="hidden" name ="share_id" value = "${share_id}">
      </c:if>
         <div class = "form_field">
            <input type="text"  name="user_id" id="user_id" class="id_check" placeholder="아이디">
         </div>
         <div class = "form_field">
            <input type="password" name="user_pwd" id="user_pwd" class="pwd" placeholder="비밀번호" autocomplete="off">
         </div>
         <div class = "form_field">
            <input type="password" name="user_repwd" id="user_repwd" class="repwd" placeholder="비밀번호 확인" autocomplete="off">
         </div>
         <div class = "form_field">
            <input type="text" name="user_name" id="user_name" placeholder="이름">
         </div>
         <div class = "form_field">
            <input type="text"  name="user_nickname" id="user_nickname" class="nick_check" placeholder="닉네임">
         </div>
         <div class = "form_field">
            <input type="file" class="user_image" name="upload" id="user_image" placeholder="프로필 사진을 등록하세요">
         </div>
         <div class = "form_field">
            <input type="text" name="user_phone" id="user_phone" placeholder="연락처">
         </div>
         <div class = "form_field">
            <input type="text" name="user_email" id="user_email" class = "email_check" placeholder="email">
         </div>
         <div class="form_field_agree">
             <div class="check_box_area">
                 <label for="chk_agree">개인정보 처리방침에 동의합니다</label>
                 <input type="checkbox" name="chk_agree" id="chk_agree" required style="margin-bottom: 0;">
             </div>
             <a class="personalInfo" href="personalInfoPage.go"><b>개인정보처리방침</b></a>
         </div>
         <div class = "form_field_submit">
            <input type = "submit" class="join_submit-btn" value = "회원가입">
            <br>
            <br>
            <br>
            <br>	   
         </div>
      </form>
      </div>
   </div>
   
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/additional-methods.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/user_join.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/preventDbClick.js"></script>
</body>
</html>
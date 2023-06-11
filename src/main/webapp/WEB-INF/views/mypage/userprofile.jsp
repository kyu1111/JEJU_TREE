<%@page import="com.fasterxml.jackson.annotation.JsonInclude.Include"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제주트리 프로필 수정</title>
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/navbar.css">
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mypage/userProfile.css">
 
</head>
<body>
    <c:set var="user" value="${UserInfo}" />
    <!-- 상단바 설정하기  -->
    <%@ include file="../include/navbar.jsp" %> 
    <div class="userProfile">
    <form method="post" id="frm1" enctype="multipart/form-data" >
    
    <div>
    	<h3>${user.user_id }님 프로필 수정</h3>
    </div>
    
    <div id="user_container" align = "center">
        <div class="userprofile_div">
        
        <div class="img_div">
             <img id="previewImg"  src="<%=request.getContextPath() %>${user.user_image }" alt="profile" width="200px" height="200px" style="justify-content: center;">
        </div>
        
        <div class="file-div">
        	<input class="file-input" type="file" name="upload" id="upload" value="${user.user_image }" onchange="previewProfileImage(event)">
        	<input type="hidden" name="user_image" value="${user.user_image }">
        </div>
        

        <div>
           	<input name="user_nickname" class="user_nickname" value="${user.user_nickname }"  >
            <p id="name_check" class="name_check"></p>
		</div>
		
		<div class="user_now_pw_div" align="center"> 
            <input class="now_pw" type="password" name="user_pwd"  placeholder="현재 비밀번호"></td>
        </div> 
        
		<div class="user_pw_div" align="center">
            <input type="password" name="db_pwd" class="db_pwd" id="db_pwd" placeholder="변경 비밀번호"  autocomplete="off">
		</div>
		
		<div class="user_pw_div" align="center">
            <input type="password" name="db_pwdCheck" class="db_pwdCheck" placeholder="변경 비밀번호 확인"  autocomplete="off">
            <span id="dp_pwdspan"></span>
		</div>

        <div class="phone_div" align="center">
           <input class="user_phone" value="${user.user_phone }" name="user_phone" ></td>
        </div>
      
        <div class="user_email_div" align="center">
           <input type="text" value="${user.user_email }" class="user_email" name="user_email" >
           <p id="email_check" class="email_check"></p>
        </div>
        
    	</div>
    
			
	<input type="hidden" value="${user.user_iskakao }" name="user_iskakao"  >
	<input type="hidden" value="${user.user_like_keyword }" name="user_like_keyword"  >
	<input type="hidden" value="${user.mailKey }" name="mailKey"  >
	<input type="hidden" value="${user.mailAuth }" name="mailAuth"  >
	<input type="hidden" value="${user.is_admin }" name="is_admin"  >
	<input type="hidden" value="${user.id }" name="id" class="id" >
	
	<div class="edit_input">
	 <input class="edit_input" type="submit" value="회원수정" id="update" onclick='btn_click("update");'><br>
    </div>
    
    </div>
    
    <c:if test="${empty Kakao_info}">
    <input class="out_input" type="submit" value="회원탈퇴" onclick='btn_click("delete");'>
    </c:if>
     <!--카카오 계정으로 로그인 했으나 user_join이 1인 경우.(정회원 연동 외어있는 상태)  -->
    <c:if test="${!empty Kakao_info}">
    	<input class="out_input" type="button" value="카카오계정 연동 계정 탈퇴및 연결 해제" onclick="if(confirm('정말로 회원탈퇴 하시겠습니까?(연동 회원가입정보도 소멸됩니다.)')) {
                                               location.href='deletekakaoUser.go?user_email=${kakao_id}&access_Token=${kakao_token}'
                                                   } else{return;}" >
     </c:if> 
    
     </form>
	</div>
    
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	$(".db_pwdCheck").keyup(function() {
			
			let db_pwd = $(".db_pwd").val();
			let db_pwd2 = $(".db_pwdCheck").val();
			
			console.log($(".db_pwd").val());
			console.log($(".db_pwdCheck").val());
			if(db_pwd != null) {
				if(db_pwd == db_pwd2){
					$("#dp_pwdspan").text("");
					$("#dp_pwdspan").text("일치");
					$("#dp_pwdspan").show();
				}else{
					$("#dp_pwdspan").text("");
					$("#dp_pwdspan").text("불일치");
					$("#dp_pwdspan").show();
				}
				
			}
		});
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/additional-methods.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mypage/userUpdate.js"></script>
<script>
	
	

    function btn_click(str){                             
        if(str=="update"){                                 
            frm1.action="updateUser.go";      
        } else{      
        	if(confirm('정말 탈퇴 하시겠습니까?')) {
        		 frm1.action="deleteUser.go";
            } else{return;}     
        }
    }
    
 // 바꾼 프로필 이미지 보여주기
    function previewProfileImage(event) {
       let input = event.target;
       let reader = new FileReader();
       reader.onload = function() {
          let previewImg =  document.getElementById('previewImg');
          previewImg.src = reader.result;
       };
       reader.readAsDataURL(input.files[0]);
       $('#upload').val(1);
       
    }
</script>

</body>
<!-- footer 설정하기  -->
<div class="edit_footer">
	<%@ include file="../include/footer.jsp" %> 
</div>
</html>
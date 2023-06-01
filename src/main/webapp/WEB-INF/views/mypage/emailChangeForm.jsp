<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<c:set var="user" value="${UserInfo}" />
    <!-- 상단바 설정하기  -->
    <%@ include file="../include/navbar.jsp" %> 
  <div class="userProfile">
  <form method="post" id="frm1" enctype="multipart/form-data">
    <input type="hidden" value="19" name="id">
    <table>
      <tr>
        <td>
            <label>사용자 프로필</label>
             <img src="<%=request.getContextPath() %>${user.user_image }" alt="profile" >
             <input type="file" name="upload" value="${user.user_image }" >
             <input type="hidden" name="user_image" value="${user.user_image }">
         </td>
        </tr>
        <tr>
          <td>
             <label id="user_nickname" for="user_nickname">사용자 닉네임</label>
           <input name="user_nickname" class="user_nickname" value="${user.user_nickname }"  >
            <p id="name_check" class="name_check"></p>
            </td>
        </tr>
        <tr>
        <td>
            <label for="user_id">사용자 아이디</label>
             <input value="${user.user_id }" class="user_id" name="user_id" >
            <p id="id_check" class="id_check"></p>
            </td>
        </tr>
        <tr>
         <td> 
            <label id="user_phone" for="user_phone">사용자 전화번호</label>
           <input value="${user.user_phone }" name="user_phone" ></td>
        </tr>
        <tr>
        <td> 
            <label id="user_pwd" for="user_pwd">사용자 현재 비밀번호</label>
            <input type="password" value="${user.user_pwd }" name="user_pwd"  placeholder="현재 비밀번호"></td>
        </tr>
        <tr>
         <td>
           <label id="db_pwd" for="db_pwd">사용자 변경 비밀번호</label>
            <input type="password" name="db_pwd" class="db_pwd" id="db_pwd" placeholder="변경 비밀번호"  autocomplete="off">
            </td>
        </tr>
        <tr> 
        <td>
            <label id="db_pwdCheck" for="db_pwdCheck">사용자 변경 비밀번호 확인</label>
             <input type="password" name="db_pwdCheck" class="db_pwdCheck" placeholder="변경 비밀번호 확인"  autocomplete="off">
             <span id="dp_pwdspan"></span>
        </td>
        </tr>
        <tr>
         <td>
            <label id="user_email" for="user_email">사용자 이메일</label>
           <input type="text" value="${user.user_email }" class="user_email" name="user_email" >
           <p id="email_check" class="email_check"></p>
        <tr>
            <td>이메일 인증키 입력
            <input name="emailKey" placeholder="">
            </td>
        </tr>
    </table>
    <input type="hidden" value="${user.user_iskakao }" name="user_iskakao"  >
	<input type="hidden" value="${user.user_like_keyword }" name="user_like_keyword"  >
	<input type="hidden" value="${user.mailKey }" name="mailKey"  >
	<input type="hidden" value="${user.mailAuth }" name="mailAuth"  >
	<input type="hidden" value="${user.is_admin }" name="is_admin"  >
	<input type="hidden" value="${user.id }" name="id" class="id" >
	
	 <input type="submit" value="회원수정" id="update" onclick='btn_click("update");'>
	<button type="reset" value="다시작성">다시작성</button>
    <input type="submit" value="회원탈퇴" onclick='btn_click("delete");'/>
</form>
</div>
 <!-- footer 설정하기  -->
    <%@ include file="../include/footer.jsp" %> 

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
            frm1.action="emailChange.go";      
        } else{      
        	if(confirm('정말로 회원탈퇴 하시겠습니까?')) {
        		 frm1.action="deleteUser.go";
            } else{return;}     
        }
    }
</script>
</body>
</html>
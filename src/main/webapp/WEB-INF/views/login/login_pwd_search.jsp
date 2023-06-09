<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JEJU TREE</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/find_pw.css"> 

</head>
<body>
	<div class="find_pw_container" align="center">
		<div class="find_pw_title">
			<div class="search_pw">비밀번호 찾기</div>
			<div class="title-account">제주 여행의 시작 JEJU TREE</div>
		</div>
	
		<div class="find_pw_cont">
			<form method="post" action="<%=request.getContextPath()%>/pwd_search.go">
			    <div>
		        	<div>
		        		<input class="find_pw_id" name="user_id" placeholder="아이디">
		        	</div>
		        	
		            <div>
		            	<input class="find_pw_email" name="user_email" placeholder="이메일">
		            </div>
		            
		            <div class="find_pw_text">
		            	<span class="find_pw_span">
		            		회원가입시 등록하셨던 아이디와 이메일을 입력해주시면
		            	</span>
		            	
		            	<br>
		            	
		            	<span class="find_pw_span">
		            		임시 비밀번호를 이메일로 발급해드립니다.
		            	</span>
		            </div>
		            
		            <div>
		            	<input class="find_pw_submit_bt" type="submit" value ="발급 받기">
		            </div>
		            
		            <div class="find_pw_text">
		            	<span class="find_pw_span">
		            		* 메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.
		            	</span>
		            	<br>
		            	<span class="find_pw_span">
		            		* 스팸 메일함으로 발송될 수 있으니 체크바랍니다.
		            	</span>
		            </div>
			    </div>
			</form>
		</div>
	</div>

</body>
</html>
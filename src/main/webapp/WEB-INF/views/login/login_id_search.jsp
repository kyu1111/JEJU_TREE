<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JEJU TREE</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/find_id.css"> 

</head>
<body>
	<div class="find_id_container" align="center">
		<div class="find_id_title">
			<div class="search_id">아이디 찾기</div>
			<div class="title-account">제주 여행의 시작 JEJU TREE</div>
		</div>
	
		<div class="find_id_cont">
			<form method="post" action="<%=request.getContextPath()%>/id_search.go">
			    <div>
		        	<div>
		        		<input class="find_id_phone" name="user_phone" placeholder="연락처">
		        	</div>
		        	
		            <div>
		            	<input class="find_id_email" name="user_email" placeholder="이메일">
		            </div>
		            
		            <div class="find_id_text">
		            	<span class="find_id_span">
		            		회원가입시 등록하셨던 연락처와 이메일을 입력해주시면
		            	</span>
		            	
		            	<br>
		            	
		            	<span class="find_id_span">
		            		가입한 아이디를 이메일로 발급해드립니다.
		            	</span>
		            </div>
		            
		            <div>
		            	<input class="find_id_submit_bt" type="submit" value ="발급 받기">
		            </div>
		            
		            <div class="find_id_text">
		            	<span class="find_id_span">
		            		* 메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.
		            	</span>
		            	<br>
		            	<span class="find_id_span">
		            		* 스팸 메일함으로 발송될 수 있으니 체크바랍니다.
		            	</span>
		            </div>
			    </div>
			</form>
		</div>
	</div>

</body>
</html>
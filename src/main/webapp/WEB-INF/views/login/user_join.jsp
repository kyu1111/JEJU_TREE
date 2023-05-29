<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입(일반)</title>

</head>
<body>
<h2>회원가입(일반)</h2>
<form method="post" name="joinForm" id="joinForm" action="<%=request.getContextPath()%>/user_join_ok.go" >
	<table>
		<tr>
			<td>
			<label for="id">아이디</label>
			<input type="text" class="id" name="user_id" id="user_id" placeholder="ID">
			<p id="id_check" class="id_check"></p>
			</td>
		</tr>
		<tr>
			<td>
			<label id="user_pwd" for="user_pwd">비밀번호</label>
			<input type="password" name="user_pwd" id="user_pwd" class="pwd" placeholder="비밀번호를 입력해주세요." autocomplete="off">
			</td>
		</tr>
		<tr>
			<td>
			<label id="user_repwd" for="user_repwd">비밀번호 확인</label>
				<input type="password" name="user_repwd" id="user_repwd" class="repwd" placeholder="비밀번호를 확인해주세요." autocomplete="off">
				<span id="repwd_span"></span>
			</td>
		</tr>
		
		<tr>
			<td>
			<label id="user_name" for="user_name">이름</label>
			<input type="text" name="user_name" id="user_name" placeholder="홍길동">
			</td>
		</tr>
		<tr>
			<td>
			<label id="user_nickname" for="user_nickname">닉네임</label>
			<input type="text" class="nickname" name="user_nickname" id="user_nickname" placeholder="홍길동">
			<p id="name_check" class="name_check"></p>
			</td>
		</tr>
		<tr>
			<td>
			<label id="user_phone" for="user_phone">휴대전화</label>
			<input type="text" name="user_phone" id="user_phone" class="phone_number">
			</td>
		</tr>
		<!-- <tr>
			<th>선호 테마</th>
			<td>
				<select name="user_like_keyword" id="user_like_keyword">
					<option value="thema1">thema1</option>
					<option value="thema2">thema2</option>
					<option value="thema3">thema3</option>
					<option value="thema4">thema4</option>
		         </select>
		         <br>
				 <span id="user_like_keyword_check"></span>
			</td>
		</tr> -->
		<tr>
			<td>
			<label id="user_email" for="user_email">이메일</label>
			<input type="text" class="user_email" name="user_email" id="user_email" placeholder="이메일을 입력해주세요.">
			<p id="email_check" class="email_check"></p>
			</td>
		</tr>
		
		<tr>
			<td colspan="1" align = "center">
			<input type = "submit" class="submit-btn" value = "회원가입">
			</td>
		</tr>
	</table>
	</form>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>
	$(".repwd").keyup(function() {
			
			let user_pwd = $(".pwd").val();
			let user_repwd = $(".repwd").val();
			
			console.log($(".pwd").val());
			console.log($(".repwd").val());
			
			if(user_pwd == user_repwd){
				$("#repwd_span").text("");
				$("#repwd_span").text("일치");
				$("#repwd_span").show();
			}else{
				$("#repwd_span").text("");
				$("#repwd_span").text("불일치");
				$("#repwd_span").show();
			}
		});
		
		/**
		 *
		 */

		
	</script>
	
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/additional-methods.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/user_join.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/preventDbClick.js"></script>
	
	
</body>
</html>
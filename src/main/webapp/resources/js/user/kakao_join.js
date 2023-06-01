function idKorCheck(e){
	/* 아이디 input에 한글 입력 불가능  */
	$(e).val( $(e).val().replace( /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '') );
}

function pwdKorCheck(e){
	/* 비밀번호 input에 한글 입력 불가능  */
	$(e).val( $(e).val().replace( /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '') );
}

function pwdInput(){
	/* 비밀번호 유효성 검사 */
	checkPwd($('#user_pwd').val());
	
	let pwd = $('#user_pwd').val();
	let repwd = $('#user_repwd').val();
		
	if(pwd != "" || repwd != "") {
		if(pwd==repwd) { // 일치
			$("#repwdcheck").text("");
			$("#repwdcheck").show();
			$("#repwdcheck").append('<font color="blue">비밀번호가 일치합니다.</font>');
		} else { // 불일치
			$("#repwdcheck").text("");
			$("#repwdcheck").show();
			$("#repwdcheck").append('<font color="red">비밀번호가 일치하지 않습니다.</font>');
			$('#user_repwd').val('').focus();
		}
	}
}


function checkPwd(pwd) {
    if(!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test(pwd)) {            
		$("#pwdcheck").text("");
		$("#pwdcheck").show();
		$("#pwdcheck").append('<font color="red">숫자+영문자+특수문자 조합으로 8자리 이상 사용해야 합니다.</font>');
		$('#user_pwd').val('').focus();
    } else if(/(\w)\1\1\1/.test(pwd)) {
		$("#pwdcheck").text("");
		$("#pwdcheck").show();
		$("#pwdcheck").append('<font color="red">같은 문자를 4번 이상 사용하실 수 없습니다.</font>');
		$('#user_pwd').val('').focus();
	} else {
		$("#pwdcheck").text("");
		$("#pwdcheck").show();
		$("#pwdcheck").append('<font color="blue">사용가능한 비밀번호입니다.</font>');
    }
}

/* 회원가입 버튼 클릭 결과 ----------------------------------------------------------------------------- */
function joinFormCheck() {
	if($('#user_id').val() == "") {
		$("#idcheck").text("");
		$("#idcheck").show();
		$("#idcheck").append('<font color="red">아이디를 입력해주세요.</font>');
		$('#user_id').val('').focus();
		return false;
	} 
	if($('#user_pwd').val() == "") {
		$("#pwdcheck").text("");
		$("#pwdcheck").show();
		$("#pwdcheck").append('<font color="red">비밀번호를 입력해주세요.</font>');
		$('#user_pwd').val('').focus();
		return false;
	} 
	if($('#user_repwd').val() == "") {
		$("#repwdcheck").text("");
		$("#repwdcheck").show();
		$("#repwdcheck").append('<font color="red">비밀번호 확인을 입력해주세요.</font>');
		$('#user_repwd').val('').focus();
		return false;
	} 
	if($('#user_name').val() == "") {
		$("#namecheck").text("");
		$("#namecheck").show();
		$("#namecheck").append('<font color="red">이름을 입력해주세요.</font>');
		$('#user_name').val('').focus();
		return false;
	} 
	if($('#user_phone').val() == "") {
		$("#phonecheck").text("");
		$("#phonecheck").show();
		$("#phonecheck").append('<font color="red">전화번호를 입력해주세요.</font>');
		return false;
	} 
	
	} 
	
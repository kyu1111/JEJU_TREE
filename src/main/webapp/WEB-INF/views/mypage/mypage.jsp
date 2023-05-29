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
               <!--공유버튼 -->
               	  <c:if test="${!empty kakao_id }">
		          <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
		          <a id = "sharePlan" onclick="opensharePage('<%=request.getContextPath()%>/share.go?user_id=${kakao_id}')">
		          	<img src="<%=request.getContextPath() %>/resources/icon/kakaotalk_sharing_btn_small.png">
		          </a>
		          </c:if>
		          <c:if test="${!empty user_id }">
		          <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
		          <a id = "sharePlan" onclick="opensharePage('<%=request.getContextPath()%>/share.go?user_id=${user_id}')">
		          	<img src="<%=request.getContextPath() %>/resources/icon/kakaotalk_sharing_btn_small.png">
		          </a>
		          </c:if>
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
<!--굥유 버튼 ajax스크립트 태그  -->   
<script type="text/javascript">
//공유 버튼을 누를경우 alert 메시지  
//세션이 있는데 카카오 세션일 경우 카카오 회원가입 창으로 으로 전송
//일반 유저의 세션인 경우 공유하기 페이지 윈도우 창으로 띄워주기
function opensharePage(a){
	 	let uid = '${user_id}';	
	 	let kid = '${kakao_id}';
	 	console.log(kid);
	 		console.log(typeof kid,kid);
	 		console.log(typeof uid,uid);
	 		//카카오 세션인 경우 유효성 검사 해당 이메일이 db상의 이메일과 일치하고 해당 유저의 iskakao여부가 1인지 0인지
	 		//컨트롤러 상에서 카카오 연동 회원 일 경우에는 (email & iskako 충족) ->return share.go(결과 값만 출력 해서 구분)
	 		//연동회원이 아닐 경우에는 return 0  --> alert("연동계정으로 전환하시겠습니까?")--> 회원 가입 페이지로 아예 보내 버리기.
	 		if(kid != '' && uid == ''){
	 			$.ajax({
		 			url : "iskakao_check.go",
		 			type : "POST",
		 			data : {
		 				user_email : kid
		 			},
		 		    success:function(result){ 
		 		    	//temporary 테이블에 이메일이 존재하고 연계회원가입이 되어 있는 경우.
		 		    	if(result == 1){ 
		 		        	//공유하는 창으로 보낸다.
		 		        	window.open(a, "친구에게 일정공유", 
		 							"titlebar=0,height=700,width=500,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0"
		 							, "");
		 		        //temporary 테이블에 이메일이 존재하지만 연계회원가입이 되어 있지 않은 경우.   
		 		        }else if(result == -1){
		 		        	let ask_result = confirm('일정 공유 기능은 카카오톡연동회원만 가능합니다. 추가정보를 입력하여 가입하겠습니까?');
		 		        	if(ask_result){
		 		        		var url = "kakaoUser_join.go?user_email=" + kid;
		 		        		window.open(url,"카카오톡 연동 회원 가입", 
		 		   					"titlebar=0,height=700,width=500,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0"
		 		   					, "");
		 		        	}
		 		        }else{
		 		        	alert('로그인이 필요한 기능입니다.');
		 		        }
		 		    },
		 		    error:function(error){
		 		        alert("아이디를 다시 입력해 주세요");
		 		    } 
		 			
		 		}); 
	 		}else if(uid != '' &&  kid == ''){
 		 		console.log(uid);
 		 		window.open(a, "친구에게 일정공유", 
 						"titlebar=0,height=700,width=500,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0"
 						, "");
	 		}else{
		 		alert('로그인이 필요한 기능입니다.');
		 	}
 	} 
</script>
</body>
</html>
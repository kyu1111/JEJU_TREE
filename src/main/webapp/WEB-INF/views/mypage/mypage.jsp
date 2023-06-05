<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <!-- 폰트어썸 cdn링크 -->
 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mypage/mypage.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
</head>
<body>
   <!-- 상단바 설정하기  -->
   <%@ include file="../include/navbar.jsp" %>
   
   <c:set var="user" value="${UserInfo}" />
   <div>
    <div id="mypage_profile">
        <img src="<%=request.getContextPath() %>${user.user_image }" alt="profile" class="profile_img" />
        <input type="hidden" name="user_image" value="${user.user_image }">
        <p>${user.user_nickname }</p>
         <button onclick="openModifyPage()">프로필 수정</button><br><br>
        
   </div>
   <br>
   <br>
   <br>
   <br>
   <div class="container">
			<div id="your-plans" ondrop="drop(event)"
				ondragover="allowDrop(event)">
				<h4>Your Plans</h4>
				<c:set var="plan" value="${List }" />
				<c:if test="${!empty plan }">
					<c:forEach items="${plan }" var="dto">
						<p id="${dto.title}" draggable="true" ondragstart="drag(event)">
							<span class="details" style="display: none;"> Description:
								${dto.description}<br> Location: ${dto.location}<br>
								Marker Latitude: ${dto.markerLat}<br> Marker Longitude:
								${dto.markerLng}<br>
							</span> Plan ID: ${dto.id}<br> User ID: ${dto.user_id}<br>
							Title: ${dto.title}<br> Start Date: ${dto.start_date}<br>
							End Date: ${dto.end_date}<br>
						</p>
						
					</c:forEach>
					
				</c:if>
				
			</div>

			<div id="others-plans" ondrop="drop(event)"
				ondragover="allowDrop(event)">
				<h4>Others' Plans</h4>

				<form method="POST" action="get_others_plans.go">
					<input type="text" name="otherUserId"
						placeholder="Enter user's id..." required> <input
						type="submit" value="Search">
				</form>

				<c:if test="${!empty otherUserList }">
					<c:forEach items="${otherUserList }" var="dto">
						<div class="plan" draggable="true" ondragstart="drag(event)">
							<p id="${dto.title}" draggable="true" ondragstart="drag(event)">
								<span class="details" style="display: none;">
									Description: ${dto.description}<br> Location:
									${dto.location}<br> Marker Latitude: ${dto.markerLat}<br>
									Marker Longitude: ${dto.markerLng}<br>
								</span> Plan ID: ${dto.id}<br> User ID: ${dto.user_id}<br>
								Title: ${dto.title}<br> Start Date: ${dto.start_date}<br>
								End Date: ${dto.end_date}<br>
							</p>
						</div>
					</c:forEach>
				</c:if>
				
				
			</div>
		</div>
<<<<<<< HEAD
        <!-- footer 영역 설정 -->
=======
       <div class="mypage_box2">
			<p class="box_text title">일정을 친구와 공유하세요</p> 
				<h2>
				  <img src="<%=request.getContextPath() %>/resources/images/mypageLogo.png" class="loggo" />
                                           일정을 친구와 공유하세요
               </h2>
               <!--공유버튼 -->
               	  <c:if test="${!empty kakao_session}">
		          <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
		          <a id = "sharePlan" onclick="opensharePage('<%=request.getContextPath()%>/share.go?user_id=${kakao_id}')">
		          	<img src="<%=request.getContextPath() %>/resources/icon/kakaotalk_sharing_btn_small.png">
		          </a>
		          </c:if>
		          <c:if test="${!empty user_id}">
		          <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
		          <a id = "sharePlan" onclick="opensharePage('<%=request.getContextPath()%>/share.go?user_id=${user_id}')">
		          	<img src="<%=request.getContextPath() %>/resources/icon/kakaotalk_sharing_btn_small.png">
		          </a>
		          </c:if>
               <div class="mypage_buttons">
 					<button onclick="openModifyPage()">프로필 수정</button><br><br>
 					<button onclick="location.href=''">찜한 장소</button><br><br>
 					<button class="">카카오톡 초대링크</button>&nbsp;&nbsp;&nbsp;&nbsp;
 					<button>pdf 내보내기</button>
 				</div>
		</div>
       
   </div>
   <!-- footer 영역 설정 -->
>>>>>>> 4506dd762bc7c24984bb10f4af3475b4e8cf98c7
   <%@ include file="../include/footer.jsp" %>
  </div>
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
		 		        	planlistcheck(kid,a);
		 		        //temporary 테이블에 이메일이 존재하지만 연계회원가입이 되어 있지 않은 경우.   
		 		        }else if(result == -1){
		 		        	let ask_result = confirm('일정 공유 기능은 카카오톡연동회원만 가능합니다. 추가정보를 입력하여 가입하겠습니까?');
		 		        	if(ask_result){
		 		        		var url = "kakaoUser_join.go?user_email=" + kid;
		 		        		location.href = url;
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
 		 		planlistcheck(uid,a);
	 		}else{
		 		alert('로그인이 필요한 기능입니다.');
		 	}
 	}
 	
 	function planlistcheck(id,a){
 		$.ajax({
 			url : "planlistCheck.go",
 			type : "POST",
 			data : {
 				user_id : id
 			},
 		    success:function(result){ 
 		    	//해당 아이디로 저장된 일정리스트가 있는 경우.
 		    	if(result == 1){ 
 		        	//수정하는 창으로 보낸다.
 		    		let ask_result = confirm('일정정보를 공유하시겠습니까?');
 		        	if(ask_result){
 		        		window.open(a, "친구에게 일정공유", 
 		 						"titlebar=0,height=700,width=500,top=120,left=400,status=0,scrollbars=0,location=0,resizable=0,menubar=0,toolbar=0"
 		 						, "");
 		        	}
 		        	//해당 아이디로 저장된 일정리스트가 없는 경우.   
 		        }else if(result == -1){
 		        	alert('보유하신 일정 리스트가 없습니다. 일정을 먼저 추가해 주세요.')
 		        }
 		    },
 		    error:function(error){
 		        alert("통신 오류.");
 		    } 
 			
 		}); 
 	}
 	
 		
 	
 	
 	//정회원 회원 여부 구분 후 modify page 이동.
	function openModifyPage(){
		let kid = '${kakao_id}';
		let uid = '${user_id}';	
		
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
	 		        	//수정하는 창으로 보낸다.
	 		        	location.href='userprofile.go';
	 		        //temporary 테이블에 이메일이 존재하지만 연계회원가입이 되어 있지 않은 경우.   
	 		        }else if(result == -1){
	 		        	let ask_result = confirm('회원님은 sns연동 임시 회원입니다. 추가정보를 입력하여 sns연동 회원가입을 하시겠습니까?');
	 		        	if(ask_result){
	 		        		var url = "kakaoUser_join.go?user_email=" + kid;
	 		        		location.href = url;
	 		        	}
	 		        }else{
	 		        	alert('로그인이 필요한 기능입니다.');
	 		        }
	 		    },
	 		    error:function(error){
	 		        alert("아이디를 다시 입력해 주세요");
	 		    } 
	 			
	 		}); 
		}else{
			location.href='userprofile.go';
		}
	}
</script>
<script type="text/javascript">
   function allowDrop(ev) {
   
	   ev.preventDefault();
   
   }

   function drag(ev) {
	   
      ev.dataTransfer.setData("text", ev.target.id);
      
   }

   function drop(ev) {
      ev.preventDefault();
      var data = ev.dataTransfer.getData("text");
      var droppedElement = document.getElementById(data);
      ev.target.appendChild(droppedElement);

      var planId = droppedElement.innerText.split("\n")[0].split(": ")[1];
      var userId;

      if (ev.target.id === "others-plans") {
         userId = $("input[name='otherUserId']").val();

         $.ajax({
            url : 'drag_update.go', // The URL of your server-side script
            method : 'POST',
            data : {
               'planId' : planId,
               'userId' : userId
            },
            success : function(response) {
               alert('공유 성공!!');
            }
         });
      }
      else if (ev.target.id === "your-plans") {
         var userId = '<%=request.getSession().getAttribute("user_id")%>';

			$.ajax({
				url : 'drag_update_back.go', // The URL of your server-side script for this direction
				method : 'POST',
				data : {
					'planId' : planId,
					'userId' : userId
				},
				success : function(response) {
					alert('공유 성공!!');
				}
			});
		}
	}
</script>
</body>
</html>
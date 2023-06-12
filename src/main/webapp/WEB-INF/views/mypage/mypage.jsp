<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
 <!-- 폰트어썸 cdn링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.0/css/all.min.css" integrity="sha512-10/jx2EXwxxWqCLX/hHth/vu2KY3jCF70dCQB8TSgNjbCVAC/8vai53GfMDrO2Emgwccf2pJqxct9ehpzG+MTw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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
        <input type="hidden" name="user_image" value="${user.user_image }"><p>${user.user_nickname }</p>
         <button class="change_profile_btn" onclick="openModifyPage()">프로필 수정</button>
   </div>
   <br>
   <br>
   <br>
   <br>
   <br>
   <div class="container">
   
			<div id="your-plans" ondrop="drop(event)" ondragover="allowDrop(event)">
				<h4>나의 일정</h4>
				  <!--공유버튼 -->
               	  <c:if test="${!empty kakao_id }">
		          <button id = "sharePlan" onclick="opensharePage()">일정공유</button>
		          <a onclick="sendLink();" value="공유하기">카카오톡 공유</a>
		          </c:if>
		          <c:if test="${!empty user_id }">
		          <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
		          <button id = "sharePlan" onclick="opensharePage()">일정공유</button>
		          <a onclick="sendLink();" value="공유하기">카카오톡 공유</a>
		          </c:if>
				<c:set var="plan" value="${List }" />
				<div class="plan_box">
				<c:if test="${!empty plan }">
					<c:forEach items="${plan }" var="dto">
					<div class="plan-shadow">
						<p id="${dto.title}" draggable="true" ondragstart="drag(event)">
							<span class="details" style="display: none;"> Description:
								${dto.description}<br> Location: ${dto.location}<br>
								Marker Latitude: ${dto.markerLat}<br> Marker Longitude:
								${dto.markerLng}<br>
							</span>
							<c:if test="${!empty dto.image }">
								  <img src="${dto.image }" alt="location_img" class="location_img"/><br>
							</c:if>
							<c:if test="${empty dto.image }">
								<img src="<%=request.getContextPath() %>/resources/images/title.png" alt="location_img" class="default_location_img" /><br>
							</c:if>
							<span class="hidden" style="color: #FFF">Plan ID: ${dto.id} User ID: ${dto.user_id}</span>
								 위치: ${dto.addr}<br>장소명: ${dto.title}<br>
								${dto.start_date}&nbsp;&nbsp;&nbsp; ${dto.end_date}
							<button class="deleteButton" data-plan-id="${dto.id}">일정삭제</button>
						</p>
						</div>
					</c:forEach>
				</c:if>
				</div>
			</div>
			<div id="others-plans" ondrop="drop(event)" ondragover="allowDrop(event)">
				<h4>상대방 일정</h4>

				<form method="POST" action="get_others_plans.go">
					<input type="text" name="otherUserId"
						placeholder="Enter user's id..." required> <input
						type="submit" class="search_share" value="Search">
				</form>
				<div class="plan_box">
				<c:if test="${!empty otherUserList }">
					<c:forEach items="${otherUserList }" var="dto">
					<div class="plan-shadow">
						<div class="plan" draggable="true" ondragstart="drag(event)">
							<p id="${dto.title}" draggable="true" ondragstart="drag(event)">
								<span class="details" style="display: none;">
									Description: ${dto.description}<br> Location:
									${dto.location}<br> Marker Latitude: ${dto.markerLat}<br>
									Marker Longitude: ${dto.markerLng}<br>
								</span>
								<c:if test="${!empty dto.image }">
								    <img src="${dto.image }" alt="location_img" /><br>
								</c:if>
								<c:if test="${empty dto.image }">
								    <img src="<%=request.getContextPath() %>/resources/images/title.png" alt="location_img" /><br>
								</c:if>
								Plan ID: ${dto.id}<br> User ID: ${dto.user_id}<br>Address: ${dto.addr}<br>
								Title: ${dto.title}<br> Start Date: ${dto.start_date}<br>
								End Date: ${dto.end_date}<br>
							</p>
						</div>
						</div>
					</c:forEach>
				</c:if>
				</div>
				
			</div>
		</div>
  </div>
   
<!--굥유 버튼 ajax스크립트 태그  -->   
<script type="text/javascript">
//공유 버튼을 누를경우 alert 메시지  
//세션이 있는데 카카오 세션일 경우 카카오 회원가입 창으로 으로 전송
//일반 유저의 세션인 경우 공유하기 페이지 윈도우 창으로 띄워주기
function opensharePage(){
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
                        planlistcheck(kid);
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
              planlistcheck(uid);
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
                	  sendLink();
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
   $(document).ready(function(){
       $(".deleteButton").click(function(e) {
           e.stopPropagation(); 

           var planId = $(this).data('plan-id');
           var userId = '<%=request.getSession().getAttribute("user_id")%>';

           $.ajax({
               url : 'delete_plan.go', 
               method : 'POST',
               data : {
                   'planId' : planId,
                   'userId' : userId
               },
               success : function(response) {
                   alert('삭제 성공!!');
                   location.reload(); 
               }
           });
       });
   });
</script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">
let parameter_id = '${user_id}';
let normal_session = '${normal_session}'
console.log('normal_session');
//기존의 로그인 했던 카카오 유저의 친구목록 찌끄래기를 날려주는 메서드
Kakao.init("ddee3a2c7a119e1824460c4c13d5fd83");
try {
  function sendLink() {
	  /* if(normal_session != ''){
			 Kakao.Auth.logout();
		}  */

		let is_guest = 'y';  
    Kakao.Link.sendDefault({
      objectType: 'feed',
      content: {
        title: 'JejuTree일정에 당신을 초대합니다.',
        description: parameter_id + '님이 일정에 당신을 초대했어요',
        imageUrl: 'https://ifh.cc/g/P8cvPg.png',
        link: {
          webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
        },
      },
      buttons: [
        {
          title: '일정확인하기',
          link: {
            webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
          },
        },
      ],
    });
  }

  window.kakaoDemoCallback && window.kakaoDemoCallback();
} catch (e) {
  window.kakaoDemoException && window.kakaoDemoException(e);
}
</script>
</body>
<div class="mypage_footer">
     <!-- footer 영역 설정 -->
   <%@ include file="../include/footer.jsp" %>
</div>
</html>
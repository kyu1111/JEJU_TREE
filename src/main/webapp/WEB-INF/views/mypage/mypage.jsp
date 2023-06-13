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
          <c:set var = "participantlist" value="${participantlist}"/>
         <button class="change_profile_btn" onclick="openModifyPage()">프로필 수정</button>
         <!--동행자 목록 a태그 옵션 박스 -->
         <c:forEach items="${participantlist}" var="participant">
    		<select onchange="location.href='plan_list.go?id=${participant.user_share_id}'">
        		<option>동행자 목록</option>
        		<option value="plan_list.go?id=${participant.user_share_id}">
           		 ${participant.user_share_id} 님과의 일정 확인
        		</option>
    		</select>
		  </c:forEach>
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
                <a id = "sharePlan" onclick="opensharePage()">카카오톡 일정공유</a>
                </c:if>
                <c:if test="${!empty user_id }">
                <%-- <button id = "sharePlan" onclick="openjoinPage('<%=request.getContextPath()%>/share.go')">일정공유</button> --%>
                <a id = "sharePlan" onclick="opensharePage()">카카오톡 일정공유</a>
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
                        <img src="<%=request.getContextPath() %>/resources/images/mypage_img.jpg" alt="location_img" class="default_location_img" /><br>
                     </c:if>
                     <span class="hidden" style="color: #FFF">Plan ID: ${dto.id} User ID: ${dto.user_id}</span>
                         위치: ${dto.addr}<br>장소명: ${dto.title}<br>
                        ${dto.start_date}&nbsp;&nbsp;&nbsp; ${dto.end_date}
                     <a class="deleteButton" data-plan-id="${dto.id}">×</a>
                  </p>
                  </div>
               </c:forEach>
            </c:if>
            </div>
         </div>
         <div id="others-plans" ondrop="drop(event)" ondragover="allowDrop(event)">
            <h4>상대방 일정</h4>

            <form method="POST" action="get_others_plans.go">
               <input class="search_id" type="text" name="otherUserId"
                  placeholder="상대방 아이디 입력" required> <input
                  type="submit" class="search_share" value="검색">
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
                            <img src="<%=request.getContextPath() %>/resources/images/mypage_img.jpg" alt="location_img" /><br>
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
	let uid = '${user_id}'
	let kid = '${kakao_id}'
</script>   
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/mypage/kakaoshare.js"></script>
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
<script type="text/javascript">
    let uid = '${user_id}';
    let kid = '${kakao_id}';
    kakaomessage.init(uid, kid); // kakaomessage.js에서 사용할 값으로 초기화
</script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/mypage/kakaomessage.js"></script>
</body>
<div class="mypage_footer">
     <!-- footer 영역 설정 -->
   <%@ include file="../include/footer.jsp" %>
</div>
</html>
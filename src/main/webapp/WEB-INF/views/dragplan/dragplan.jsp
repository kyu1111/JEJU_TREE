<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Page for DRAG</title>
<style>
.draggable {
	cursor: move;
}

.container {
	display: flex;
	justify-content: space-between;
}

#your-plans, #others-plans {
	min-height: 50px;
	border: 1px solid #aaa;
	margin-bottom: 10px;
	padding: 10px;
	width: 45%; /* Adjust this value to change the width of the boxes */
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
</head>
<body>
	<%@ include file="../include/navbar.jsp"%>
	<br>
	<br>
	<br>
	<div align="center">
		<hr width="65%" color="red">
		<h3>Page for DRAG</h3>
		<hr width="65%" color="red">

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
	</div>
	<div align="center"><a href="<%=request.getContextPath() %>/plan_list.go?id=${user_id}">상세설정</a></div>
</body>
</html>
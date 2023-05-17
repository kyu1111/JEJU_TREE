<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Planner</title>
<style type="text/css">
#map_div {
   margin-top: 75px;
}
#sform {
	display: inline-block;
	text-align: center;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<script type="text/javascript">
   var map;
   var infoWindow1, infoWindow2;
   function initTmap() {
	      // map 생성
	      // Tmapv2.Map을 이용하여, 지도가 들어갈 div, 넓이, 높이를 설정합니다.
	      map = new Tmapv2.Map("map_div", {
	         center : new Tmapv2.LatLng(33.3617, 126.5292),
	         width : "100%", // 지도의 넓이
	         height : "400px", // 지도의 높이
	         zoom : 10
	      });
	      // 비자림 Marker 객체 생성.
	      var marker2 = new Tmapv2.Marker(
	            {
	               position : new Tmapv2.LatLng(33.49149305, 126.8111273), //Marker의 중심좌표 설정.
	               icon : "http://tmapapi.sktelecom.com/resources/images/common/pin_car.png", //Marker의 아이콘.
	               map : map
	            //Marker가 표시될 Map 설정..
	            });
	      // 비자림 Marker에 클릭이벤트 등록.
	      marker2.addListener("click",function(evt) {
	                     var content = "<form id='markerDataForm' action='<%=request.getContextPath()%>/Planner.go' method='post'>"
	                           + "<input type='hidden' name='title' value='비자림'>"
	                           + "<input type='hidden' name='address' value='제주특별자치도 서귀포시 성산읍 일출로 284-12'>"
	                           + "<div class='m-pop' style='position: static; top: 180px; left : 320px; display: flex; font-size: 14px; box-shadow: 5px 5px 5px #00000040; border-radius: 10px; width : 400px; height:100px; background-color: #FFFFFF; align-items: center; padding: 5px;'>"
	                           + "<div class='img-box' style='width: 110px; height: 90px; border-radius: 10px; background: #f5f5f5 url(resources/images/markerbackground/jeju2.jpg) no-repeat center; background-size: cover;'></div>"
	                           + "<div class='info-box' style='margin-left : 10px'>"
	                           + "<p style='margin-bottom: 7px;'>"
	                           + "<button id='selectBtn' type='submit'>Select</button>" // 이 줄을 수정했습니다. 버튼의 type을 'submit'으로 변경하였습니다.
	                           + "<span class='tit' style=' font-size: 16px; font-weight: bold;'>비자림</span>"
	                           + "<a href='http://tmapapi.sktelecom.com/' target='_blank' class='link' style='color: #3D6DCC; font-size: 13px; margin-left: 10px;'>홈페이지</a></p>"
	                           + "<p>"
	                           + "<span class='new-addr'>제주특별자치도 서귀포시 성산읍 일출로 284-12</span>"
	                           + "</p>"
	                           + "<p>"
	                           + "<span class='old-addr' style='color: #707070;'>(지번) 저동1가 114</span>"
	                           + "</p>"
	                           + "</div>"
	                           + "<a href='javascript:void(0)' onclick='onClose2()' class='btn-close' style='position: absolute; top: 10px; right: 10px; display: block; width: 15px; height: 15px; background: url(resources/images/sample/btn-close-b.svg) no-repeat center;'></a>"
	                           + "</div>" + "</form>";
	                     // Popup 객체 생성.
	                     infoWindow2 = new Tmapv2.InfoWindow({
	                        position : new Tmapv2.LatLng(33.49149305,
	                              126.8111273), //Popup 이 표출될 맵 좌표
	                        content : content, //Popup 표시될 text
	                        type : 2, //Popup의 type 설정.
	                        map : map
	                     //Popup이 표시될 맵 객체
	                     });
	                     $(document).on('click', '#selectBtn', function(e) {
	                        e.preventDefault();
	                        $('#markerDataForm').submit();
	                     });
	                  }); // 제주 비자림 Marker에 클릭이벤트 종료.
	   }
   //닫기 아이콘 클릭시 호출되는 함수.
   function onClose2() {
      infoWindow2.setVisible(false);
   }
</script>
</head>
<body onload="initTmap()">
   <!-- 상단바 설정하기  -->
   <%@ include file="./include/navbar.jsp" %>
   <div id="map_div"></div>
   <br>
   <div id="sform">
    <form action="/savePlan" method="POST">
        <label for="title">Title:</label>
        <input type="text" name="title" id="title" required><br><br>
        
        <label for="description">Description:</label>
        <textarea name="description" id="description" rows="5" cols="30"></textarea><br><br>
        
        <label for="startDate">Start Date:</label>
        <input type="date" name="startDate" id="startDate" required><br><br>
        
        <label for="endDate">End Date:</label>
        <input type="date" name="endDate" id="endDate" required><br><br>
        
        <label for="location">Location:</label>
        <input type="text" name="location" id="location" required><br><br>
        
        <input type="submit" value="Save">
    </form>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>

<style type="text/css">

#container{
  
      display: flex;
    justify-content: center;
    align-items: center;
    height: 50%;
    width: 100%;
    position: relative;
    z-index: 1; /* container2 보다 앞에 표시되도록 설정 */

}

#sidebar {

    width: 25%; /* adjust this value to change the width of the sidebar */
    height: 100%;
    position: fixed;
    overflow: auto;
    z-index: 1; /* add this line to ensure the sidebar appears above the map */

}

#map_div {

    margin-top: 70px;
    margin-right: auto;
    margin-left:auto;
    display: block;

}

#container2{
   
   display: block;
   justify-content: center;
   align-items: center;
   height: 50%;
   width: 100%;
   position: absolute; /* 추가: container2를 절대적인 위치로 설정 */
   bottom: 0; /* 추가: container 하단에 고정 */

}
</style>

<!-- Add jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
  
<script type="text/javascript">
   var map;
   var infoWindow;
   var marker;

   function initTmap() {
      // map 생성 
      map = new Tmapv2.Map("map_div", {
         center : new Tmapv2.LatLng(33.3617, 126.5292),
         width : "1000px", // 지도의 넓이
         height : "400px", // 지도의 높이
         zoom : 10
      });

      // Map click event listener
      map.addListener("click", function(e) {
          var latlng = e.latLng; // 클릭한 위치의 위도, 경도 정보
          console.log(latlng);
          $.ajax({
              url: 'https://apis.data.go.kr/B551011/KorService1/locationBasedList1?MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=10&pageNo=1',
              data: {
                  serviceKey: decodeURIComponent('h25GokrXt4MRvyzdkh5DJNs8HRscb9jBf6OX/Fy3AiiTckC7U+HPtX+hXL7yWVJdYWnq4FrIDyjNbM6XQ5iPwA=='),
                  mapX: latlng._lng,
                  mapY: latlng._lat,
                  radius: 100
              },
              success: function(data) {
                  if (data && data.response && data.response.body && data.response.body.items && data.response.body.items.item.length > 0) {
                      var item = data.response.body.items.item[0]; // 첫 번째 아이템

                      // Add a marker and infoWindow at the click position
                      marker = new Tmapv2.Marker({
                          position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                          map: map
                      });
                      
                      var content = "<form id='markerDataForm' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post'>"
                          + "<input type='hidden' class = 'plan_title' name='title' value='" + item.title + "'>" 
                          + "<input type='hidden' class = 'plan_address' name='address' value='" + item.addr1 + "'>"
                          + "<input type='hidden' class = 'plan_location' name='location'  value='" + item.title + "'>" 
                          + "<input type='hidden' class = 'plan_markerLat' name='markerLat' value='" + latlng._lat + "'>"  // latitude input field
                          + "<input type='hidden' class = 'plan_markerLng' name='markerLng' value='" + latlng._lng + "'>"  // longitude input field
                          + "<div style='padding:10px; width:250px;'>" + item.title + "&nbsp;&nbsp;<button id='selectBtn' type='button'>Select</button>&nbsp;&nbsp;<button id='closeBtn'>Close</button>" +  "</div>"
                          + "<div>" + item.addr1 + "</div>"
                          + "<div><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                          + "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>"  // Start Date input field
                          + "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>"  // End Date input field
                          + "</form>";

                          infoWindow = new Tmapv2.InfoWindow({
                              position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                              content: content,
                              type: 2,
                              map: map
                          });

                      // Close button event
                      $(document).on('click', '#closeBtn', function(e) {
                          e.preventDefault();
                          if(infoWindow) infoWindow.setVisible(false); //팝업창 제거
                          if(marker) marker.setMap(null); // marker 제거
                      });

                      $(document).on('click', '#selectBtn', function(e) {
                          e.preventDefault();
                          validateAndSubmitForm();
                          
                          
                      });
      
                  } else {
                      console.error("Unexpected API response", data);
                  }
              }
          });
      });
   }   
      
   $(document).ready(function() {
        $('.location').click(function() {
            var lat = $(this).data('lat');
            var lng = $(this).data('lng');
      
            // Create a new marker
            marker = new Tmapv2.Marker({
                position: new Tmapv2.LatLng(lat, lng),
                map: map
            });

            // Center the map on the new marker
            map.setCenter(new Tmapv2.LatLng(lat, lng));
   
        });
   
   });
   
   ///////////////////////////////////////////
   function validateAndSubmitForm(){
	   if(PlanListValidCheck()){
		   $('#markerDataForm').submit();
	   }else{
		   alert('항목을 모두 입력하셔야 합니다.');   
	   }
	} 
   function PlanListValidCheck() {
	   
	    if ($('.plan_start_date').val() == '') {
	        return false;
	    }
	    if ($('.plan_end_date').val() == '') {
	    	return false;
	    }
	    return true;
	} 
</script>
</head>
<body onload="initTmap()">
 <c:set var = "normal_session" value="${user_id}"/>
<!-- 상단바 설정하기  -->
<%@ include file="./include/navbar.jsp" %>
<!-- 사이드바 설정하기 -->
<div id = "container">
<!-- 맵 생성 실행 -->
<div id="map_div"></div>
</div>
<br>
<c:if test="${empty kakao_session }">
<div align="center"><a href="<%=request.getContextPath() %>/plan_list.go?id=${user_id}" onclick = "return PlanListValidCheck();">상세설정</a></div>
</c:if>
<c:if test="${!empty kakao_session }">
<div align="center"><a href="<%=request.getContextPath() %>/plan_list.go?id=${kakao_id}" onclick = "return PlanListValidCheck();">상세설정</a></div>
</c:if>
<br>
<br>
<div align="center"><%@ include file="./include/footer.jsp" %></div>
<br>
</body>
</html>
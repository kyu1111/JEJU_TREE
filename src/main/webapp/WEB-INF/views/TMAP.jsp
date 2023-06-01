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
<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src = "https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
  
<script type="text/javascript">

   var map;
   var infoWindow;
   var marker;
   var markerArr = [], labelArr = [];

   function initTmap() {
         // map 생성 
         map = new Tmapv2.Map("map_div", {
            center : new Tmapv2.LatLng(33.3666, 126.5333),
            width : "70%", // 지도의 넓이
            height : "400px", // 지도의 높이
            zoom : 10
            // zoomControl : true,
          // scrollwheel : true
         });
      
         // 2. POI 통합 검색 API 요청 시작하는 부분,
      $("#btn_select").click(function(){
         var searchKeyword = $('#searchKeyword').val();
         var headers = {}; 
         headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
         
         $.ajax({
            method:"GET", // 요청 방식
            headers : headers,
            url:"https://apis.openapi.sk.com/tmap/pois/search/around?version=1&format=json&callback=result", // url 주소
            data:{
               "categories" : searchKeyword,
               "resCoordType" : "EPSG3857",
               "searchType" : "name",
               "searchtypCd" : "A",
               "radius" : 30,
               "reqCoordType" : "WGS84GEO",
               "centerLon" : "126.5333",
               "centerLat" : "33.3666",
               "count" : 50
            },
            success:function(response){
               console.log(response);
               
               var resultpoisData = response.searchPoiInfo.pois.poi;
               
               // 2. 기존 마커, 팝업 제거
               if(markerArr.length > 0){
                  for(var i in markerArr){
                     markerArr[i].setMap(null);
                  }
                  markerArr = [];
               }

               if(labelArr.length > 0){
                  for(var i in labelArr){
                     labelArr[i].setMap(null);
                  }
                  labelArr = [];
               }
               
               var innerHtml = ""; // Search Reulsts 결과값 노출 위한 변수
               var positionBounds = new Tmapv2.LatLngBounds(); //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
               
               // 3. POI 마커 표시
               for(var k in resultpoisData){
                  // POI 마커 정보 저장
                  var noorLat = Number(resultpoisData[k].noorLat);
                  var noorLon = Number(resultpoisData[k].noorLon);
                  var name = resultpoisData[k].name;
                  
                  // POI 정보의 ID
                  let id = resultpoisData[k].id;  // 'var'를 'let'으로 바꿉니다.
                  
                  // 좌표 객체 생성
                  var pointCng = new Tmapv2.Point(noorLon, noorLat);
                  
                  // EPSG3857좌표계를 WGS84GEO좌표계로 변환
                  var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(pointCng);
                  
                  var lat = projectionCng._lat;
                  var lon = projectionCng._lng;
                  
                  // 좌표 설정
                  var markerPosition = new Tmapv2.LatLng(lat, lon);
                  
                  // Marker 설정. 이 코드 부분이 지도에 마커가 생깁니다. 매우 중요함.
                  marker = new Tmapv2.Marker({
                  
                    position : markerPosition,
                     icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
                     //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png",
                     iconSize : new Tmapv2.Size(24, 38),
                     title : name,
                     // 이부분을 주석 처리하면 지도에 마커가 생성되지 않습니다.
                     map : map 
                  });
                  
                    // 클릭 이벤트 핸들러 추가
                  marker.addListener("click", function(){
                     poiDetail(id);  // id는 해당 마커의 POI ID입니다.
                  });
                  
                  // 결과창에 나타날 검색 결과 html
                  innerHtml += "<li><div><img src='http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png' style='vertical-align:middle;'/><span>"+name+"</span>  "
                  +"<button type='button' name='sendBtn' onClick='poiDetail("+id+");'>상세보기</button></div></li>";
                  
                  // 마커들을 담을 배열에 마커 저장
                  markerArr.push(marker);
                  positionBounds.extend(markerPosition);   // LatLngBounds의 객체 확장
                  
               }
               
               $("#searchResult").html(innerHtml);   //searchResult 결과값 노출
               map.panToBounds(positionBounds);   // 확장된 bounds의 중심으로 이동시키기
               map.zoomOut();
               
            },
            error:function(request,status,error){
               console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
         });
      }); // 종료

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
                          + "<input type='hidden' name='title' value='" + item.title + "'>" 
                          + "<input type='hidden' name='address' value='" + item.addr1 + "'>"
                          + "<input type='hidden' name='location' value=" + item.title + ">"
                          + "<input type='hidden' name='markerLat' value='" + latlng._lat + "'>"  // latitude input field
                          + "<input type='hidden' name='markerLng' value='" + latlng._lng + "'>"  // longitude input field
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
   }  // initTmap() 메서드를 종료시키고 다음 메서드로 넘어갑니다.
   
   // 4. POI 상세 정보 API
   function poiDetail(poiId){
   var headers = {}; 
   headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
         
      $.ajax({
         method:"GET",
         headers : headers,
         url:"   https://apis.openapi.sk.com/tmap/pois/"+poiId+"?version=1&resCoordType=EPSG3857&format=json&callback=result",
         async:false,
         success:function(response){
            var detailInfo = response.poiDetailInfo;
            var name = detailInfo.name;
            var address = detailInfo.address;
            
            var noorLat = Number(detailInfo.frontLat);
            var noorLon = Number(detailInfo.frontLon);
            
            var pointCng = new Tmapv2.Point(noorLon, noorLat);
            var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(pointCng);
            
            var lat = projectionCng._lat;
            var lon = projectionCng._lng;
            
            var labelPosition = new Tmapv2.LatLng(lat, lon);
            
            var content = "<form id='markerDataForm' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post'>"
                + "<input type='hidden' name='title' value='" + name + "'>" 
                + "<input type='hidden' name='address' value='" + address + "'>"
                + "<input type='hidden' name='location' value='비자림'>"
                + "<input type='hidden' name='markerLat' value='" + lat + "'>"  // latitude input field
                + "<input type='hidden' name='markerLng' value='" + lon + "'>"  // longitude input field
                + "<div style='padding:10px; width:250px;'>" + name + "&nbsp;&nbsp;<button id='selectBtn' type='button'>Select</button>&nbsp;&nbsp;<button id='closeBtn'>Close</button>" +  "</div>"
                + "<div>" + address + "</div>"
                // + "<div><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                + "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>"  // Start Date input field
                + "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>"  // End Date input field
                + "</form>";
                  
             // 마커를 띄우는게 아니라 해당 위치 마커의 '라벨창'을 띄우는 코드입니다.     
             var labelInfo = new Tmapv2.Label({
               position : labelPosition,
               content : content,
               map:map
            });//popup 생성
            
            labelArr.push(labelInfo); 
            
         },
         error:function(request,status,error){
            console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         }
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
<br>
<br>
<br>
   <div>
      <input type="text" class="text_custom" id="searchKeyword" name="searchKeyword" value="" placeholder = "장소를 키워드로 검색하세요.">   
      <button id="btn_select">적용하기</button>
   </div>
   <div>
      <div style="width: 30%; float:left;">
         <div class="title"><strong>Search</strong> Results</div>
         <div class="rst_wrap">
            <div class="rst mCustomScrollbar">
               <ul id="searchResult" name="searchResult">
                  <li>검색결과</li>
               </ul>
            </div>
         </div>
      </div>
      <div id="map_div" class="map_wrap" style="float:left"></div>
   </div>
<!-- 사이드바 설정하기 -->
<div id = "container">
<!-- 맵 생성 실행 -->
<div id="map_div"></div>
</div>
<br>
<c:if test="${!empty user_id}">
<div align="center"><a href="<%=request.getContextPath() %>/plan_list.go?id=${user_id}&is_guest=n">상세설정</a></div>
</c:if>
<c:if test="${!empty kakao_id}">
<div align="center"><a href="<%=request.getContextPath() %>/plan_list.go?id=${kakao_id}&is_guest=n">상세설정</a></div>
</c:if>
<br>
<br>
<div align="center"><%@ include file="./include/footer.jsp" %></div>
<br>
</body>
</html>
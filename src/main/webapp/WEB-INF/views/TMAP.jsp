<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/tmap/tmap.css">

<!-- Add jQuery library -->
<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src = "https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>

<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/tmap/tmap.css">
  
<!-- 폰트어썸 cdn링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
<script src="https://kit.fontawesome.com/cbcad42a26.js" crossorigin="anonymous"></script>


<script type="text/javascript">

//사이드바에 북마크 목록+해제버튼 생성
$('.openbtn2').click(function(){
	 $.ajax({
        url: "bm_list.go",
        method: "POST",
        dataType : "json",
        contentType : "application/json; charset:UTF-8",
        async: false,
        success: function(data) {
       	 console.log(data);
       	 let list = data.list;
       	 let table = "";
       	 for(let i=0;i<list.length;i++){
       		 let cont = list[i];
       		 table += "<tr>" +
		        		 	"<td>"+cont.location+"</td>" +
		        		 	"<td><input type='button' value='해제' onclick='bookmark_del(\""+cont.location+"\",this)'></td>" +
       		 		"</tr>";
       	 }
       	 
       	 console.log($('#blist_td').find('tr:gt(0)'));
       	 $('#blist_td').find('tr:gt(0)').remove();
       	 $('#blist_td').append(table);
        },
        error : function(request, status, error) {
        	console.log("code:" + request.status + "\n" + "error:" + error + "\n" + "errortext:" + request.responseText );
        }
    });
	 
});


//사용자 ID를 가져오는 함수
function getUserID(userId, title) {
  $.ajax({
    url: "/get_user_id.go", // 사용자 ID를 가져오는 서버 엔드포인트 URL
    method: "POST",
    dataType: "text",
    success: function(response) {
      userId = response; // 수정된 부분: 서버로부터 가져온 사용자 ID 값을 변수에 저장
      toggleBm(itemId, userId, title);
    },
    error: function(xhr, status, error) {
   	 console.log("에러 발생 (상태 코드: " + xhr.status + "): " + xhr.responseText);
    }
  });
}

// 북마크 해제
function bookmark_del(location, self){
	$.ajax({
        url: "bm_delete_ok.go",
        method: "POST",
        data: {
       	 location: location
        },
        dataType : "text",
        async: false,
        success: function(data) {
       	 console.log(data);
       	 
       	 if(data>0){
       		 $(self).parent().parent().remove();
       	 }else{
       		 alert('실패');
       	 }
       	 
        },
        error : function(request, status, error) {
        	console.log("code:" + request.status + "\n" + "error:" + error + "\n" + "errortext:" + request.responseText );
        }
    });
}

// 북마크 클릭 함수
function toggleBm(title) {
 var h = $('#heart');
 let userId = $(".user_id").val();
	console.log(title);
	console.log("아이디", userId);

 $.ajax({
   url: "toggle_like.go",
   method: "get",
   data: { 
   	user_id : userId,
   	location : title 
   },
   dataType: "text",
   success: function(response) {
   	if(response>0) {
	    	
   		 let table = "<tr>" +
		        		 	"<td>"+title+"</td>" +
		        		 	"<td><input type='button' value='해제' onclick='bookmark_del(\""+title+"\",this)'></td>" +
      		 			 "</tr>";

		   $('#blist_td').append(table);
	    }else if(response == -1){
	    	alert('이미 등록된 장소입니다.');
	    }else{
	    	alert('실패');
	    }
   
   },
   error: function(xhr, status, error) {
   	console.log("에러 발생 (상태 코드: " + xhr.status + "): " + xhr.responseText);
   }
 });
}


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
                          + "<div class='heartAddX'><a class='heart' data-item-id='item-1' href='#' onclick=\'toggleBm(\""+item.title+"\")\'><i id='heart' class='fas fa-heart'></i></a>"
                          + "　<button id='selectBtn' type='button'>일정 추가</button><a id='closeBtn'>×</a></div>"
                          + "<input type='hidden' name='location' value=" + item.title + ">"
                          + "<input type='hidden' name='markerLat' value='" + latlng._lat + "'>"  // latitude input field
                          + "<input type='hidden' name='markerLng' value='" + latlng._lng + "'>"  // longitude input field
                          + "<div class='div_title' style='padding:10px; width:250px;'>" + item.title +  "</div>"
                          + "<div class='div_addr1'>" + item.addr1 + "</div>"
                          + "<div class='div_img'><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                          + "<p class='start'>입장 : <input type='date' class = 'plan_start_date' name='start_date'></p>"  // Start Date input field
                          + "<p class='end'>퇴장 : <input type='date' class = 'plan_end_date' name='end_date'></p>"  // End Date input field
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
                + "　<button id='selectBtn' type='button'>일정 추가</button><a id='closeBtn'>X</a></div>"
                + "<input type='hidden' name='location' value='비자림'>"
                + "<input type='hidden' name='markerLat' value='" + lat + "'>"  // latitude input field
                + "<input type='hidden' name='markerLng' value='" + lon + "'>"  // longitude input field
                + "<div style='padding:10px; width:250px;'>" + name + "</div>"
                + "<div>" + address + "</div>"
                // + "<div><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                + "<p>입장 : <input type='date' class = 'plan_start_date' name='start_date'></p>"  // Start Date input field
                + "<p>퇴장 : <input type='date' class = 'plan_end_date' name='end_date'></p>"  // End Date input field
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
   function planList_check(a){
	   let kid = '${kakao_id}';
	   let uid = '${user_id}';
	   let user_id ='';
	   
	   if(kid != ''){
		   user_id = kid;
	   }else if(uid != ''){
		   user_id = uid;
	   }
	   console.log(user_id);
		$.ajax({
 			url : "planlistCheck.go",
 			type : "POST",
 			data : {
 				user_id : user_id
 			},
 		    success:function(result){ 
 		    	//해당 아이디로 저장된 일정리스트가 있는 경우.
 		    	if(result == 1){ 
 		        	//수정하는 창으로 보낸다.
 		    		let ask_result = confirm('일정정보를 수정하시겠습니까?');
 		        	if(ask_result){
 		        		let url = a;
 		        		location.href = url;
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
</script>
</head>
<body onload="initTmap()">
 <c:set var = "normal_session" value="${user_id}"/>
<!-- 상단바 설정하기  -->
<%@ include file="./include/navbar.jsp" %>
<br>
<br>
<br>

   <div class="search_container">
      <div class="search_body" style="width: 30%; float:left;">
      		<div class="search_title">
		      <input class="search_input" type="text" class="text_custom" id="searchKeyword" name="searchKeyword" value="" placeholder = "장소 키워드 입력 (예시: 카페)">  
		      &nbsp;&nbsp;&nbsp;<button class="search_bt" id="btn_select">검색</button>
		    </div>
         <div class="rst_wrap">
            <div class="rst_mCustomScrollbar" style="height: 346.5px; overflow: auto;">
               <ul id="searchResult" name="searchResult" style="padding-left: 20px;">
                  <li class="search_list">검색결과</li>
               </ul>
            </div>
         </div>
      </div>
   </div>

<div id="map_div" class="map_wrap" style="float:left"></div>

   
<!-- 사이드바 설정하기 -->
<div id = "container">
<%@ include file="./include/sidebar2.jsp" %>
<c:if test="${!empty user_id}">
<div class="planList_btn_div" align="center"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath()%>/plan_list.go?id=${user_id}')"><b>일정 관리</b></a></div>
</c:if>
<c:if test="${!empty kakao_id}">
<div class="planList_btn_div"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath() %>/plan_list.go?id=${kakao_id}')"><b>일정 관리</b></a></div>
</c:if>
<!-- 맵 생성 실행 -->
<div id="map_div"></div>
</div>

<br>
<br>
<div class="tmap_footer">
	<%@ include file="./include/footer.jsp" %>
</div>
<br>
</body>
</html>
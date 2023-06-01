<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="Generator" content="EditPlus®">
<meta name="Author" content="">
<meta name="Keywords" content="">
<meta name="Description" content="">
<title>Weekly Plan</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.css" />
<script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.ie11.min.js"></script>
<script src="https://uicdn.toast.com/tui.code-snippet/latest/tui-code-snippet.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.js"></script>
<!-- Latest Version -->

<style type="text/css">
#map_div {
   height: 400px; /* adjust as needed */
   width: 100%; /* adjust as needed */
}
</style>

<!-- 폰트어썸 cdn링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.0/css/all.min.css" integrity="sha512-10/jx2EXwxxWqCLX/hHth/vu2KY3jCF70dCQB8TSgNjbCVAC/8vai53GfMDrO2Emgwccf2pJqxct9ehpzG+MTw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- <link rel="stylesheet" type="text/css" href="https://uicdn.toast.com/tui-calendar/latest/tui-calendar.css" /> -->
</head>
<body>
   <c:set var="is_guest" value="${is_guest}" />
   <c:set var="user_id" value="${share_id}"/>
   <%-- ${is_guest} --%>
   <c:if test="${empty is_guest}">
   		<p>본인이 작성한 일정입니다.</p>
   </c:if>
   <!--  지도가 나타나는 부분. -->
   <div id="map_div"></div>
   
   <nav class="navbar">
   
   <p id="result"></p>
      <select id="selectLevel">
         <option value="0" selected="selected">교통최적+추천</option>
         <option value="1" >교통최적+무료우선</option>
         <option value="2" >교통최적+최소시간</option>
         <option value="3" >교통최적+초보</option>
      </select>
      <button id="btn_select">적용하기</button>
      <br>
      <button class="button is-rounded today" id="nowBtn">Today</button>
      <button class="button is-rounded prev" id="prevBtn">
         <i class="fa-solid fa-angle-left"></i>
      </button>
      <button class="button is-rounded next" id="nextBtn">
         <i class="fa-solid fa-angle-right"></i>
      </button>
      <button id="saveAsPDF">PDF로 저장</button>
      <button id="savePlan">일정저장(변경사항)</button>
      <span class="navbar--range"></span>
   </nav>
   <main id="container"></main>

   <script type="text/javascript">
var map;

//시작 좌표.
var firstPlanLat = ${List[0].markerLat};
var firstPlanLng = ${List[0].markerLng};
  
// 도착 좌표.
var lastPlanLat = ${List[List.size() - 1].markerLat};
var lastPlanLng =${List[List.size() - 1].markerLng};

 // 중간 좌표.
 let locations = [
     <c:forEach var="item" items="${List}" varStatus="loop">
           <c:if test="${!loop.first && !loop.last}">
                 {
                      lat: "${item.markerLat}",
                      lng: "${item.markerLng}",
                      icon: "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + (${loop.index} + 1) + ".png"
                  }
                  <c:if test="${!loop.last}">,</c:if>
           </c:if>
 </c:forEach>
];
  

// 시작,도착,경유지의 위치를 나타내는 변수.
var marker_s, marekr_e, waypoint;
var resultMarkerArr = [];

//경로그림정보
var drawInfoArr = [];
var resultInfoArr = [];


//1. 지도 띄우기. initTmap() 메서드를 시작합니다.
function initTmap(){
   resultMarkerArr = [];
   
   map = new Tmapv2.Map("map_div", {
      
      center: new Tmapv2.LatLng(33.3617, 126.5292),
      width : "100%",
      height : "400px",
      zoom : 10,
      zoomControl : true,
      scrollwheel : true
      
   });
   
   // 2. 시작, 도착 심볼찍기
   // 시작
   marker_s = new Tmapv2.Marker({
      
      position : new Tmapv2.LatLng(firstPlanLat, firstPlanLng),
      icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
      iconSize : new Tmapv2.Size(24, 38),
      map:map
      
   });
   resultMarkerArr.push(marker_s);
   // 도착
   marker_e = new Tmapv2.Marker({
      position : new Tmapv2.LatLng(lastPlanLat, lastPlanLng),
      icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png",
      iconSize : new Tmapv2.Size(24, 38),
      map:map
   });
   resultMarkerArr.push(marker_e);
   
   // 3. 경유지 심볼 찍기
   for (let location of locations) {
       let marker = new Tmapv2.Marker({
       position : new Tmapv2.LatLng(location.lat, location.lng),
       icon : location.icon,
       iconSize : new Tmapv2.Size(24, 38),
       map:map
     });
     resultMarkerArr.push(marker);
   }
   
   // 4. 경로탐색 API 사용요청
   var routeLayer; 
   $("#btn_select").click(function(){

      var searchOption = $("#selectLevel").val();
      
      var headers = {}; 
      headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
      headers["Content-Type"]="application/json";
      
      // 경유지 정보 설정      
      var viaPoints = [];
        for (let i = 0; i < locations.length; i++) {
            viaPoints.push({
                "viaPointId" : "test" + (i + 1),
                "viaPointName" : "name" + (i + 1),
                "viaX" : locations[i].lng,
                "viaY" : locations[i].lat
            });
        }
        
        
      var param = JSON.stringify({
            "startName" : "출발지",
            "startX" : firstPlanLng.toString(), // 시작 지점의 경도
            "startY" : firstPlanLat.toString(), // 시작 지점의 위도
            "startTime" : "201708081103",
            "endName" : "도착지",
            "endX" : lastPlanLng.toString(), // 도착 지점의 경도
            "endY" : lastPlanLat.toString(), // 도착 지점의 위도
            "viaPoints" : viaPoints,
            "reqCoordType" : "WGS84GEO",
            "resCoordType" : "EPSG3857",
            "searchOption": searchOption
        });
      
      $.ajax({
            method:"POST",
            url:"https://apis.openapi.sk.com/tmap/routes/routeSequential30?version=1&format=json",//
            headers : headers,
            async:false,
            data:param,
            success:function(response){

               var resultData = response.properties;
               var resultFeatures = response.features;
               
               // 결과 출력
               var tDistance = "총 거리 : " + (resultData.totalDistance/1000).toFixed(1) + "km,  ";
               var tTime = "총 시간 : " + (resultData.totalTime/60).toFixed(0) + "분,  ";
               var tFare = "총 요금 : " + resultData.totalFare + "원";
               
               $("#result").text(tDistance+tTime+tFare);
               
               //기존  라인 초기화
               
               if(resultInfoArr.length>0){
                  for(var i in resultInfoArr){
                     resultInfoArr[i].setMap(null);
                  }
                  resultInfoArr=[];
               }
               
               for(var i in resultFeatures) {
                  var geometry = resultFeatures[i].geometry;
                  var properties = resultFeatures[i].properties;
                  var polyline_;
                  
                  drawInfoArr = [];
                  
                  if(geometry.type == "LineString") {
                     for(var j in geometry.coordinates){
                        // 경로들의 결과값(구간)들을 포인트 객체로 변환 
                        var latlng = new Tmapv2.Point(geometry.coordinates[j][0], geometry.coordinates[j][1]);
                        // 포인트 객체를 받아 좌표값으로 변환
                        var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(latlng);
                        // 포인트객체의 정보로 좌표값 변환 객체로 저장
                        var convertChange = new Tmapv2.LatLng(convertPoint._lat, convertPoint._lng);
                        
                        drawInfoArr.push(convertChange);
                     }

                     polyline_ = new Tmapv2.Polyline({
                        path : drawInfoArr,
                        strokeColor : "#FF0000",
                        strokeWeight: 6,
                        map : map
                     });
                     resultInfoArr.push(polyline_);
                     
                  }else{
                     var markerImg = "";
                     var size = "";         //아이콘 크기 설정합니다.
                     
                     if(properties.pointType == "S"){   //출발지 마커
                        markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";   
                        size = new Tmapv2.Size(24, 38);
                     }else if(properties.pointType == "E"){   //도착지 마커
                        markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
                        size = new Tmapv2.Size(24, 38);
                     }else{   //각 포인트 마커
                        markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
                        size = new Tmapv2.Size(8, 8);
                     }
                     
                     // 경로들의 결과값들을 포인트 객체로 변환 
                     var latlon = new Tmapv2.Point(geometry.coordinates[0], geometry.coordinates[1]);
                     // 포인트 객체를 받아 좌표값으로 다시 변환
                     var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(latlon);
                       
                       marker_p = new Tmapv2.Marker({
                          position: new Tmapv2.LatLng(convertPoint._lat, convertPoint._lng),
                          icon : markerImg,
                          iconSize : size,
                          map:map
                       });
                       
                       resultMarkerArr.push(marker_p);
                  }
               }
            },
            error:function(request,status,error){
               console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
         });
   });
} // initTmap() 메서드를 종료시킵니다.
    
function addComma(num) {
    var regexp = /\B(?=(\d{3})+(?!\d))/g;
     return num.toString().replace(regexp, ',');
} 
 
document.getElementById('saveAsPDF').addEventListener('click', function() {
    // Wait for a small delay before generating the PDF to ensure the dynamic content is fully loaded
    setTimeout(function(){
        var element = document.getElementById('container'); // 이 부분을 변경
        var opt = {
            margin:       1,
            filename:     'JejuTreePlanner.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
        };

        // Generate and download the PDF
        html2pdf().from(element).set(opt).save();
    }, 1000); // Adjust this delay as necessary
});

    
$(document).ready(function() {
    initTmap();
});

$(document).ready(function(){
 var calendar = new tui.Calendar(document.getElementById('container'), {
  defaultView: 'week',
    useCreationPopup: false,
     useDetailPopup: false,
 });
 
 calendar.setOptions({
    week: {
       showNowIndicator: false,
       taskView: false,    // can be also ['milestone', 'task']
       eventView: ['time'],
       dayNames: ['월', '화', '수', '목', '금', '토', '일'],
       
     },
   });
 
 console.log(calendar);
 console.log(calendar);
 calendar.render();

//일정 추가 버튼 클릭 시
calendar.on('beforeCreateEvent', function(eventData) {
// 사용자 정의 팝업을 여기서 생성 및 표시
var scheduleData = {
    // 팝업에서 입력받은 일정 정보를 저장할 객체
    // ex) title: '', start: '', end: '', ...
  };

  // 팝업 생성
  var popup = window.open('popup.html', 'schedulePopup', 'width=400, height=400');

  // 팝업 페이지에서 일정 정보를 입력받은 후, 저장 버튼을 클릭하면 호출되는 콜백 함수
  window.receiveScheduleData = function(data) {
    scheduleData = data; // 팝업에서 입력받은 일정 정보를 저장
    popup.close(); // 팝업 닫기

    // 일정 생성
    calendar.createSchedules([scheduleData]);
  };

  // 팝업 페이지에 일정 정보 전달
  popup.postMessage(scheduleData, '*');
// 원하는 HTML, CSS, 이벤트 핸들러 등을 사용하여 팝업을 만들 수 있습니다.
});

//일정 클릭 시
calendar.on('clickEvent', function(eventData) {
// 사용자 정의 팝업을 여기서 생성 및 표시
// 원하는 HTML, CSS, 이벤트 핸들러 등을 사용하여 팝업을 만들 수 있습니다.
});

/* //일정 수정 시
calendar.on('beforeUpdateEvent', function(eventData) {
  // eventData.schedule: 수정할 일정 객체
  // 원하는 동작 수행 후 일정을 수정
  // ex) eventData.schedule.title = '새로운 제목';
  calendar.updateEvent(eventData.schedule.id, eventData.schedule.calendarId, eventData.schedule);
});
 */
//일정 삭제 시
calendar.on('beforeDeleteSchedule', function(eventData) {
// eventData.schedule: 삭제할 일정 객체
// 원하는 동작 수행 후 일정을 삭제
calendar.deleteSchedule(eventData.schedule.id, eventData.schedule.calendarId);
});

 var events = [];
 <c:forEach var="plan" items="${List}">

   var event = {
     user_id: '${plan.user_id}',
	 id: '${plan.id}',
     calendarId: '1',
     title: '${plan.title}',
     category: 'time',
     isVisible: true,
     dueDateClass: '',
     start: '${plan.start_date}T09:00:00+10:00', // 시간 부분을 실제 데이터에 맞게 수정해야 합니다.
     end: '${plan.end_date}T09:00:00+13:00',   // 시간 부분을 실제 데이터에 맞게 수정해야 합니다.
     // isReadOnly: true
   };

   events.push(event);
 </c:forEach>

calendar.createEvents(events);

 /* 이동 및 뷰 타입 버튼 이벤트 핸들러 */
 nextBtn.addEventListener('click', () => {
   calendar.next();                          // 현재 뷰 기준으로 다음 뷰로 이동
 });

 prevBtn.addEventListener('click', () => {
   calendar.prev();                          // 현재 뷰 기준으로 이전 뷰로 이동
 });
 nowBtn.addEventListener('click', () => {
    calendar.today();                         // 현재 뷰 기준으로 이전 뷰로 이동
});

 function extractCalendarEvents(events) {
	  var extractedEvents = [];

	  events.forEach(function (event) {
	    var user_id = event.user_id;
		var title = event.title;
	    var start = event.start;
	    var end = event.end;
	    var id = event.id;

	    extractedEvents.push({ user_id,id, title, start, end });
	  });

	  return extractedEvents;
	}
 
 
 
 calendar.on('beforeUpdateEvent', function ({ event, changes }) {
   const { id, calendarId } = event;
	
  
   calendar.updateEvent(id, calendarId, changes);

   for (let i = 0; i < events.length; i++) {
     if (events[i].id === id) {
       // 변경된 정보로 업데이트
       events[i].title = changes.title || events[i].title;
       events[i].start = changes.start || events[i].start;
       events[i].end = changes.end || events[i].end;
       break;
     }
   }

   events.sort(function (a, b) {
     return new Date(a.start) - new Date(b.start);
   });

   var updatedEvents = extractCalendarEvents(events);

   console.log('이벤트 정보:');
   updatedEvents.forEach(function (event, index) {
     var { user_id,id, title, start, end } = event;
     console.log('user_id:', user_id);
     console.log('Title:', title);
     console.log('Start:', start);
     console.log('End:', end);
     console.log('캘린더 상 순서:', index + 1);
   });
 });
	  // savePlan 버튼 클릭 이벤트 핸들러에 전달
	  document.getElementById('savePlan').addEventListener('click', function() {
		  
		  updatedEvents = extractCalendarEvents(events);
		  
		  isGuestJoinCheck(updatedEvents,event.user_id);
	  });
	});
 
//여러 속성을 바꾸는 경우
calendar.updateEvent('3', '3', {
title: 'Going vacation',
state: 'Free',
start: '2023-05-19T00:00:00',
end: '2023-05-19T23:59:59',
});

//calendar.deleteEvent('1', '1');



 </script>
 <script type="text/javascript">
    function isGuestJoinCheck(updatedEvents,user_id){
        let is_guest = '${is_guest}';
        let share_id = '${share_id}';
        console.log(is_guest);
        if(is_guest != ''){
            alert('로그인이 필요한 서비스입니다.');
            location.href = 'guest_login_page.go?share_id=' + share_id;
        } else {
            $.ajax({
                url: "planListUpdateOk.go",
                type: 'POST',
                traditional:true,
                dataType: 'json',
                data: {data:JSON.stringify(updatedEvents),
                	   user_id:user_id},
                contentType: 'application/x-www-form-urlencoded',
                headers: {
                    "Accept": "application/json"
                },
                success: function(res){
                    if (res.result) {
                        alert("완료되었습니다.");
                    }
                },
                error: function(){
                    alert('요청 실패!');
                }
            });
        }
    }
</script>
</body>
</html>
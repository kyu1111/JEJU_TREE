<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
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
<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src = "https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/weather-icons/2.0.9/css/weather-icons.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
<script type="text/javascript">
//사이드바에 북마크 목록+해제버튼 생성
$('.openbtn1').click(function(){
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
                        "<td><input type='button' value='해제' onclick='bookmark_del(\""+cont.location+"\",this)'></td>" + "</tr>";
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
          alert('이미 등록된 장소입니다');
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
   var popupCount2 = 0;
   // map 생성
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
      // 2. POI 통합 검색 API 요청
     $("#btn_select").click(
        function() {
           var searchKeyword = $('#searchKeyword').val(); // 검색 키워드
           var headers = {}; 
           headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
           $.ajax({
              method : "GET", // 요청 방식
              headers : headers,
              url : "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result", // url 주소
              async : false, // 동기설정
              data : { // 요청 데이터 정보
                 "searchKeyword" : searchKeyword, // 검색 키워드
                 "resCoordType" : "EPSG3857", // 요청 좌표계
                 "reqCoordType" : "WGS84GEO", // 응답 좌표계
                   "searchtypCd" : "A",
                  "radius" : 30,
                  "centerLon" : "126.5333",
                 "centerLat" : "33.3666",
                 "count" : 10 // 가져올 갯수
              },
              success : function(response) {
                 var resultpoisData = response.searchPoiInfo.pois.poi;
                 // 2. 기존 마커, 팝업 제거
                 if (markerArr.length > 0) {
                    for(var i in markerArr) {
                       markerArr[i].setMap(null);
                    }
                    markerArr = [];
                 }
                 if (labelArr.length > 0) {
                    for (var i in labelArr) {
                       labelArr[i].setMap(null);
                    }
                    labelArr = [];
                 }
                 var innerHtml = ""; // Search Reulsts 결과값 노출 위한 변수
                 //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                 var positionBounds = new Tmapv2.LatLngBounds(); 
                 // 3. POI 마커 표시
                 for (var k in resultpoisData) {
                    // POI 마커 정보 저장
                    var noorLat = Number(resultpoisData[k].noorLat);
                    var noorLon = Number(resultpoisData[k].noorLon);
                    var name = resultpoisData[k].name;
                    // POI 정보의 ID
                    let id = resultpoisData[k].id;
                    // 좌표 객체 생성
                    var pointCng = new Tmapv2.Point(
                          noorLon, noorLat);
                    // EPSG3857좌표계를 WGS84GEO좌표계로 변환
                    var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(pointCng);
                    var lat = projectionCng._lat;
                    var lon = projectionCng._lng;
                    // 좌표 설정
                    var markerPosition = new Tmapv2.LatLng(lat, lon);
                    // Marker 설정
                    marker = new Tmapv2.Marker(
                       {
                          position : markerPosition, // 마커가 표시될 좌표
                          //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
                          icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_"
                                + k
                                + ".png", // 아이콘 등록
                          iconSize : new Tmapv2.Size(
                                24, 38), // 아이콘 크기 설정
                          title : name, // 마커 타이틀
                          map : map // 마커가 등록될 지도 객체
                       });
                          marker.addListener("click",function(){
                              poiDetail(id); // id는 해당 마커의 POI ID입니다.
                           });
                    // 결과창에 나타날 검색 결과 html
                    innerHtml += "<li><div><img src='http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png' style='vertical-align:middle;'/><span>"
                          + name
                          + "</span>  <button type='button' name='sendBtn' onClick='poiDetail("
                          + id
                          + ");'>상세보기</button></div></li>";
                    
                    // 마커들을 담을 배열에 마커 저장
                    markerArr.push(marker);
                    positionBounds.extend(markerPosition); // LatLngBounds의 객체 확장
                 }

                 $("#searchResult").html(innerHtml); //searchResult 결과값 노출
                 map.panToBounds(positionBounds); // 확장된 bounds의 중심으로 이동시키기
                 map.zoomOut();
              },
              error : function(request, status, error) {
                 console.log("code:"
                       + request.status + "\n"
                       + "message:"
                       + request.responseText
                       + "\n" + "error:" + error);
              }
           });
        }); // 종료.

      //현재 날씨 정보 
      // 페이지 진입 시 자동으로 제주시 중앙 좌표 날씨 조회 후 출력
      $(document).ready(function () {
         var defaultLat = 33.5008;
         var defaultLon = 126.5469;
         getWeatherInfo(defaultLat, defaultLon);
         getForecastInfo(defaultLat, defaultLon);
      });
      map.addListener("click", function (e) {
         var latlng = e.latLng;
         console.log(latlng);
         var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat=" + latlng._lat + "&lon=" + latlng._lng + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";
         $.ajax({
            url: apiURI,
            dataType: "json",
            type: "GET",
            async: "false",
            success: function (resp) {
               console.log("현재온도 : " + (resp.main.temp - 273.15).toFixed(1));
               console.log("현재습도 : " + resp.main.humidity);
               console.log("날씨 : " + resp.weather[0].main);
               console.log("상세날씨설명 : " + resp.weather[0].description);
               console.log("날씨 이미지 : " + resp.weather[0].icon);
               console.log("바람   : " + resp.wind.speed);
               console.log("나라   : " + resp.sys.country);
               console.log("도시이름  : " + resp.name);
               console.log("구름  : " + (resp.clouds.all) + "%");
               $('#temp').text('현재온도 : ' + (resp.main.temp - 273.15).toFixed(1) + ' °C');
               //$('#humidity').text('현재습도 : ' + resp.main.humidity + '%');
               //$('#windSpeed').text('풍속 : ' + resp.wind.speed + ' m/s');
               var iconClass = 'wi wi-owm-' + resp.weather[0].id;
               $('#icon').attr('class', iconClass);
            }
         });
         var defaultLat = latlng._lat;
         var defaultLon = latlng._lng;
         getForecastInfo(defaultLat, defaultLon);
      });
      function getWeatherInfo(lat, lon) {
         var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";
         $.ajax({
            url: apiURI,
            dataType: "json",
            type: "GET",
            async: false,
            success: function (resp) {
               console.log("현재온도 : " + (resp.main.temp - 273.15).toFixed(1));
               console.log("현재습도 : " + resp.main.humidity);
               console.log("날씨 : " + resp.weather[0].main);
               console.log("상세날씨설명 : " + resp.weather[0].description);
               console.log("날씨 이미지 : " + resp.weather[0].icon);
               console.log("바람 : " + resp.wind.speed);
               console.log("나라 : " + resp.sys.country);
               console.log("도시이름 : " + resp.name);
               console.log("구름 : " + resp.clouds.all + "%");
               $('#temp').text('현재온도 : ' + (resp.main.temp - 273.15).toFixed(1) + ' °C');
               $('#humidity').text('현재습도 : ' + resp.main.humidity + '%');
               $('#windSpeed').text('풍속 : ' + resp.wind.speed + ' m/s');
               var iconClass = 'wi wi-owm-' + resp.weather[0].id;
               $('#icon').attr('class', iconClass);
            },
            error: function () {
               console.log('날씨불러오기 오류');
            }
         });
      }
      function getForecastInfo(lat, lon) {
         var apiURI = "http://api.openweathermap.org/data/2.5/forecast?lat=" + lat + "&lon=" + lon + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";
         $.ajax({
            url: apiURI,
            dataType: "json",
            type: "GET",
            async: false,
            success: function (resp) {
               var forecastList = resp.list;
               for (var i = 0; i < forecastList.length; i += 8) {
                  var forecast = forecastList[i];
                  var forecastTime = new Date(forecast.dt * 1000);
                  console.log("예보 시간 : " + forecastTime);
                  console.log("예상 온도 : " + (forecast.main.temp - 273.15).toFixed(1));
                  console.log("예상 습도 : " + forecast.main.humidity);
                  console.log("예상 날씨 : " + forecast.weather[0].main);
                  console.log("상세날씨설명 : " + forecast.weather[0].description);
                  console.log("날씨 이미지 : " + forecast.weather[0].icon);
                  console.log("예상 풍속 : " + forecast.wind.speed);
                  console.log("예상 구름 : " + forecast.clouds.all + "%");
                  $('#forecast-temp-day' + ((i / 8) + 1)).text('예상 온도 : ' + (forecast.main.temp - 273.15).toFixed(1) + ' °C');
                  //$('#forecast-humidity-day' + ((i / 8) + 1)).text('예상 습도 : ' + forecast.main.humidity + '%');
                  //$('#forecast-windSpeed-day' + ((i / 8) + 1)).text('예상 풍속 : ' + forecast.wind.speed + ' m/s');
                  var iconClass = 'wi wi-owm-' + forecast.weather[0].id;
                  $('#day' + ((i / 8) + 1) + '-icon').attr('class', iconClass);
               }
            },
            error: function () {
               console.log('날씨불러오기 오류');
            }
         });
      }
      // 일기예보에 날짜 반영 기능.
      $(document).ready(function () {
          var currentDate = new Date();
          var optionsCurrent = { month: 'numeric', day: 'numeric' };
          var formattedCurrentDate = currentDate.toLocaleDateString('ko-KR', optionsCurrent);
          var splitCurrentDate = formattedCurrentDate.split('.');
          var finalCurrentDate = splitCurrentDate[0] + '월 ' + splitCurrentDate[1] + '일';
          $('#date1').text(finalCurrentDate);
          for (var i = 2; i <= 5; i++) {
             var nextDate = new Date();
             nextDate.setDate(currentDate.getDate() + i - 1);
             var optionsNext = { month: 'numeric', day: 'numeric' };
             var formattedNextDate = nextDate.toLocaleDateString('ko-KR', optionsNext);
             var splitNextDate = formattedNextDate.split('.');
             var finalNextDate = splitNextDate[0] + '월 ' + splitNextDate[1] + '일';
             $('#date' + i).text(finalNextDate);
          }
       });
      // Map click event listener
      map.addListener("click", function(e) {
          var latlng = e.latLng; // 클릭한 위치의 위도, 경도 정보
          var defaultImgSrc = "<%=request.getContextPath()%>/resources/images/title.png"; // 기본 이미지 URL
          console.log(latlng);
          $.ajax({
              url: 'https://apis.data.go.kr/B551011/KorService1/locationBasedList1?MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=10&pageNo=1',
              data: {
                  serviceKey: decodeURIComponent('h25GokrXt4MRvyzdkh5DJNs8HRscb9jBf6OX/Fy3AiiTckC7U+HPtX+hXL7yWVJdYWnq4FrIDyjNbM6XQ5iPwA=='),
                  mapX: latlng._lng,
                  mapY: latlng._lat,
                  radius: 100,
              },         
              success: function(data) {
                  if (data && data.response && data.response.body && data.response.body.items && data.response.body.items.item.length > 0) {
                      var item = data.response.body.items.item[0]; // 첫 번째 아이템\
                     
                   // 좌표 클릭 시 addr1과 title 합쳐서 크롤링
                      var searchQuery = item.addr1 +' '+item.title;
                      $.ajax({
                           url: '<%= request.getContextPath() %>/model/tmap.go',
                           type: 'GET',
                           data: { title: searchQuery },
                           dataType: 'html',
                           success: function(response) {
                               console.log("Response:", response);

                               // 크롤링 결과가 추가되기 전에 기존 데이터 지우기
                               $('#crawlingResult table tr').not(':first').remove();
                               var $responseHtml = $(response);
                               var $tableRows = $responseHtml.find('#crawlingResult table tr');
                               $tableRows.each(function() {
                                   var $currentRow = $(this);
                                   var title = $currentRow.find('td:nth-child(1)').text();
                                   var url = $currentRow.find('td:nth-child(1) a').attr('href');
                                   var thumbnailUrl = $currentRow.find('td:nth-child(1) img').attr('src');
                                   console.log("url:::", url);
                                   console.log("Thumbnail URL:::", thumbnailUrl);
                                   // 각 행에 대한 제목을 클릭하면 해당 URL로 이동하도록 링크 추가
                                   var newRow = '<tr>' +
                                       '<td><a href="' + url + '" target="_blank">' + title + '</a></td>' +
                                       '</tr>';
                                   var $thumbnailImage = $('<img>').attr('src', thumbnailUrl).attr('alt', 'Thumbnail');
                                   $('#crawlingResult table').append(newRow);
                                   $('#titleHeader').text(item.title);
                                   // 썸네일 이미지 추가
                                   $('#crawlingResult table tr:last-child td:first-child').append($thumbnailImage);
                               });
                           },
                           error: function(jqXHR, textStatus, errorThrown) {
                               console.log("AJAX call failed.");
                               console.log("Status: " + textStatus + ", Error: " + errorThrown);
                           }
                       });
                   // Check if item.firstimage2 is null or empty
                   var Src = item.firstimage2 ? item.firstimage2 : defaultImgSrc;
                      // Add a marker and infoWindow at the click position
                      var marker = new Tmapv2.Marker({
                          position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                          map: map
                      });
                      popupCount2++;
                      var popupId2 = 'popup' + popupCount2;
                      var selectButtonId2 = 'selectBtn' + popupCount2;
                      var closeButtonId2 = 'closeBtn' + popupCount2;
                      var content = "<form id='" + popupId2 + "' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post'>"
                          + "<input type='hidden' name='title' value='" + item.title + "'>" 
                          + "<input type='hidden' name='addr' value='" + item.addr1 + "'>"
                          + "<a class='heart' data-item-id='item-1' href='#' onclick=\'toggleBm(\""+item.title+"\")\'><i id='heart' class='fas fa-heart'></i></a>"
                          + "<input type='hidden' name='location' value=" + item.title + ">"
                          + "<input type='hidden' name='markerLat' value='" + latlng._lat + "'>"  // latitude input field
                          + "<input type='hidden' name='markerLng' value='" + latlng._lng + "'>"  // longitude input field
                          + "<div style='padding:10px; width:250px;'>" + item.title + "&nbsp;&nbsp;<button id='" + selectButtonId2 + "' type='submit'>Select</button>&nbsp;&nbsp;<button id='" + closeButtonId2 + "' class='close-btn'>Close</button>"
                          + "<div>" + item.addr1 + "</div>"
                          + "<div><img src='" + Src + "' name='image' alt='Image' style='width:100px; height:auto;'></div>"
                          + "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>"  // Start Date input field
                          + "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>"  // End Date input field
                          + "</form>";
                      var infoWindow = new Tmapv2.InfoWindow({
                          position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                          content: content,
                          type: 2,
                          map: map
                      });
                      // Close button event
                      $(document).on('click', '#' + closeButtonId2,
                         function() {
                         infoWindow.setMap(null);
                           marker.setMap(null);
                          $(this).off('click');
                      });
                      
                      
                      document.getElementById(selectButtonId2).addEventListener('click',function(e) {
                         validateAndSubmitForm();
                         console.log('The select button was clicked.');
                         e.preventDefault();
                     });
                      
                         // info btn
                      $(document).on('click', '#websiteBtn', function(e) {
                          e.preventDefault();
                          var searchQuery = item.addr1 + ' ' + item.title; // 관광지 제목과 주소를 검색어로 사용
                          var googleSearchURL = "https://www.google.com/search?q=" + encodeURIComponent(searchQuery);
                          window.open(googleSearchURL, '_blank'); // 새 탭에서 구글 검색 결과 열기
                      });
                  } else {
                      console.error("관광정보없음", data);
                  }
              }
          });
      });
   }  // initTmap() 메서드를 종료시키고 다음 메서드로 넘어갑니다.
   var popupCount = 0;
// 4. POI 상세 정보 API
   function poiDetail(poiId) {
      console.log(poiId);
      var headers = {}; 
      headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
      $.ajax({
         method : "GET", // 요청 방식
         headers : headers,
         url : "https://apis.openapi.sk.com/tmap/pois/"
               + poiId // 상세보기를 누른 아이템의 POI ID
               + "?version=1&resCoordType=EPSG3857&format=json&callback=result",
         async : false, // 동기 설정
         success : function(response) {
            console.log(response);
            // 응답받은 POI 정보
            var detailInfo = response.poiDetailInfo;
            var name = detailInfo.name;
            var address = detailInfo.address;
            var noorLat = Number(detailInfo.frontLat);
            var noorLon = Number(detailInfo.frontLon);
            var pointCng = new Tmapv2.Point(noorLon, noorLat);
            var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
                  pointCng);
            var lat = projectionCng._lat;
            var lon = projectionCng._lng;
            var labelPosition = new Tmapv2.LatLng(lat, lon);
            popupCount++;
            var popupId = 'popup' + popupCount;
            var selectButtonId = 'selectBtn' + popupCount;
            var closeButtonId = 'closeBtn' + popupCount;
            // 상세보기 클릭 시 지도에 표출할 popup창
            var content = "<form id='" + popupId + "' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post' style='background-color: white; font-size: 14px;' >"
                        + "<input type='hidden' name='title' value='" + name + "'>"
                        + "<input type='hidden' name='addr' value='" + address + "'>"
                        + "<input type='hidden' name='location' value='비자림'>"
                        + "<input type='hidden' name='markerLat' value='" + lat + "'>" // latitude input field
                        + "<input type='hidden' name='markerLng' value='" + lon + "'>" // longitude input field 
                        + "<div style='padding:10px; width:250px;'>" + name + "&nbsp;&nbsp;<button id='" + selectButtonId + "' type='submit'>Select</button>&nbsp;&nbsp;<button id='" + closeButtonId + "' class='close-btn'>Close</button>"
                        + "<div>"
                        + address
                        + "</div>"
                        // + "<div><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                        + "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>" // Start Date input field
                        + "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>" // End Date input field
                        + "</form>";
                  var labelInfo = new Tmapv2.Label({
                     position : labelPosition,
                     content : content,
                     map : map
                  });
                  
                  $(document).on('click', '#' + closeButtonId,
                        function() {
                           labelInfo.setMap(null); // Removes the label (popup) from the map
                           $(this).off('click');
                        });
                  
                  document.getElementById(selectButtonId).addEventListener('click',function(e) {
                       validateAndSubmitForm2();
                       console.log('The select button was clicked.');
                       e.preventDefault();
                   });
                  
                  //popup 생성
                  // popup들을 담을 배열에 팝업 저장
                  labelArr.push(labelInfo);
               },
               error : function(request, status, error) {
                  console.log("code:" + request.status + "\n"
                        + "message:" + request.responseText + "\n"
                        + "error:" + error);
               }
            });
   } // 종료.
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
         if (PlanListValidCheck()) {
             // Get the src value from the img tag
             var imgSrc = $("img[name='image']").attr("src");
             
             // Add the hidden input field with the imgSrc value
             var content = "<input type='hidden' name='image' value='" + imgSrc + "'>";
             
             // Rest of your code...
             $('#' + popupId2).append(content);
             $('#' + popupId2).submit();
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
   
   
   function validateAndSubmitForm2(){
         if (PlanListValidCheck2()) {
             // Get the src value from the img tag
             var imgSrc = $("img[name='image']").attr("src");
             // Add the hidden input field with the imgSrc value
             var content = "<input type='hidden' name='image' value='" + imgSrc + "'>";
             // Rest of your code...
             $('#' + popupId).append(content);
             $('#' + popupId).submit();
         }else{
            alert('항목을 모두 입력하셔야 합니다.');   
         }
      } 
      function PlanListValidCheck2() {
         
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
<div id="crawlingResult" style="float:left">
    <!-- 크롤링 결과 -->
    <h1>Crawling Result</h1>
    <table border="1" cellspacing="0" width="500">
        <tr>
            <th id="titleHeader">제주도 여행</th>
        </tr>
            <tr>
                    <c:forEach var="crawlingData" items="${crawlingDataList}">
                <td>
                    <a href="${crawlingData.url}" target="_blank">
                        <img src="${crawlingData.thumbnail}" alt="Thumbnail">
                        <br>
                        ${crawlingData.title}
                    </a>
                </td>
                 </c:forEach>
            </tr>
       
    </table>
</div>
               <!-- 날씨 관련 출력창 -->
          <div id="weather-widget" style="float:center" height="400" width="800">
    <table>
        <tr>
            <td>
               <div id="date1">
               
               </div>
                <div id="weather">
                    <img id="icon" src="" alt="">
                </div>
                <div id="temperature">
                    <p id="temp"></p>
                </div>
            </td>
            <td>
               <div id=date2>
               
               </div>
                <div id="forecast-day2">
                    <div id="forecast-weather">
                        <img id="day2-icon" src="" alt="">
                    </div>
                    <div id="forecast-info-day2">
                        <p id="forecast-temp-day2"></p>
                    </div>
                </div>
            </td>
            <td>
               <div id="date3">
               
               </div>
                <div id="forecast-day3">
                    <div id="forecast-weather">
                        <img id="day3-icon" src="" alt="">
                    </div>
                    <div id="forecast-info-day3">
                        <p id="forecast-temp-day3"></p>
                    </div>
                </div>
            </td>
            <td>
               <div id="date4">
               
               </div>
                <div id="forecast-day4">
                    <div id="forecast-weather">
                        <img id="day4-icon" src="" alt="">
                    </div>
                    <div id="forecast-info-day4">
                        <p id="forecast-temp-day4"></p>
                    </div>
                </div>
            </td>
            <td>
               <div id="date5">
               
               </div>
                <div id="forecast-day5">
                    <div id="forecast-weather">
                        <img id="day5-icon" src="" alt="">
                    </div>
                    <div id="forecast-info-day5">
                        <p id="forecast-temp-day5"></p>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</div>

<c:if test="${!empty user_id}">
<div align="center"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath()%>/plan_list.go?id=${user_id}')">상세설정</a></div>
</c:if>
<c:if test="${!empty kakao_id}">
<div align="center"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath() %>/plan_list.go?id=${kakao_id}')">상세설정</a></div>
</c:if>
<br>
<br>
<div align="center"><%@ include file="./include/footer.jsp" %></div>
<br>
</body>
</html>
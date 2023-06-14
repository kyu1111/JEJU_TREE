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
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<script src="https://cdn.jsdelivr.net/npm/@turf/turf@6/turf.min.js"></script>
<script type="text/javascript">

   var map;
   var isDrawing = false;
   var fixedMarkers = [];
   var userMarkers = [];

   function initTmap() {
      map = new Tmapv2.Map("map_div", {
         center : new Tmapv2.LatLng(33.3666, 126.5333),
         width : "100%",
         height : "400px",
         zoom : 10
      });

      fixedMarkers[0] = new Tmapv2.Marker({
         position : new Tmapv2.LatLng(33.361666, 126.529166), // 한라산 국립공원
         map : map,
         visible : false
      });
      
      fixedMarkers[0].addListener("click", function() {
           var content ="<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
               "<div style='font-size: 12px; line-height: 15px;'>"+
                   "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>SK T-타워"+
               "</div>"+
            "</div>"+
            "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
               "<div style='display:inline-block; border:1px solid #dcdcdc;'><img src='/resources/images/common/sk_logo.png' width='73' height='70'></div>"+
               "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
                   "<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>서울특별시 중구 을지로 65 SK T-타워</span>"+
                   "<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>(우)100-999  (지번)을지로2가 11</span>"+
                   "<span style='font-size: 12px; margin-left:2px;'><a href='https://openapi.sk.com/' target='blank'>개발자센터</a></span>"+
               "</div>"+
            "</div>";

           var infoWindow = new Tmapv2.InfoWindow({
               position: new Tmapv2.LatLng(33.361666, 126.529166),
               content: content,
               map: map
           });
       });
      
      fixedMarkers[1] = new Tmapv2.Marker({
         position : new Tmapv2.LatLng(33.458875, 126.942933), // 성산일출봉
         map : map,
         visible : false
      });
      
      fixedMarkers[1].addListener("click", function() {
           var infoWindow = new Tmapv2.InfoWindow({
               position: new Tmapv2.LatLng(33.458875, 126.942933),
               content: "<p>이곳은 성산일출봉입니다.</p>",
               map: map
           });
       });

      fixedMarkers[2] = new Tmapv2.Marker({
         position : new Tmapv2.LatLng(33.455483, 126.768394), // 주상절리대
         map : map,
         visible : false
      });
      
      fixedMarkers[2].addListener("click", function() {
           var infoWindow = new Tmapv2.InfoWindow({
               position: new Tmapv2.LatLng(33.455483, 126.768394),
               content: "<p>이곳은 주상절리대입니다.</p>",
               map: map
           });
       });
      
      fixedMarkers[3] = new Tmapv2.Marker({
          position : new Tmapv2.LatLng(33.455483, 126.768394), // 주상절리대
          map : map,
          visible : false
       });
       
       fixedMarkers[3].addListener("click", function() {
            var infoWindow = new Tmapv2.InfoWindow({
                position: new Tmapv2.LatLng(33.455483, 126.768394),
                content: "<p>이곳은 주상절리대입니다.</p>",
                map: map
            });
        });
       
       fixedMarkers[4] = new Tmapv2.Marker({
           position : new Tmapv2.LatLng(33.455483, 126.768394), // 주상절리대
           map : map,
           visible : false
        });
        
        fixedMarkers[4].addListener("click", function() {
             var infoWindow = new Tmapv2.InfoWindow({
                 position: new Tmapv2.LatLng(33.455483, 126.768394),
                 content: "<p>이곳은 주상절리대입니다.</p>",
                 map: map
             });
         });
      
      map.addListener("click", function(e) {
               if (isDrawing) {
                  var position = new Tmapv2.LatLng(e.latLng.lat(),
                        e.latLng.lng());
                  var marker = new Tmapv2.Marker({
                     position : position,
                     map : map
                  });
                  userMarkers.push(marker);
                  if (userMarkers.length == 4) {
                     drawPolygon();
                  }
               }
            });
   } // initTmap() 메서드 종료.
   
   
   function drawPolygon() {
      var path = userMarkers.map(function(marker) {
         return marker.getPosition();
      });
      path.push(userMarkers[0].getPosition());
      var polygon = new Tmapv2.Polygon({
         path : path,
         strokeColor : "#000000",
         strokeOpacity : 0.5,
         strokeWeight : 2,
         fillColor : "#000000",
         fillOpacity : 0.35,
         map : map
      });
      isDrawing = false;
   }

   function startDrawing() {
      isDrawing = true;
      userMarkers.forEach(function(marker) {
         marker.setMap(null);
      });
      userMarkers = [];

      // Hide all fixed markers.
      //fixedMarkers.forEach(function(marker) {
      //marker.setVisible(false);
      //});
   }

   function hideMarkers() {
      // Hide all fixed markers.
      fixedMarkers.forEach(function(marker) {
         marker.setVisible(false);
      });
   }

   function stopDrawing() {
      var path = userMarkers.map(function(marker) {
         return [ marker.getPosition().lng(), marker.getPosition().lat() ];
      });
      path.push(path[0]); // Add the first point to the end to close the polygon.
      var polygon = turf.polygon([ path ]);
      fixedMarkers.forEach(function(marker) {
         var point = turf.point([ marker.getPosition().lng(),
               marker.getPosition().lat() ]);
         if (turf.booleanPointInPolygon(point, polygon)) {
            marker.setVisible(true);
         }
      });
      console.log(userMarkers.map(function(marker) {
         return marker.getPosition();
      }));
   }
</script>
</head>
<body onload="initTmap()">
   <button onclick="startDrawing()">Start Drawing</button>
   <button onclick="stopDrawing()">Stop Drawing</button>
   <button onclick="hideMarkers()">Hide Markers</button>
   <div id="map_div"></div>
</body>
</html>
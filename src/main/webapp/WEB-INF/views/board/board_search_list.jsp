<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
<style type="text/css">
   html, body {
     height: 100%;
   }
   #container {
     position: relative;
     top: 50%;
     left: 50%;
     transform: translate(-50%, -50%);
     width: 800px;
     height: 100%;
     display: flex;
     flex-direction: column;
     justify-content: center;
   }


</style>
</head>
<body>

    <%@ include file="../include/navbar.jsp" %>
        
        <div id="container">
        <table border="1" cellspacing="0" width="500">
        <c:set var="list" value="${searchPageList }"/>
        <c:set var="paging" value="${Paging }"/>
        <tr>
              <th>게시글 No.</th> <th>글 제목</th>
              <th>작성자</th> <th>조회수</th> <th>작성일자</th>
	    </tr>
            <c:if test="${!empty list }">
	            
                <c:forEach items="${list }" var="dto">
                    <tr>
                        <td> ${dto.board_no }</td> 
                        <td>
                           <a href="<%=request.getContextPath()%>/board_search_cont.go?no=${dto.board_no}&page=${paging.page}&field=${paging.field}&keyword=${paging.keyword}">${dto.board_Title }</a>
                         </td> 
                        
                        <td> ${dto.writer }</td> 
                        <td> ${dto.board_RegDate.substring(0, 10) }</td> 
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty list }">
                <tr>
                    <td colspan="5" align="center">
                        <h3>검색 게시물 목록이 없습니다....</h3>
                    </td>
                </tr>
            </c:if>
        </table>
        
        <br>
        
        <%-- 검색 관련 페이징 처리 출력 부분 --%>
        <c:if test="${paging.page > paging.block }">
            <a href="PlanBoardList.go?page=1&field=${paging.field}&keyword=${paging.keyword}">[처음으로]</a>
            <a href="PlanBoardList.go?page=${paging.startBlock - 1 }&field=${paging.field}&keyword=${paging.keyword}">◀</a>
        </c:if>
        <c:forEach begin="${paging.startBlock }" end="${paging.endBlock }" var="i">
            <c:if test="${i == paging.page }">
                <b><a href="PlanBoardList.go?page=${i }&field=${paging.field}&keyword=${paging.keyword}">[${i }]</a></b>
            </c:if>
            <c:if test="${i != paging.page }">
                <a href="PlanBoardList.go?page=${i }&field=${paging.field}&keyword=${paging.keyword}">[${i }]</a>
            </c:if>
        </c:forEach>
        
        <c:if test="${paging.endBlock < paging.allPage }">
            <a href="PlanBoardList.go?page=${paging.endBlock + 1 }&field=${paging.field}&keyword=${paging.keyword}">▶</a>
            <a href="PlanBoardList.go?page=${paging.allPage }&field=${paging.field}&keyword=${paging.keyword}">[마지막으로]</a>
        </c:if>
        <br>
        <br>
        
        <form method="post" action="<%=request.getContextPath()%>/plan_board_search.go">
            <select name="field">
                <option value="board_Title">제목</option>
                <option value="board_Content">내용</option>
                <option value="Writer">작성자</option>
            </select>
            <input name="keyword">&nbsp;&nbsp;
            <input type="submit">
        </form>
        <br>
        <input type="button" value="전체목록" onclick="location.href='PlanBoardList.go?page=1'">
        </div>
    <%@ include file="../include/footer.jsp" %>
</body>

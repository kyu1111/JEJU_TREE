<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동행자 게시판</title>
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

   #board_table {
     justify-content: space-around;
     display: flex;
     flex-direction: column;
     width: 100%;
     border: 1px solid black;
     text-align: left;
   }

   #table_row {
     display: flex;
     flex-direction: row;
     width: 100%;
     border-bottom: 1px solid black;
     justify-content: space-around;
   }
   
   #table_head {
     font-weight: bold;
     flex-basis: 25%;
   }
   .table_col {
     text-align: left;
     flex-basis: 25%;
   }
</style>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">

</head>
<body>
   <%@ include file="../include/navbar.jsp" %>
     
   <div id="container">
      <div id="board_content">
         <div id="board_table">
            <div id="table_row">
               <div id="table_head">게시글 번호</div>
               <div id="table_head">글제목</div>
               <div id="table_head">작성자</div>
               <div id="table_head">등록일</div>
               <div id="table_head">동행자수</div>
               <div id="table_head">조회수</div>
               <div id="table_head">추천수</div>
            </div>
            <c:set var="paging" value="${Paging }"/>
            <c:forEach var="board_dto" items="${board_list}">
               <div id="table_row">
                  <div class="table_col">${board_dto.board_no}</div>
                  <div class="table_col">
                     <a href="board_content.go?board_no=${board_dto.board_no}&page=${paging.page}">
                     ${board_dto.board_Title}
                     </a>
                  </div>
                  <div class="table_col">${board_dto.writer}</div>
			<c:if test="${board_dto.board_Update_Date eq board_dto.board_RegDate}">
			    <div class="table_col">${board_dto.board_RegDate.substring(0, 10)}</div>
			</c:if>
			<c:if test="${board_dto.board_Update_Date ne board_dto.board_RegDate}">
			    <div class="table_col">${board_dto.board_Update_Date.substring(0, 10)}</div>
			</c:if>
                  <div class="table_col">만들어야함</div>
                  <div class="table_col">${board_dto.board_hit}</div>
                  <div class="table_col">${board_dto.like_count}</div>
               </div>
            </c:forEach>
         </div>
          <input type="button" value="글쓰기" onclick="location.href='board_write.go'">
         <%-- 페이징 처리 출력 부분 --%>
         <c:if test="${paging.page > paging.block }">
            <a href="PlanBoardList.go?page=1">[처음으로]</a>
            <a href="PlanBoardList.go?page=${paging.startBlock - 1 }">◀</a>
         </c:if>
        <c:forEach begin="${paging.startBlock }" end="${paging.endBlock }" var="i">
            <c:if test="${i == paging.page }">
                <b><a href="PlanBoardList.go?page=${i }">[${i }]</a></b>
            </c:if>
            <c:if test="${i != paging.page }">
                <a href="PlanBoardList.go?page=${i }">[${i }]</a>
            </c:if>
        </c:forEach>
        
        <c:if test="${paging.endBlock < paging.allPage }">
            <a href="PlanBoardList.go?page=${paging.endBlock + 1 }">▶</a>
            <a href="PlanBoardList.go?page=${paging.allPage }">[마지막으로]</a>
        </c:if>
        <br>
        <br>
        </div>
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
   </div>
   
   <%@ include file="../include/footer.jsp" %>
</body>
</html>
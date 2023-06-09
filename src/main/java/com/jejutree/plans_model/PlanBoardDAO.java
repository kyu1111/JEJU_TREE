package com.jejutree.plans_model;

import java.util.List;
import java.util.Map;


public interface PlanBoardDAO {
   
   int getListCount();
	
   List<PlanBoardDTO> getboarList(PageDTO dto);
   
   PlanBoardDTO  getboardContent (int board_no);
  
   PlanBoardDTO boardCont(int no);
   
   int insertBoard(PlanBoardDTO dto);
   
   int searchBoardCount(Map<String, String> map);
   
   List<PlanBoardDTO> searchBoardList(PageDTO dto);
   
   void readCount(int no);
	
   int updatePlanBoard(PlanBoardDTO dto);
   
   void deleteboard(int no);
   
   void updatSequence(int no);
   
   int findLike(BoardLikeDTO dto);
   
   int insertLike(BoardLikeDTO dto);
   
   int deleteLike(BoardLikeDTO dto);
   
   int LikeCount(BoardLikeDTO dto);
   
   void updateLikeCount(PlanBoardDTO dto);

   List<PlanBoardCommentDTO> getCommentList(PlanBoardCommentDTO dto);
		
	void writeComment(PlanBoardCommentDTO dto);
	
	int updateComment(PlanBoardCommentDTO dto);
	
	int deleteComment(int rno);
}
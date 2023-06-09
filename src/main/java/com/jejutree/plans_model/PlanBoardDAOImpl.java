package com.jejutree.plans_model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class PlanBoardDAOImpl implements PlanBoardDAO {
   
   @Autowired
   private SqlSessionTemplate sqlSession;
   
   @Override
   public int getListCount() {
	   return this.sqlSession.selectOne("cnt");
   }
   
   @Override
   public List<PlanBoardDTO> getboarList(PageDTO dto) {
   return sqlSession.selectList("board_list", dto);
   }
   @Override
   public int insertBoard(PlanBoardDTO dto) {
	   return this.sqlSession.insert("write", dto);
   }

   @Override
   public PlanBoardDTO getboardContent(int board_no) {
      return this.sqlSession.selectOne("getBoard_Content",board_no);
   }

	@Override
	public int searchBoardCount(Map<String, String> map) {
		return this.sqlSession.selectOne("count", map);
	}
	
	@Override
	public List<PlanBoardDTO> searchBoardList(PageDTO dto) {
		return this.sqlSession.selectList("search", dto);
	}

	@Override
	public void readCount(int no) {
		this.sqlSession.update("read", no);
		
	}

	
	@Override
	public PlanBoardDTO boardCont(int no) {
		return this.sqlSession.selectOne("cont", no);
	}

	@Override
	public int updatePlanBoard(PlanBoardDTO dto) {
		return this.sqlSession.update("modi", dto);
	}

	@Override
	public void deleteboard(int no) {
		this.sqlSession.delete("del", no);
		
	}

	@Override
	public void updatSequence(int no) {
		this.sqlSession.update("sequence", no);
		
	}

	@Override
	public int findLike(BoardLikeDTO dto) {
		return this.sqlSession.selectOne("countlike", dto);
	}

	@Override
	public int insertLike(BoardLikeDTO dto) {
		return this.sqlSession.insert("insertLike", dto);
	}

	@Override
	public int deleteLike(BoardLikeDTO dto) {
		return this.sqlSession.delete("deleteLike", dto);
	}

	@Override
	public int LikeCount(BoardLikeDTO dto) {
		return this.sqlSession.selectOne("LikeCount", dto);
	}

	@Override
	public void updateLikeCount(PlanBoardDTO dto) {
		this.sqlSession.update("updateLikeCount", dto);
		
	}

   @Override
	public List<PlanBoardCommentDTO> getCommentList(PlanBoardCommentDTO dto) {
		return this.sqlSession.selectList("comment_list",dto);
	}

	@Override
	public void writeComment(PlanBoardCommentDTO dto) {
		this.sqlSession.insert("write_comment", dto);
	}

	@Override
	public int updateComment(PlanBoardCommentDTO dto) {
		return this.sqlSession.update("update_comment", dto);
	}

	@Override
	public int deleteComment(int rno) {
		return this.sqlSession.delete("deleteComment", rno);
	}
	

}  
package com.jejutree.PlanController;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.HttpHeaders;

import com.jejutree.plans_model.BoardLikeDTO;
import com.jejutree.plans_model.PageDTO;
import com.jejutree.plans_model.PlanBoardCommentDTO;
import com.jejutree.plans_model.PlanBoardDAO;
import com.jejutree.plans_model.PlanBoardDTO;
import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;
import com.mysql.cj.xdevapi.JsonArray;
@Controller
public class planboardController {
   
    @Autowired
    private HttpSession session;
   
    @Inject
    private PlanBoardDAO dao;
    @Inject
    private UserDAO userdao;
    
   // 한 페이지당 보여질 게시물의 수
 	private final int rowsize = 3;
 	
 	// DB 상의 전체 게시물의 수
 	private int totalRecord = 0;
    @RequestMapping("PlanBoardList.go")
    public String  planBoardList(HttpServletRequest requeust, Model model){
    	// 페이징 처리 작업
		int page;    // 현재 페이지 변수
		if(requeust.getParameter("page") != null) {
			page = Integer.parseInt(requeust.getParameter("page"));
			
		} else {
			// 처음으로 "게시물 전체 목록" 태그를 클릭한 경우
			page = 1;
		}
		
		// DB 상의 전체 게시물의 수를 확인하는 메서드 호출
		totalRecord = this.dao.getListCount();
		//System.out.println("전체  수 >>> "+totalRecord);

        PageDTO dto = new PageDTO(page, rowsize, totalRecord);
       List<PlanBoardDTO> board_list = this.dao.getboarList(dto);
       System.out.println("totalrecord"+dto.getTotalRecord());
       System.out.println("page"+dto.getPage());
       if(! board_list.isEmpty()) {
          model.addAttribute("board_list", board_list);
       }
       model.addAttribute("Paging", dto);
       
       return "board/board_list";
    }
    
    

	@RequestMapping("board_write.go")
	public String write(Model model) {
		

		String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	     String userId = (String) session.getAttribute("user_id");
	     UserDTO dto = new UserDTO();
		if (KakaoInfo != null || userId != null) {
			if(userId != null) {
				dto.setUser_id(userId);
				dto = this.userdao.getuser(userId);
				
			} else if(KakaoInfo != null) {
				dto.setUser_id(KakaoInfo);
				dto = this.userdao.getuser(KakaoInfo);
			} 
		}
		System.out.println(userId);
		System.out.println(dto.getUser_id());
		System.out.println(dto.getUser_nickname());
		model.addAttribute("User", dto);
		
		return "board/board_write";
	}
	

	@RequestMapping("board_write_ok.go")
	public void writeOk(PlanBoardDTO dto, HttpServletResponse response) throws IOException {
		
		int check = this.dao.insertBoard(dto);
		
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = response.getWriter();
		
		if(check > 0) {
			out.println("<script>");
			out.println("alert('게시글 추가 성공')");
			out.println("location.href='PlanBoardList.go'");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('게시글 추가 실패')");
			out.println("history.back()");
			out.println("</script>");
		}
	}
	
    @RequestMapping("board_content.go")
    public String planBoardContent(@RequestParam("page") int page, @RequestParam(value="board_no") int board_no,Model model) {
       
       PlanBoardDTO plan_board_dto = dao.getboardContent(board_no);
       PlanBoardDTO dto = this.dao.boardCont(board_no);
       
       
       if(plan_board_dto != null) {
    	   dao.readCount(board_no);
          model.addAttribute("board_content",plan_board_dto).
          addAttribute("Paging", page);
       }
       
       
       return "board/board_content";
    }
    
    @RequestMapping(value="commentList.go", produces="application/json; charset=utf8")
    @ResponseBody
    public ResponseEntity getCommetnList(PlanBoardCommentDTO dto,HttpServletRequest request) {
       HttpHeaders responseHeaders = new HttpHeaders();
       ArrayList<HashMap> hmlist = new ArrayList<HashMap>();
        
       //댓글 번호로 조회 해 오기.
       List<PlanBoardCommentDTO> commentList = this.dao.getCommentList(dto);
       
       if(commentList.size() >0) {
          for(int i=0; i<commentList.size(); i++){
                HashMap hm = new HashMap();
                hm.put("rno", commentList.get(i).getRno());
                hm.put("content", commentList.get(i).getContent());
                hm.put("writer", commentList.get(i).getWriter());
                
                hmlist.add(hm);
            }
          
       }
       JSONArray json = new JSONArray(hmlist);        
        return new ResponseEntity(json.toString(), responseHeaders, HttpStatus.CREATED);
    }
   /*
    * @RequestMapping(value="commentwirte.go")
    * 
    * @ResponseBody public String ajax_addComment(PlanBoardCommentDTO
    * dto,HttpServletRequest request) throws Exception{
    * 
    * HttpSession session = request.getSession(); LoginVO loginVO =
    * (LoginVO)session.getAttribute("loginVO");
    * 
    * try{
    * 
    * boardVO.setWriter(loginVO.getUser_id());
    * boardServiceImpl.addComment(boardVO);
    * 
    * } catch (Exception e){ e.printStackTrace(); }
    * 
    * return "success"; }
    */
    
    @RequestMapping("plan_board_search.go")
    public String planSearch(@RequestParam("field") String field, @RequestParam("keyword") String keyword, HttpServletRequest request, Model model) {
    	// 검색 페이징 처리 작업
		int page;    // 현재 페이지 변수
		if(request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
			
		} else {
			// 처음으로 "게시물 전체 목록" 태그를 클릭한 경우
			page = 1;
		}
		
		//검색분류와 검색어에 해당하는 게시글의 수를 DB에서 직접 확인하는 작업
		Map<String, String> map = new HashMap<String, String>();
		System.out.println("field"+field);
		System.out.println("keword"+keyword);
		map.put("field", field);
		map.put("keyword", keyword);
		
		totalRecord = this.dao.searchBoardCount(map);
		System.out.println("검색 게시물 수 >>>" +  totalRecord);

 		PageDTO pdto = new PageDTO(page, rowsize, totalRecord, field, keyword);
 		System.out.println(pdto);
 		
 		// 검색 시 한 페이지당 보여질 게시물의 수만큼 검색한 게시물을 List로 가져오는 메서드 호출
 		List<PlanBoardDTO> searchList = this.dao.searchBoardList(pdto);
 		
 		model.addAttribute("searchPageList", searchList).
 		      addAttribute("Paging", pdto);
 		
		return "board/board_search_list";
    	
    }
    
    @RequestMapping("board_search_cont.go")
	public String seachCont(@RequestParam("page") int page,
			                @RequestParam("no") int no,
			                @RequestParam("keyword") String keyword
			                ,@RequestParam("field") String field, Model model) {
		
    	PlanBoardDTO dto = this.dao.boardCont(no);
		
    	PlanBoardDTO plan_board_dto = dao.getboardContent(no);
        
        if(plan_board_dto != null) {
           model.addAttribute("board_content",plan_board_dto);
        }
		model.addAttribute("sCont", dto).
		      addAttribute("Paging", page).
		      addAttribute("Field", field).
		      addAttribute("Keyword", keyword);
       
		dao.readCount(no);
		return "board/board_search_cont";
	}
     
    
    @RequestMapping("board_modify.go")
    public String planBoardModify(@RequestParam("page") int nowPage, @RequestParam("no") int board_no, Model model, HttpServletResponse response) throws IOException {
    	
    	response.setContentType("text/html; charset=UTF-8");
		
 	     PrintWriter out = response.getWriter();
 	    
 	     PlanBoardDTO dto = this.dao.boardCont(board_no);
 	   
    	String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	     String userId = (String) session.getAttribute("user_id");
	     UserDTO userdto = new UserDTO();
		if (KakaoInfo != null || userId != null) {
			if(userId != null) {
				userdto.setUser_id(userId);
				userdto = this.userdao.getuser(userId);
				
			} else if(KakaoInfo != null) {
				userdto.setUser_id(KakaoInfo);
				userdto = this.userdao.getuser(KakaoInfo);
			} 
		}
		
		String currnick = userdto.getUser_nickname();
		String boardnick = dto.getUser_Nickname();
		System.out.println(userId);
		System.out.println(userdto.getUser_id());
		System.out.println(userdto.getUser_nickname());
		model.addAttribute("User", userdto);
		if(currnick.equals(boardnick)) {	
			PlanBoardDTO plan_board_dto = dao.getboardContent(board_no);
			model.addAttribute("board_content",plan_board_dto).
			addAttribute("Paging", nowPage);
			return "board/board_update";
			}else {
			out.println("<script>");
			out.println("alert('본인이 작성한 글이 아닙니다.')");
			out.println("history.back()");
			out.println("</script>");
			return null;

			}
       
    }
    
    
    @RequestMapping("board_modify_ok.go")
	public void modifyOk(PlanBoardDTO dto, @RequestParam("page") int nowPage, HttpServletResponse response) throws IOException {
		
	   response.setContentType("text/html; charset=UTF-8");
		
	   PrintWriter out = response.getWriter();
	   
			int check = this.dao.updatePlanBoard(dto);
			if(check > 0) {	
			out.println("<script>");
			out.println("alert('게시글 수정 성공')");
			out.println("location.href='board_content.go?board_no="+dto.getBoard_no()+"&page="+nowPage+"'");
			out.println("</script>");
			}else {
			out.println("<script>");
			out.println("alert('게시글 수정 실패')");
			out.println("history.back()");
			out.println("</script>");
			}
		
	}
    
    
    @RequestMapping("board_delete.go")
	public void delete(@RequestParam("no") int no, @RequestParam("page") int nowPage, HttpServletResponse response) throws IOException {

    	response.setContentType("text/html; charset=UTF-8");
			
	     PrintWriter out = response.getWriter();
			
 	     PlanBoardDTO dto = this.dao.boardCont(no);
 	   
    	String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	    String userId = (String) session.getAttribute("user_id");
	     UserDTO userdto = new UserDTO();
		if (KakaoInfo != null || userId != null) {
			if(userId != null) {
				userdto.setUser_id(userId);
				userdto = this.userdao.getuser(userId);
				
			} else if(KakaoInfo != null) {
				userdto.setUser_id(KakaoInfo);
				userdto = this.userdao.getuser(KakaoInfo);
			} 
		}
		
		String currnick = userdto.getUser_nickname();
		String boardnick = dto.getUser_Nickname();
		if(currnick.equals(boardnick)) {	
	     if(currnick.equals(boardnick)) {
	    	    this.dao.deleteboard(no);
	    	    this.dao.updatSequence(no);
				out.println("<script>");
				out.println("alert('게시글 삭제 성공')");
				out.println("location.href='PlanBoardList.go'");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('본인이 작성한 글이 아닙니다.')");
				out.println("history.back()");
				out.println("</script>");
				
			}
		}
    }
    
    @RequestMapping(value = "board_like.go", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String  boardLike(@RequestParam("no") int no, @RequestParam("user_id") String user_id) throws IOException {
		
		   
	   	String KakaoInfo = (String) session.getAttribute("KakaoInfo");
		    String userId = (String) session.getAttribute("user_id");
		     UserDTO userdto = new UserDTO();
			if (KakaoInfo != null || userId != null) {
				if(userId != null) {
					userdto.setUser_id(userId);
					userdto = this.userdao.getuser(userId);
					
				} else if(KakaoInfo != null) {
					userdto.setUser_id(KakaoInfo);
					userdto = this.userdao.getuser(KakaoInfo);
				} 
			}
			String currId = userdto.getUser_id();
			if(user_id.equals(currId)) {
				return "-1";
				
			} else {
				BoardLikeDTO likedto = new BoardLikeDTO();
				PlanBoardDTO dto = new PlanBoardDTO();
			    likedto.setBoard_no(no);
			    likedto.setUser_id(currId);
			    System.out.println(user_id);
			    System.out.println(currId);
				int check = this.dao.findLike(likedto);
				if(check == 1) {
					this.dao.deleteLike(likedto);
					int like = this.dao.LikeCount(likedto);
				    dto.setLike_count(like);
				    dto.setBoard_no(no);
					this.dao.updateLikeCount(dto);
					return "0";
				} else {
					this.dao.insertLike(likedto);
					int like = this.dao.LikeCount(likedto);
					dto.setLike_count(like);
					dto.setBoard_no(no);
					this.dao.updateLikeCount(dto);
					return"1";
				}
				
			}
         }
    
    @RequestMapping(value = "like_count.go", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String  likeCount(@RequestParam("no") int no, @RequestParam("user_id") String user_id) throws IOException {
		
		   
	   	String KakaoInfo = (String) session.getAttribute("KakaoInfo");
		    String userId = (String) session.getAttribute("user_id");
		     UserDTO userdto = new UserDTO();
			if (KakaoInfo != null || userId != null) {
				if(userId != null) {
					userdto.setUser_id(userId);
					userdto = this.userdao.getuser(userId);
					
				} else if(KakaoInfo != null) {
					userdto.setUser_id(KakaoInfo);
					userdto = this.userdao.getuser(KakaoInfo);
				} 
			}
			String currId = userdto.getUser_id();
			if(user_id.equals(currId)) {
				return "-1";
				
			} else {
				BoardLikeDTO likedto = new BoardLikeDTO();
			    likedto.setBoard_no(no);
			    likedto.setUser_id(currId);
			    System.out.println(user_id);
			    System.out.println(currId);
				int check = this.dao.findLike(likedto);
				
				if(check == 1) {
					return "0";
				} else {
					return"1";
				}
				
			}
         }
} 
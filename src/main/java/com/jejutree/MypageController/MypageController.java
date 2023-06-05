package com.jejutree.MypageController;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;

import javax.mail.Multipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.jejutree.Login.JoinEmailService;
import com.jejutree.kakaoController.kakaoLoginService;
import com.jejutree.plans_model.UserPlansDAO;
import com.jejutree.plans_model.UserPlansDTO;
import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;
import com.mysql.cj.Session;

@Controller
public class MypageController {
	@Autowired
	private UserDAO dao;
	@Autowired
     private JoinEmailService emailService;
	@Autowired
	private UserPlansDAO plansdao;
	
	@RequestMapping("mypage.go")
	public String mypage(HttpSession session, Model model) {
		String userId = (String) session.getAttribute("user_id");
		List<UserPlansDTO> list = this.plansdao.getPlanList(userId);
		if (!list.isEmpty()) {
			UserPlansDTO startPlan = list.get(0);
			UserPlansDTO endPlan = list.get(list.size() - 1);
			model.addAttribute("startPlan", startPlan);
			model.addAttribute("endPlan", endPlan);
		}
		model.addAttribute("List", list);
		
		
		String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	     String user_id = (String) session.getAttribute("user_id");
	     UserDTO dto = new UserDTO();
		if (KakaoInfo != null || user_id != null) {
			if(user_id != null) {
				dto.setUser_id(user_id);
				dto = this.dao.getuser(user_id);
				
			} else if(KakaoInfo != null) {
				dto.setUser_id(KakaoInfo);
				dto = this.dao.getuser(KakaoInfo);
			} 
		}
		
		
		
		model.addAttribute("UserInfo", dto);
		return "mypage/mypage";
	}
	
	@RequestMapping("userprofile.go")
	public String userprofile(HttpSession session, Model model) {
		String KakaoInfo = (String) session.getAttribute("KakaoInfo");
	     String user_id = (String) session.getAttribute("user_id");
	     UserDTO dto = new UserDTO();
		if (KakaoInfo != null || user_id != null) {
			if(user_id != null) {
				dto.setUser_id(user_id);
				dto = this.dao.getuser(user_id);
				
			} else if(KakaoInfo != null) {
				dto.setUser_id(KakaoInfo);
				dto = this.dao.getuser(KakaoInfo);
			} 
		}
		
		
		
		model.addAttribute("UserInfo", dto);
		
		return "mypage/userprofile";
	}
	
	@RequestMapping("updateUser.go")
	public String updateUser(UserDTO dto, HttpServletRequest request,  @RequestParam(value = "upload") MultipartFile mFile, HttpServletResponse response, Model model, HttpSession session, @RequestParam("db_pwd") String db_pwd) throws Exception {
		 int id = dto.getId();
		  System.out.println(id);
		  String pwdCheck = dao.checkPwd(id);
		  String emailCheck = dao.emailCheck(id);
		  System.out.println("회원 원래 비번"+pwdCheck);
		  System.out.println(dto.getUser_pwd());
	  String profile = dto.getUser_image();
	  System.out.println(profile);
	  response.setContentType("text/html; charset=UTF-8");
	  PrintWriter out = response.getWriter();
	  
	  
   // 절대경로 가져오기
    Properties prop = new Properties();
    FileInputStream fis = new FileInputStream(request.getRealPath("WEB-INF\\classes\\config\\fileupload.properties"));
    prop.load(new InputStreamReader(fis, "UTF-8"));
    fis.close();
    
    Calendar cal = Calendar.getInstance();
    int year = cal.get(Calendar.YEAR);
    int month = cal.get(Calendar.MONTH) + 1;
    int day = cal.get(Calendar.DAY_OF_MONTH);
	  
	  String originalFileName = mFile.getOriginalFilename();
	  
	  if(!originalFileName.isEmpty()) {
		  System.out.println("originalFileName: " + originalFileName);
	        
	         String saveFolder = prop.getProperty(System.getenv("USERPROFILE").substring(3));
	         String saveFolder2 = prop.getProperty(System.getenv("USERPROFILE").substring(3))+"\\"+year+month+day;
	         String saveFileName = "";
	         
		        File path1 = new File(saveFolder);
		        File path2 = new File(saveFolder2);

		        if (!path1.exists()) {
		            path1.mkdirs();
		        }
		        if (!path2.exists()) {
		        	path2.mkdirs();
		        }
		        


		        if (!originalFileName.equals(dto.getUser_image())) {
		            saveFileName = System.currentTimeMillis() + "_" + originalFileName;
		            	
		            	dto.setUser_image("/resources/images/profile/" +year+month+day +"/" +saveFileName);
		            try {
		            	mFile.transferTo(new File(saveFolder2, saveFileName));

		            } catch (IOException e) {
		                e.printStackTrace();
		            }
		        } 
		    } else {
	            // 기본이미지 세팅
	            dto.getUser_image();
	        }
	  System.out.println(dto.getUser_image() + "프로필 수정");
	 
	  if(!emailCheck.equals(dto.getUser_email())) {
			String newKey = emailService.emailChangeForm(dto);
			
			this.dao.updateMail(dto);
			System.out.println(dao.updateMail(dto));
			System.out.println("회원 아이디"+dto.getId());
			System.out.println("회원 새 이메일"+dto.getUser_email());
			session.setAttribute("updateDto", dto);
			return "mypage/emailChangeForm";
	  } else {
		  if(pwdCheck.equals(dto.getUser_pwd())) {
			  if(db_pwd != null && !db_pwd.equals("")) {
				  dto.setUser_pwd(db_pwd);
				  System.out.println("비번 변경함"+dto.getUser_pwd());
			  } else {
				  dto.setUser_pwd(pwdCheck);
				  System.out.println("비번 변경안함"+dto.getUser_pwd());
			  }
				
			  int check = this.dao.updateMember(dto);
				if(check > 0) {
				model.addAttribute("UserInfo", dto);

				out.println("<script>");
				out.println("alert('회원정보 수정 성공')");
				out.println("location.href='userprofile.go'");
				out.println("</script>");
				}else {
				out.println("<script>");
				out.println("alert('회원정보 수정 실패')");
				out.println("history.back()");
				out.println("</script>");
				}
			} else {
				out.println("<script>");
				out.println("alert('비밀번호 틀림')");
				out.println("history.back()");
				out.println("</script>");
			}
	  }
	  
	  return null;
	}
	
	@RequestMapping("emailChange.go")
	public void CheckEmail(UserDTO dto, HttpServletResponse response, Model model, HttpSession session, @RequestParam("id") int id, @RequestParam("emailKey") String key) throws Exception {
		System.out.println("사용자 아이디");
		System.out.println("사용자 이메일"+dto.getUser_email());
		System.out.println("입력키"+key);
		System.out.println("db변한 키"+dto.getMailKey());
		dto.setMailKey(key);
		response.setContentType("text/html; charset=UTF-8");
	      PrintWriter out = response.getWriter();
	      dao.updateMail(dto);
	      if(key.equals(dto.getMailKey())) {
	    	  this.dao.updateMember(dto);
	         out.println("<script>");
	         out.println("alert('이메일 인증이 완료 되었습니다.')");
	         out.println("location.href='userprofile.go'");
	         out.println("</script>");
	         session.removeAttribute("updateDto");
	      }else {
	         out.println("<script>");
	         out.println("alert('이메일 인증번호가 틀렸습니다.')");
	         out.println("history.back()");
	         out.println("</script>");
	      }
	}
	
	
}

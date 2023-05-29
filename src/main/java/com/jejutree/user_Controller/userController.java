package com.jejutree.user_Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.http.HttpRequest;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jejutree.Login.JoinEmailService;
import com.jejutree.kakaoController.kakaoLoginService;
import com.jejutree.plans_model.Plan_participantsDTO;
import com.jejutree.user_model.Temporary_kakao_userDTO;
import com.jejutree.user_model.UserDAO;
import com.jejutree.user_model.UserDTO;

@Controller
public class userController {
	@Autowired
	private UserDAO dao;
	@Autowired
	private kakaoLoginService ks;
	@Autowired
	private JoinEmailService emailService;

	// 로그인 창으로 이동
	@RequestMapping(value = { "/guest_login_page.go", "/login_page.go" })
	public String login(HttpServletRequest request, @RequestParam(value = "share_id", required = false) String share_id,
			Model model) {
		if (request.getServletPath().equals("/login_page.go")) {
			return "login/login";
		} else if (request.getServletPath().equals("/guest_login_page.go")) {
			model.addAttribute("share_id", share_id);

		}
		return "login/login";
	}

	@RequestMapping(value = { "/user_join.go", "/kakaoUser_join.go", "/invitedUser_join.go" })
	public String go_user_join(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "share_id", required = false) String share_id, Model model) throws IOException {

		response.setContentType("text/html; charset=UTF-8");

		PrintWriter out = response.getWriter();
		if (request.getServletPath().equals("/user_join.go")) {
			return "login/user_join";
		} else if (request.getServletPath().equals("/kakaoUser_join.go")) {
			return "login/kakao_user_join";
		} else if (request.getServletPath().equals("/invitedUser_join.go")) {
			model.addAttribute("share_id", share_id);
			return "login/user_join";
		}
		return "MainPage";
	}

	@RequestMapping(value = { "/user_join_ok.go", "/kakao_join_ok.go", "/invitedUser_join_ok.go",
			"invitedKakao_join_ok.go" })
	public void user_join_ok(HttpServletResponse response, UserDTO dto, HttpServletRequest request, HttpSession session,
			@RequestParam(value = "share_id", required = false) String user_share_id) throws Exception {

		int check = 0;
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();

		// 일반 회원가입 요청시
		if (request.getServletPath().equals("/user_join_ok.go")) {

			check = this.emailService.insertUser(dto);

			if (check > 0) {
				// 세션 띄워주기전 기존 카카오 세션 만료 시키기.
				// 새로 로그인한 세션 띄워주기
				session.setAttribute("user_id", dto.getUser_id());
				out.println("<script>");
				out.println("alert('회원가입이 완료 되었습니다.')");
				out.println("window.close()");
				out.println("location.href='MainPage.go'");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('가입 실패')");
				out.println("history.back()");
				out.println("</script>");
			}
			// 카카오 연동계정 회원가입 요청시
		} else if (request.getServletPath().equals("/kakao_join_ok.go")) {
			check = this.dao.insertKakaoUser(dto);
			if (check > 0) {

				dao.updateKakao(dto.getUser_email());
				// 세션 띄워주기전 기존 카카오 세션 만료 시키기.
				// 새로 로그인한 세션 띄워주기
				out.println("<script>");
				out.println("alert('카카오연동계정 회원가입이 완료 되었습니다.')");
				out.println("window.close()");
				out.println("window.opener.location.href='MainPage.go'");
				out.println("</script>");

			} else {
				out.println("<script>");
				out.println("alert('가입 실패')");
				out.println("history.back()");
				out.println("</script>");
			}
			// 공유 화면을 통해 유입된 회원의 회원가입(임시로 미리가입,최초 가입 둘다 해당)
		} else if (request.getServletPath().equals("/invitedKakao_join_ok.go")) {
			// 공유 정보 먼저 넣어 주기.
			Plan_participantsDTO kakaoParticipantdto = new Plan_participantsDTO();
			// 회원 user_id(본인) 아이디 입력
			kakaoParticipantdto.setUser_id(dto.getUser_id());
			// share_id(계획을 초대한 사람의 아이디)
			System.out.println(dto.getUser_id());
			kakaoParticipantdto.setUser_share_id(user_share_id);
			// 카카오 연동 회원가입 insert 문
			check = this.dao.insertKakaoUser(dto);
			if (check > 0) {
				// 성공시 is join 1로 변경
				dao.updateKakao(dto.getUser_email());
				// 세션에 필요한 정보를 업데이트합니다.
				// 공유자 id 정보 먼저 등록
				int share_check = this.dao.insertParticipant(kakaoParticipantdto);
				// 새로 로그인한 세션 띄워주기
				session.setAttribute("user_id", dto.getUser_id());
				out.println("<script>");
				out.println("alert('회원가입이 완료되었습니다.');");
				out.println("window.close();");
				out.println("if (confirm('공유된 일정을 다시 확인하시겠습니까?')) {");
				out.println("window.opener.location.href='plan_list.go?id=" + user_share_id + "';");
				out.println("} else {");
				out.println("  alert('메인 페이지로 이동합니다.');");
				out.println("window.opener.location.href='MainPage.go';");
				out.println("}");
				out.println("</script>");
			}

		} else if (request.getServletPath().equals("invitedUser_join_ok.go")) {
			// 여기에 invited 아이디 파라미터로 받아서 넣어야 할듯.
			Plan_participantsDTO userParticipantdto = new Plan_participantsDTO();
			// 회원 user_id(본인) 아이디 입력
			userParticipantdto.setUser_id(dto.getUser_id());
			// share_id(계획을 초대한 사람의 아이디)
			userParticipantdto.setUser_share_id(user_share_id);

			// 공유자의 정보가 적절히 등록 되면 회원가입 진행.
			check = this.emailService.insertUser(dto);

			if (check > 0) {
				int share_check = this.dao.insertParticipant(userParticipantdto);
				out.println("<script>");
				out.println("alert('회원가입이 완료 되었습니다.')");
				out.println("window.close()");
				out.println("window.opener.location.href='plan_list.go?id=" + user_share_id);
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('가입 실패')");
				out.println("history.back()");
				out.println("</script>");
			}
		}

	}

	// 이메일 기능(일반 회원 가입시 사용하는 이메일 기능)
	@RequestMapping("registerEmail.go")
	public String registerEmail(HttpServletResponse response, UserDTO dto) throws Exception {
		// 인증을 누른 해당 이메일이 포함된 dto가 매개변수로 사용됨.
		dao.updateMailAuth(dto);
		// 해당 이메일에 대한 권한이 1로 바뀌고 권한 여부를 파악하는 요청으로 감.
		return "login/emailcheck";

	}

	// 카카오,일반 로그아웃 기능
	@RequestMapping(value = { "/logout.go", "/normal_logout.go" })
	public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		if (request.getServletPath().equals("/normal_logout.go")) {
			session.invalidate();
			return "redirect:/";
		} else if (request.getServletPath().equals("/logout.go")) {
			HashMap<String, Object> hashMap = (HashMap<String, Object>) session.getAttribute("Kakao_info");
			String access_Token = (String) hashMap.get("kakao_token");
			if (access_Token != null && !"".equals(access_Token)) {
				ks.kakaoLogout(access_Token);
				session.removeAttribute("KakaoInfo");
				session.invalidate();
			} else {
				System.out.println("access_Token is null");
			}
			return "redirect:/";
		}
		return "redirect:/";
	}

	// 일반회원 로그인.
	@RequestMapping(value = { "user_login.go", "invited_user_login.go" })
	public void userLoginok(@RequestParam("user_id") String user_id, @RequestParam("user_pwd") String user_pwd,
			@RequestParam(value = "share_id", required = false) String share_id, HttpSession session,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		// 일반 화면에서 로그인시 요청.
		if (request.getServletPath().equals("/user_login.go")) {
			response.setContentType("text/html; charset=UTF-8");

			PrintWriter out = response.getWriter();
			UserDTO user_dto = dao.getuser(user_id);

			int check = dao.emailAuthFail(user_id);
			if (user_dto == null) {
				out.println("<script>");
				out.println("alert('회원정보 없음~~~')");
				out.println("history.back()");
				out.println("</script>");
			}
			if (user_dto == null && check == 1) {
				System.out.println("로그인 실패");
				out.println("<script>");
				out.println("alert('로그인 실패~~~')");
				out.println("history.back()");
				out.println("</script>");

			} else if (check == 0 && user_dto != null) {
				// 이메일 인증 없이 카카오톡 추가 연동 회원으로 가입 한 경우.
				if (user_dto.getUser_iskakao() == 1) {
					System.out.println("로그인 성공");
					// 기존 세션 있으면 날려 주기.
					request.getSession().invalidate();
					// 세션 띄워주기
					session.setAttribute("user_id", user_dto.getUser_id());
					out.println("<script>");
					out.println("alert('로그인 성공')");
					out.println("location.href='MainPage.go'");
					out.println("</script>");
				} else {
					out.println("<script>");
					out.println("alert('이메일 인증 필요~~~')");
					out.println("history.back()");
					out.println("</script>");
				}
			} else if (!user_dto.getUser_pwd().equals(user_pwd) && check == 1 && user_dto != null) {
				out.println("<script>");
				out.println("alert('회원정보 틀림~~~')");
				out.println("history.back()");
				out.println("</script>");

			} else {
				System.out.println("로그인 성공");
				// 기존 세션 있으면 날려 주기.
				session.setAttribute("user_id", user_dto.getUser_id());
				out.println("<script>");
				out.println("alert('로그인 성공')");
				out.println("location.href='MainPage.go'");
				out.println("</script>");
			}
			// 카카오톡 공유 초대를 통해 유입된 로그인 요청.
		} else if (request.getServletPath().equals("/invited_user_login.go")) {
			response.setContentType("text/html; charset=UTF-8");
			// 왜인지 모르겠지만 ,가 자꾸 찍혀 들어가서 제거 했습니다.
			String user_share_id = share_id.replace(",", "");
			PrintWriter out = response.getWriter();
			// 해당 유저 아이디 조회
			UserDTO user_dto = dao.getuser(user_id);
			System.out.println(user_dto.getUser_id());
			System.out.println(user_id);
			// 해당 유저의 이메일 인증 여부 확인.
			int check = dao.emailAuthFail(user_id);
			if (user_dto == null) {
				out.println("<script>");
				out.println("alert('회원정보 없음~~~')");
				out.println("history.back()");
				out.println("</script>");
			}
			if (user_dto == null && check == 1) {
				System.out.println("로그인 실패");
				out.println("<script>");
				out.println("alert('로그인 실패~~~')");
				out.println("history.back()");
				out.println("</script>");

			} else if (check == 0 && user_dto != null) {
				// 이메일 인증 없이 카카오톡 추가 연동 회원으로 가입 한 경우.
				if (user_dto.getUser_iskakao() == 1) {
					
					System.out.println(user_share_id);
					// 기본키 유효성 체크.
					HashMap<String, String> paramMap = new HashMap<String, String>();
					paramMap.put("user_id", user_dto.getUser_id());
					paramMap.put("user_share_id", user_share_id);
					int primary_check = this.dao.selfshareCheck(paramMap);
					// 공유 정보 등록 해주기.
					System.out.println(primary_check);
					if (primary_check == 0 && !user_share_id.equals(user_id)) {
						Plan_participantsDTO normalParticipantdto = new Plan_participantsDTO();
						// 회원 user_id(본인) 아이디 입력
						normalParticipantdto.setUser_id(user_dto.getUser_id());
						// share_id(계획을 초대한 사람의 아이디)
						normalParticipantdto.setUser_share_id(user_share_id);
						// 공유 여행 초대자 정보 등록
						int share_check = this.dao.insertParticipant(normalParticipantdto);
					}
					// 기존 세션 있으면 날려 주기.
					request.getSession().invalidate();
					// 세션 띄워주기
					session.setAttribute("user_id", user_dto.getUser_id());
					out.println("<script>");
					out.println("if (confirm('공유된 일정을 다시 확인 하시겠습니까?')) {");
					out.println("  location.href='plan_list.go?id=" + user_share_id + "';");
					out.println("} else {");
					out.println("  alert('메인 페이지로 이동합니다.');");
					out.println("  location.href='MainPage.go';");
					out.println("}");
					out.println("</script>");
				} else {
					out.println("<script>");
					out.println("alert('이메일 인증 필요~~~')");
					out.println("history.back()");
					out.println("</script>");
				}
			} else if (!user_dto.getUser_pwd().equals(user_pwd) && check == 1 && user_dto != null) {
				out.println("<script>");
				out.println("alert('회원정보 틀림~~~')");
				out.println("history.back()");
				out.println("</script>");

			} else {
				// 기본키 유효성 체크.
				HashMap<String, String> paramMap = new HashMap<String, String>();
				paramMap.put("user_id", user_dto.getUser_id());
				paramMap.put("user_share_id", user_share_id);
				int primary_check = this.dao.selfshareCheck(paramMap);
				// 공유 정보 등록 해주기.
				if (primary_check == 0 && !user_share_id.equals(user_id)) {
					Plan_participantsDTO normalParticipantdto = new Plan_participantsDTO();
					// 회원 user_id(본인) 아이디 입력
					normalParticipantdto.setUser_id(user_dto.getUser_id());
					// share_id(계획을 초대한 사람의 아이디)
					normalParticipantdto.setUser_share_id(user_share_id);
					// 공유 여행 초대자 정보 등록
					int share_check = this.dao.insertParticipant(normalParticipantdto);
				}
				// 기존 세션 있으면 날려 주기.
				session.setAttribute("user_id", user_dto.getUser_id());
				out.println("<script>");
				out.println("if (confirm('공유된 일정을 다시 확인 하시겠습니까?')) {");
				out.println("  location.href='plan_list.go?id=" + user_share_id + "';");
				out.println("} else {");
				out.println("  alert('메인 페이지로 이동합니다.');");
				out.println("  location.href='MainPage.go';");
				out.println("}");
				out.println("</script>");
			}
		}

	}

	// 공유 기능 이용시 카카오 연계 정회원,정규회원,임시 회원을 구분 하는 기능
	@RequestMapping("iskakao_check.go")
	public void iskakaoCheck(@RequestParam("user_email") String user_email, HttpServletResponse response)
			throws IOException {
		int result = 0;
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		Temporary_kakao_userDTO dto = dao.kakao_userInfo(user_email);
		// 해당 이메일과 일치하는 임시등록 유저 조회
		if (dto != null) {
			// 해당 유저의 정회원 가입여부 확인(임시회원 테이블에 user_join이 1일시 정규 회원으로 전환된 회원)
			if (dto.getUser_join() == 1) {
				result = 1;
				out.print(result);
				// 해당 유저의 정회원 가입여부 확인(임시회원 테이블에 user_join이 0인 상태 임시회원 상태)
			} else {
				result = -1;
				out.print(result);
			}
			// 정규 회원도 아닌 상태 로그인 필요
		} else {
			out.print(result);
		}
	}

	@RequestMapping("kakao_user_idCheck.go")
	public void kakaojoin_idcheck(@RequestParam("user_id") String user_id, HttpServletResponse response)
			throws IOException {
		int result = 0;

		response.setContentType("text/html; charset=UTF-8");

		PrintWriter out = response.getWriter();

		UserDTO dto = dao.getuser(user_id);

		if (dto != null) {
			result = -1;
			out.print(result);
		} else {
			result = 1;
			out.print(result);
		}

	}

	@RequestMapping("deleteUser.go")
	public void deleteUser(@RequestParam("id") int id, HttpServletResponse response) throws IOException {

		response.setContentType("text/html; charset=UTF-8");

		PrintWriter out = response.getWriter();
		// 카카오 연동회원 여부 판별 위한 유저 정보
		UserDTO dto = dao.getuserById(id);

		// 카카오 연동 회원일 경우.
		if (dto.getUser_iskakao() == 1) {

			// temporary 테이블의 이메일 조회.
			String user_email = dto.getUser_email();
			// 해당 이메일의 temporary테이블의 유저 정보 삭제
			dao.deleteTemporaryUser(user_email);
			// 이후에 user 테이블의 해당 id값에 해당하는 user 정보 삭제.
			int check = dao.deleteUser(id);
			// 성공 여부에 따른 결과 출력

			if (check > 0) {

				// 삭제한 id 기준으로 -1씩 시퀀스 정렬
				dao.updateSequence(id);
				out.println("<script>");
				out.println("alert('회원탈퇴 되었습니다.')");
				out.println("location.href='normal_logout.go'");
				out.println("</script>");
			} else {

				out.println("<script>");
				out.println("alert('탈퇴 실패~~~')");
				out.println("history.back()");
				out.println("</script>");
			}
			// 카카오 연동 회원이 아닌 일반회원의 탈퇴
		} else {
			int check = dao.deleteUser(id);

			if (check > 0) {
				// 삭제한 id 기준으로 -1씩 시퀀스 정렬
				dao.updateSequence(id);
				out.println("<script>");
				out.println("alert('회원탈퇴 되었습니다.')");
				out.println("location.href='normal_logout.go'");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('탈퇴 실패~~~')");
				out.println("history.back()");
				out.println("</script>");
			}
		}
	}

	@RequestMapping("/deletekakaoUser.go")
	public void deletekakaoUser(HttpServletResponse response, HttpSession session,
			@RequestParam("access_Token") String access_token, @RequestParam("user_email") String user_email)
			throws IOException {
		// HashMap<String, Object> hashmap = (HashMap<String, Object>)
		// session.getAttribute("Kakao_info");
		// String access_token = (String) hashmap.get("kakao_token");
		// String user_email = (String) hashmap.get("kakao_id");
		System.out.println("토큰이 받아졌나?");
		System.out.println(access_token);
		response.setContentType("text/html; charset=UTF-8");

		PrintWriter out = response.getWriter();

		int check = 0;
		int double_check = 0;
		// 카카오 계정과 연결 해제 시켜주는 메서드 ( 추가로그인시 동의항목 새로 체크해야함)
		String result = ks.KaKaoUnlink(access_token);
		// 요청에 대한 응답 성공일시
		if (result != null) {
			// temporary테이블 삭제.(먼저 해주고 추가로 정회원 연동 여부 보고
			check = dao.deleteTemporaryUser(user_email);
			// 해당 이메일의 user테이블 정보 조회
			UserDTO dto = dao.getkakaouser(user_email);

			// 요청 이메일을 가진 정회원이 존재 할 경우.(정회원연동 회원 인 경우)
			if (dto != null) {
				// 시퀀스 작업을 위한 해당 유저의 id 값 조회
				int id = dto.getId();

				// 정회원 테이블 삭제.
				double_check = dao.deleteKakaoUser(user_email);

				// 두 테이블 모두 삭제가 완료 된 경우.
				if (double_check > 0) {
					// 정회원 테이블 시퀀스 작업
					dao.updateSequence(id);
					out.println("<script>");
					out.println("alert('회원탈퇴 되었습니다.')");
					out.println("location.href='normal_logout.go'");
					out.println("</script>");
					// delete 오류시 어느 테이블 문제인지 파악용.
					System.out.println(check);

					System.out.println(double_check);
				} else {
					out.println("<script>");
					out.println("alert('탈퇴 실패~~~')");
					out.println("history.back()");
					out.println("</script>");
				}
			} else {
				out.println("<script>");
				out.println("alert('회원탈퇴 되었습니다.')");
				out.println("location.href='normal_logout.go'");
				out.println("</script>");
			}
			// 카카오 요청 실패 한 경우.
		} else {
			out.println("<script>");
			out.println("alert('요청 실패~~~')");
			out.println("history.back()");
			out.println("</script>");
		}
	}

}
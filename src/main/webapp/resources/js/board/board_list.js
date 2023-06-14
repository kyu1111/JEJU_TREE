function planlistcheck() {
  let writer = '${board_content.writer}';
  let kakao_id = '${kakao_id}';
  let normal_session = '${normal_session}';
  let user_id = '';

  if (kakao_id != '') {
    user_id = kakao_id;
  } else if (normal_session != '') {
    user_id = normal_session;
  }

  $.ajax({
    url: "planlistCheck.go",
    type: "POST",
    data: {
      user_id: user_id
    },
    success: function(result) {
      // 해당 아이디로 저장된 일정리스트가 있는 경우.
      if (result == 1) {
        // 글작성
        location.href = 'board_write.go';
      }
      // 해당 아이디로 저장된 일정리스트가 없는 경우.
      else if (result == -1) {
        alert('보유하신 일정 리스트가 없습니다. 일정을 먼저 추가해 주세요.');
      }
    },
    error: function(error) {
      alert("통신 오류.");
    }
  });
}
/**
 * 
 */
let parameter_id = '';
	if(uid != ''){
	  parameter_id = uid;
	}else if(kid != ''){
	  parameter_id = kid;
	}  
console.log(parameter_id);
//기존의 로그인 했던 카카오 유저의 친구목록 찌끄래기를 날려주는 메서드
Kakao.init("ddee3a2c7a119e1824460c4c13d5fd83");
try {
  function sendLink() {
  
  	  


	let is_guest = 'y';  
    Kakao.Link.sendDefault({
      objectType: 'feed',
      content: {
        title: 'JejuTree일정에 당신을 초대합니다.',
        description: parameter_id + '님이 일정에 당신을 초대했어요',
        imageUrl: 'https://ifh.cc/g/P8cvPg.png',
        link: {
          webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
        },
      },
      buttons: [
        {
          title: '일정확인하기',
          link: {
            webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
          },
        },
      ],
    });
  }

  window.kakaoDemoCallback && window.kakaoDemoCallback();
} catch (e) {
  window.kakaoDemoException && window.kakaoDemoException(e);
}
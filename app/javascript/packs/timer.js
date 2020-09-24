
var SetTime = 30;		// 최초 설정 시간(기본 : 초)

export function msg_time() {	// 1초씩 카운트

    m = Math.floor(SetTime % 60) + "초";	// 남은 시간 계산

    var msg = "<font color='red'>" + m + "</font> 후에 페이지가 새로고침됩니다.";

    document.all.ViewTimer.innerHTML = msg;		// div 영역에 보여줌

    SetTime--;					// 1초씩 감소

    if (SetTime < 0) {			// 시간이 종료 되었으면..
        location.reload();
    }

}

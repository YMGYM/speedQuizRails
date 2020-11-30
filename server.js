const server = require('http').createServer();

const io = require('socket.io')(server);

server.listen(4000);
//var redis = require("socket.io-redis");
//var redisServer = require('redis');
var csv = require('csv-parser');
//var client = redisServer.createClient();
var fs = require('fs');
//var socketRoom = [];
//redis와 연결

// io.adapter(redis({
// //   host: "3.88.111.248", //rails와 같게
// //   port: "6379" //rails와 같게
// // }));
//var flag = false;

var user = [];
var indexNum = 0;
var question;
var keyword = [];
var nowSong;
var timeLimit;

var roomId;
var rowArr = [];
var answer = [];
var keyword = [];
var url = [];
var startTime = [];
var roomIdArray = [];

io.sockets.on("connection", function(socket) {
  var score = 0;

  socket.on('roomInfo', (data) => {
    //roomId = data;
    socket.join(data);
  });

  //async function socketFunction(callback){
    //io.emit('question');
  function socketFunction(callback){
    //await new Promise(resolve => {
      socket.on('question', (data) => {
        //resolve(data);

        roomId = data.roomId;

        switch(data.questionInfo){
          case "인싸 감성! 당신의 K-POP 걸그룹 지식은?(난이도 상)":
            question = './Questions/girlIdol.csv';
            break;
          case "추억을 불러 일으키는 게임들.. (난이도 중)":
            question = './Questions/games.csv';
            break;
          case "아는듯 모르는듯... 긴가민가한 광고들 (난이도 하)":
            question = './Questions/advertise.csv';
            break;
          case "당신이 최고의 오타쿠! 일본 애니메이션 OST들 (난이도 중)":
            question = './Questions/animesong.csv';
            break;
          case "도전! 한국 가요 마스터! (난이도 중)":
            question = './Questions/Kpop.csv';
            break;
          case "한국어 애니메이션 OST로 떠나는 추억여행 (난이도 중)":
            question = './Questions/koreanAnimation.csv';
            break;
          case "드라마 OST로 안방극장 탐험(난이도 중)":
            question = './Questions/koreanDrama.csv';
            break;
        } //접속하면 레일즈 -> HTML -> 노드로 현재 방 문제 정보 받아서 question에 넣음

        rowArr = [];
        fs.createReadStream(question)
          .pipe(csv())
          .on('data', (row) => {
            rowArr.push(row);
          })//해당 question에 해당하는 csv를 읽고 배열에 넣음
          .on('end', () => {
            shuffle(rowArr); //csv를 읽은 배열을 섞음
            if(roomIdArray.length === 0){
              roomIdArray.push({id: data.roomId});
              for(var i in rowArr) {
                answer.push({answer: rowArr[i].answer});
                keyword.push({keyword: rowArr[i].answerKeyword});
                url.push(rowArr[i].src);
                startTime.push(rowArr[i].startTime);
              }//각각의 key값을 배열로 만들어 넣음
            }else if(roomIdArray.findIndex(i => i.id === data.roomId) === -1){
              answer = [];
              keyword = [];
              url = [];
              startTime = [];
              roomIdArray.push({id: data.roomId});
              for(var i in rowArr) {
                answer.push({answer: rowArr[i].answer});
                keyword.push({keyword: rowArr[i].answerKeyword});
                url.push(rowArr[i].src);
                startTime.push(rowArr[i].startTime);
              }//각각의 key값을 배열로 만들어 넣음
            }

            socket.join(data.roomId);
            callback();
        });
      });
//    });
  }

  socketFunction(async() => {
    await io.to(roomId).emit('answer', {
      url: url,
      startTime: startTime,
      keyword: keyword,
      answer: answer
    });//'answer'이벤트 호출
  });

  socket.on('sendUserWaiting', (data) => {
    io.to(data.roomId).emit('chat', {
      value: data.value,
      nick: data.nick
    });
  });

  socket.on('grating', (data) => {
    io.to(data.roomId).emit('grating', data.nick);
  });

  socket.on('joinRoom', (data) => {
    console.log(data, "조인룸");
    socket.join(data.roomId);
    io.to(data.roomId).emit('joinRoom', `${data.nick}님이 입장하셨습니다.`);
  });

  socket.on('playing', (data) => {
    io.to(data.roomId).emit('playing');
  });

  socket.on("sendUser", (data) => {
    var flag = false;
    indexNum = data.i; //현재 index번호
    var key = data.keyword[indexNum].keyword.toString();//키워드 내용 오브젝트->스트링화
    var keyArray = [];
    if(key.indexOf(' ') !== -1){
      keyArray = key.split(' ');
    } //중간에 공백이 있는 경우에 공백을 중심으로 문자열을 자르고 배열에 넣음
    if(data.answer[indexNum].answer === data.value){
      //정답이랑 같거나, 키워드랑 같거나, 키워드의 배열에 채팅 값이 있으면 실행
      flag = true; //클라이언트에 넘길 flag값
      score += 10; //스코어를 +10
    }else if(keyArray.length !== 0 && data.value !== ''){
      keyArray.forEach((i, index) => {
        if(i === data.value){
          flag = true; //클라이언트에 넘길 flag값
          score += 10; //스코어를 +10
        }
      });
    }else if(key !== '' && data.value !== '' && key.indexOf(' ') === -1){
      if(key === data.value) {
        flag = true; //클라이언트에 넘길 flag값
        score += 10; //스코어를 +10
      }
    }
    else{
      flag = false;
    }
    io.to(data.roomId).emit("userInfo", {
      value: data.value,
      score: score,
      flag: flag,
      nick: data.nick,
      id: data.id
    });//'userInfo'이벤트 호출 -> 각종 값 넘겨줌
  });

  socket.on('disconnect', () => {
    //디스커넥트
  });
});


function shuffle(array) {
  for(var i = array.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
} //배열 안의 값을 섞는 함수

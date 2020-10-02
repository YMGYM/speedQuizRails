var io = require("socket.io").listen(4000);
var redis = require("socket.io-redis");
var redisServer = require('redis');
var csv = require('csv-parser');
var client = redisServer.createClient();
var fs = require('fs');
//redis와 연결
io.adapter(redis({
  host: "localhost", //rails와 같게
  port: "6379" //rails와 같게
}));
var flag = false;
var user = [];
var index = 0;

var answer = [];
var url = [];
var startTime = [];
var question;

/*
client.keys('*', (err, keys) => {
  for (const [key, value] of Object.entries(keys)) {
    client.hgetall(`${value}`, async(err, ans) => {
      if(ans.src !== undefined){
        await queArr.push(ans);
      }
    });
  }
});*/

io.sockets.on("connection", function(socket) {
  var score = 0;

  socket.on('question', (data) => {
    switch(data){
      case "인싸 감성! 당신의 K-POP 걸그룹  지식은?(난이도 상)":
        question = './Questions/girlsIdol.csv';
        break;
      case "추억을 불러 일으키는 게임들.. (난이도 중)":
        question = './Questions/games.csv';
        break;
      case "아는듯 모르는... 긴가민가한 광고들 (난이도 하)":
        question = './Questions/advertise.csv';
        break;
      case "당신이 최고의 오타쿠! 일본 애니메이션 OST들 (난이도 중)":
        question = './Questions/animesong.csv';
        break;
    }
    fs.createReadStream(question)
      .pipe(csv())
      .on('data', (row) => {
        answer.push({answer: row.answer, keyword: row.answerKeyword});
        url.push(row.src);
        startTime.push(row.startTime);
      })
      .on('end', () => {
        console.log('CSV file successfully processed');
        io.emit('answer', {
          url: url,
          startTime: startTime
        });
      });
  });

  socket.on("sendUser", (data) => {
    index = data.i;
    console.log(index);
    if(answer[index].answer === data.value || answer[index].keyword === data.value){
      flag = true;
      score += 10;
    }else{
      flag = false;
    }
    io.emit("userInfo", {
      //email: data.email,
      value: data.value,
      score: score,
      flag: flag,
      nick: data.nick,
      id: data.id
    });
  });
});

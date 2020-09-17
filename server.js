var io = require("socket.io").listen(4000);
var redis = require("socket.io-redis");
var redisServer = require('redis');
var client = redisServer.createClient();
//redis와 연결
var answer = null;
io.adapter(redis({
  host: "localhost", //rails와 같게
  port: "6379" //rails와 같게
}));

client.get('answer', (err, ans) => {
  answer = ans;
});

io.sockets.on("connection", function(socket) {
  socket.on("sendUser", (data) => {
    //redisdb와 data.value비교,
    //만약 맞으면 score추가, 다시 보냄
    client.hmset('chat', 'email', data.email, 'chat', data.value);
    client.hgetall('chat', (err, obj) => {
      if(answer === obj.chat){
        //현재 정답은 '밀리시타최고'로 등록해놓음.
        console.log('정답입니다');
        //이거 대신에 스코어가 올라가도 되고 맞췄을 때 보상은 생각해둘 것.
      }
    });
    io.emit("userInfo", data);
  });
});

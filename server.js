var io = require("socket.io").listen(4000);
var redis = require("socket.io-redis");
var redisServer = require('redis');
var client = redisServer.createClient();
//redis와 연결
io.adapter(redis({
  host: "localhost", //rails와 같게
  port: "6379" //rails와 같게
}));
var flag = false;
var kotae = '밀리시타최고';
var queArr = [];

client.keys('*', (err, keys) => {
  for (const [key, value] of Object.entries(keys)) {
    client.hgetall(`${value}`, async(err, ans) => {
      if(ans.src !== undefined){
        await queArr.push(ans);
        console.log(ans);
      }
    });
  }
});

io.sockets.on("connection", function(socket) {
  io.emit('answer', {
    queArr: queArr
  });
  socket.on("sendUser", (data) => {
    //redisdb와 data.value비교,
    //만약 맞으면 score추가, 다시 보냄
    /*
    client.hmset('chat', 'email', data.email, 'chat', data.value);
    client.hgetall('chat', async(err, obj) => {
      if(kotae === obj.chat){
        //현재 정답은 '밀리시타최고'로 등록해놓음.
        console.log('정답입니다');
        flag = await true;
        //이거 대신에 스코어가 올라가도 되고 맞췄을 때 보상은 생각해둘 것.
      }else{
        flag = await false;
      }
    });*/
    if(kotae === data.value){
      flag = true;
    }else{
      flag = false;
    }
    io.emit("userInfo", {
      //email: data.email,
      value: data.value,
      score: data.score,
      flag: flag,
      nick: data.nick
    });
  });
});

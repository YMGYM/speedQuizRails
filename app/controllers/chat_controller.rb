#
# class ChatController < ApplicationController
#   before_action :authenticate_user!, except: :main
#
#   def index
#     @emitter = SocketIO::Emitter.new(
#       redis: Redis.new(
#         :host => '3.88.111.248', #보통은 localhost
#         :port => '6379' #redis 의 Port번호. redis-cli의 포트번호 적으면 됨.
#       )
#     )
# 		#레일즈에서 Socket.io를 사용하는 경우
#     #@emitter.emit("server to client", {value:'레일즈에서 넘어왔어용'})
#     #render :text => 'OK'
#   end
# end

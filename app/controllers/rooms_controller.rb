class RoomsController < ApplicationController
  before_action :authenticate_user!, except: :main
  before_action :exit_chk, except: [:show, :create, :edit, :update, :main, :startGame, :result]

  def main

  end

  def index
    @room = Room.all.reverse
  end

  def new
    @room = Room.new
  end

  def create
    question_id =  params.require(:room).permit(:question)['question'].to_i
    question = Question.find(question_id)

    room = question.rooms.new(rooms_params)
    room.nowPlaying = false

    if room.isSecret == false
      room.password = "ThisIsaDummy"
    end

    if room.save
      room.players.create(user_id: current_user.id, isMaster: true, isReady: true)
      session[:lastroom] = room.id
      redirect_to room
    else
      redirect_to new_room_path, flash: {alert: "에러 발생! 무언가 잘못되었어요"}
    end

  end

  def show
    @room = Room.find(params[:id])

    if (@room.nowPlaying == true) && (!current_user.player)
      redirect_to rooms_path, flash: {alert: "게임중인 방에는 들어갈 수 없어요"}
      return
    end

    if !current_user.player
      @room.players.create(user_id: current_user.id)
    end

    @user = Player.find_by_user_id(current_user.id)
    room_authenticate
    session[:lastroom] = @room.id

    @emitter = SocketIO::Emitter.new(
      redis: Redis.new(
        :host => '34.67.110.223',
        # :host => 'localhost',
        :port => '6379'
      )
    )

    @players = @room.players.map {|m| m.user.id}
  end

  def edit
    if (current_user.room.id.to_s == params[:id] ) && (current_user.player.isMaster)
      @room = Room.find(params[:id])
    else
      redirect_to current_user.room, flash: {alert: "방장만 방 정보를 수정할 수 있어요"}
    end
  end

  def update
    room = Room.find(params[:id])
    room.update(rooms_params)
    question_id =  params.require(:room).permit(:question)['question'].to_i
    question = Question.find(question_id)
    room.update(question: question)

    if room.save
      session[:lastroom] = room.id
      redirect_to room
    else
      redirect_to new_room_path, flash: {alert: "에러 발생! 무언가 잘못되었어요"}
    end
  end

  def destroy

  end

  def secret
    @room = Room.find(params[:id])
  end

  def passCheck
    @room = Room.find(params[:id])
    chk = @room.authenticate(params[:roomPassword])
    if chk
      session[:lastroom] = @room.id
      redirect_to room_path(@room)
    else
      redirect_to '/secret/' + @room.id.to_s, flash: {alert: "비밀번호가 다릅니다!"}
    end
  end

  def search
    begin
      room = Room.find(params[:q])
    rescue ActiveRecord::RecordNotFound
      redirect_to rooms_path, flash: {alert: "없는 번호입니다!"}
    else
      redirect_to room
    end
  end

  def roomquit
    player = current_user.player
    room = player.room
    num_person = room.players.count

    if num_person == 1
      room.destroy
      player.destroy
      redirect_to rooms_path
      return
    end

    if player.isMaster == true
      next_user = Room.find(room.id).players.second
      next_user.update(isMaster: true)
    end
    player.destroy



    redirect_to rooms_path
  end

  def help

  end

  def startGame
    room = current_user.room
    # ------------ 솔로 플레잉 방지 (디버깅 시 오프)
    if room.players.size == 1
      redirect_to room, flash: {alert: "혼자서는 게임할 수 없어요!"}
      return
    end
    # -------------------------------
    stat = !room.nowPlaying
    room.update(nowPlaying: stat)
    redirect_to room
  end

  def reloadGame
    room = current_user.room
    redirect_to room
  end

  def result
    if current_user.player.isMaster == true
      current_user.room.update(nowPlaying: false)
    end
    @room = params[:id]
    @winner = User.find(params[:winner_id])
  end

  private
  def rooms_params
    params.require(:room).permit(:title, :questionNumber, :limitTime, :isSecret, :password)
  end

  def room_authenticate
    if (@room.isSecret == true) and (session[:lastroom] != @room.id)
      redirect_to '/secret/' + params[:id]
      return
    end

  end

  def exit_chk
    if current_user.room && current_user.player
      if current_user.room.players.count <= 1 # 혼자 있었으면
        current_user.room.destroy
      else
        if current_user.player.isMaster == true
          next_user = Room.find(current_user.room.id).players.second
          next_user.update(isMaster: true)
        end
        current_user.player.destroy
      end
    end
  end

end

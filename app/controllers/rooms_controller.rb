class RoomsController < ApplicationController
  before_action :authenticate_user!, except: :main

  def main

  end

  def index
    @room = Room.all.reverse
  end

  def new
    @room = Room.new
  end

  def create
    room = Room.new(rooms_params)
    room.nowPlaying = false

    if room.isSecret == false
      room.password = "ThisIsaDummy"
    end

    if room.save
      session[:lastroom] = room.id
      redirect_to room
    else
      redirect_to new_room_path, flash: {alert: "에러 발생! 무언가 잘못되었어요"}
    end

  end

  def show
    @room = Room.find(params[:id])
    room_authenticate

    session[:lastroom] = @room.id
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    room = Room.find(params[:id])
    room.update(rooms_params)

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

  private
  def rooms_params
    params.require(:room).permit(:title, :question, :questionNumber, :limitTime, :isSecret, :password)
  end

  def room_authenticate
    if (@room.isSecret == true) and (session[:lastroom] != @room.id)
      redirect_to '/secret/' + params[:id]
    end


  end

end

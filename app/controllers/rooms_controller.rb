class RoomsController < ApplicationController
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
    room.save
    if room.save
      redirect_to room
    else
      # render 'form'
    end

  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    room = Room.find(params[:id])
    room.update(rooms_params)

    if room.save
      redirect_to room
    else
      render 'form'
    end
  end

  def destroy

  end

  def secret
    @room_id = params[:id]
  end

  # def passCheck
  #   redirect_to room_path(id: params[:room_id])
  # end

  private
  def rooms_params
    params.require(:room).permit(:title, :question, :questionNumber, :limitTime, :isSecret, :password)
  end
end

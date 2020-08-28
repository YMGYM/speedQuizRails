class RoomsController < ApplicationController
  def main

  end

  def index
    @room = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    room  = Room.new(rooms_params)
    room.nowPlaying = false

    if room.save
      redirect_to room
    end

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
  def rooms_params
    params.require(:room).permit(:title, :question, :questionNumber, :limitTime, :isSecret, :password)
  end
end

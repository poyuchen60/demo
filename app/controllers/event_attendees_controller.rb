class EventAttendeesController < ApplicationController

  before_action :set_event

  def index
    @attendees = @event.attendees
  end

  def show
    @attendee = @event.attendees.find( params[:id] )
  end

  def new
    @attendee = @event.attendees.build
  end

  def create
    @attendee = @event.attendees.build( attendee_param )

    if @attendee.save
      redirect_to event_attendees_path
    else
      render action: :new
    end
  end

  def destroy
    @attendee = @event.attendees.find( params[:id] )

    @attendee.destroy

    redirect_to event_attendees_path
  end

  def edit
    @attendee = @event.attendees.find( params[:id] )
  end

  def update
    @attendee = @event.attendees.find( params[:id] )

    if @attendee.update(attendee_param)
      redirect_to event_attendees_path
    else
      render action: :edit
    end
  end


  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def attendee_param
    params.require(:attendee).permit(:name)
  end

end

class EventsController < ApplicationController
  
  before_action :set_event, only: [:show, :destroy, :edit, :update]
  
  def index
    @events = Event.page(params[:page]).per(10)
    
    respond_to do |format|
      format.html
      format.xml { render xml: @events.to_xml }
      format.json { render json: @events }
      format.atom { @feed_title = "My event list" }
    end
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "新增成功"
      redirect_to events_path
    else
      render action: :new
    end
  end
  
  def show
    respond_to do |format|
      format.html {@page_title = @event.name}
      format.xml
      format.json {render json: {id: @event.id, name: @event.name, created_time: @event.created_at}}
    end
  end
  
  def edit
  end
  
  def update
    if @event.update(event_params)
      flash[:notice] = "編輯成功"
      redirect_to event_path(@event)
    else
      render action: :edit
    end
  end
  
  def destroy
    @event.destroy
    flash[:alert] = "刪除成功"
    redirect_to events_path
  end
  
  private
  
  def event_params
    params.require(:event).permit(:name, :description, :category_id,
                                  group_ids: [])
  end
  
  def set_event
    @event = Event.find(params[:id])
  end
  
end

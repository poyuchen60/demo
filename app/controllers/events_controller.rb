class EventsController < ApplicationController
  
  before_action :set_event, only: [:show, :destroy, :edit, :update, :dashboard]
  
  def dashboard
  end

  def bulk_update
    ids = Array(params[:ids])
    events = ids.map{|id| Event.find_by_id(id)}.compact

    if params[:commit] == "Delete"
      events.each {|e| e.destroy}
    elsif params[:commit] == "Publish"
      events.each {|e| e.update status: "public"}
    elsif params[:commit] == "Draft"
      events.each {|e| e.update status: "private"}
    end
      
    redirect_to :back
  end

  def latest
    @events = Event.order("id DESC").limit(3)
  end

  def index
    prepare_variable_for_index_template
    
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

  def prepare_variable_for_index_template
    if params[:keyword]
      @events = Event.where( [ "name like ?", "%#{params[:keyword]}%" ] )
    else
      @events = Event.all
    end

    if params[:order]
      sort_by = params[:order] == "name" ? "name" : "id"
      @events = @events.order(sort_by)
    end


    @events = @events.page(params[:page]).per(5)
  end
  
  def event_params
    params.require(:event).permit(:name, :description, :category_id, :status,
                                  group_ids: [])
  end
  
  def set_event
    @event = Event.find(params[:id])
  end
  
end

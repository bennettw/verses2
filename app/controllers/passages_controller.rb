class PassagesController < ApplicationController
  before_filter :require_user

  # GET /passages
  # GET /passages.json
  def index
    @passages = Passage.where :user_id => current_user.id
    @range = :all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @passages }
    end
  end

  def thisweek
    @one_week_ago = 1.week.ago.to_date
    @passages = Passage.where("discovery >= :discovery AND user_id = :user_id", 
                              :discovery => @one_week_ago, 
                              :user_id => current_user.id) 
    @range = :thisweek

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @passages }
    end
  end

  def thismonth
    @one_month_ago = 1.month.ago.to_date
    @passages = Passage.where("discovery >= :discovery AND user_id = :user_id", 
                              :discovery => @one_month_ago,
                              :user_id => current_user.id) 
    @range = :thismonth

    respond_to do |format|
      format.html { render "index" }
      format.json { render json: @passages }
    end
  end

  # GET /passages/1
  # GET /passages/1.json
  def show
    @passage = Passage.find(params[:id])
    
    unless @passage.belongs_to_user(current_user)
      #flash[:notice] = "The passage could not be found."
      raise ActionController::RoutingError.new('The passage could not be found.')
      #return false
    end

    @passage.fetch unless @passage.text  
    @passage_text = @passage.text
    
    # @verses = @passage.verses

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @passage }
    end
  end

  # GET /passages/new
  # GET /passages/new.json
  def new
    @passage = Passage.new
    @passage.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @passage }
    end
  end

  # GET /passages/1/edit
  def edit
    @passage = Passage.find(params[:id])
  end

  # POST /passages
  # POST /passages.json
  def create
    @passage = Passage.new(params[:passage])
    @passage.user_id = current_user.id

    respond_to do |format|
      if @passage.save
        format.html { redirect_to @passage, notice: 'Passage was successfully created.' }
        format.json { render json: @passage, status: :created, location: @passage }
      else
        format.html { render action: "new" }
        format.json { render json: @passage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /passages/1
  # PUT /passages/1.json
  def update
    @passage = Passage.find(params[:id])

    respond_to do |format|
      if @passage.update_attributes(params[:passage])
        format.html { redirect_to @passage, notice: 'Passage was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @passage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passages/1
  # DELETE /passages/1.json
  def destroy
    @passage = Passage.find(params[:id])
    @passage.destroy

    respond_to do |format|
      format.html { redirect_to passages_url }
      format.json { head :ok }
    end
  end
end

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = scope.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    command = Users::Commands::Create.new(user_params)

    respond_to do |format|
      if command.valid?
        created = command.call
        @user = created.aggregate

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        @user.errors.merge!(command.errors)

        format.html { render :new }
        format.json { render json: command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    command = Users::Commands::Update.new(user_params.merge(record_id: @user.id))

    respond_to do |format|
      if command.valid?
        updated = command.call
        @user = updated.aggregate

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        @user.errors.merge!(command.errors)

        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    command = Users::Commands::Destroy.new(record_id: @user.id)
    command.call

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def scope
      User.active
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = scope.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :active, :description)
    end
end

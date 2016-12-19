class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		response = HTTParty.get('http://comicvine.gamespot.com/api/characters/?api_key=88924f96eb1b6691dcb1f598483f6dde3febae45&limit=5&format=json')
		@avatar = []
		body = JSON.parse(response.body)
		body["result"].each do |x|
			@avatar << x['image']['icon_url']
		end
		@user = User.new
	end

	def create
		user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			redirect_to user_path(@user), notice: "Signed up Successfully"
		else
			flash.now[:errors] = @user.errors.full_messages
			render :new
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
		if @user.update(user_params)
			redirect_to @user, notice: "Account updated"
		else
			flash.now[:errors] = @user.errors.full_messages
			render :edit
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		session[:user_id] = nil
		redirect_to root_url, alert: "Account deleted"
	end
end

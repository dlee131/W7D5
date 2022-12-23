class UsersController < ApplicationController

    before_action :require_logged_out, only: [:new,:create]
    before_action :require_logged_in, only: [:show]
    

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)
       if 
        user.save
        login!(@user)
        redirect_to user_url(@user)
       else
        flash.now[:errors] = @user.errors.all_messages
        render :new
       end
    end

    def show
        @user = User.find(params[:id])
        render :show
    end

    def user_params
        params.require(:user).permit(:username, :password)
    end
end
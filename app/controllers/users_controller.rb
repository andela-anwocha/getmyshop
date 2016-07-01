class UsersController < ApplicationController
  def forgot
    render "forgot_password"
  end

  def process_email
    user = RegularUser.find_by_email(params[:email])
    if user
      flash[:success] = "An Email has been sent with instructions to"\
      " change your password"
      reset_code = [*"0".."9", *"a".."z", *"A".."Z"].sample(50).join
      RegularUser.update(user.id, reset_code: reset_code)
      UserMailer.reset_password(user.id, "Reset Your Password").deliver_now
    else
      flash[:error] = "No user found with this email"
    end

    redirect_to forgot_users_path
  end

  def reset_password
  end

  def reset
    user = RegularUser.find(params[:id])

    if user.reset_code == params[:reset_code]
      user.update_attributes password: params[:password], reset_code: nil
      flash[:notice] = "Password Successfully Changed."\
      " Sign in with new password"
      redirect_to login_path
    else
      flash[:notice] = "some error occured"
      render "forgot_password"
    end
  end

  def index
  end

  def show
  end

  def new
    @user = flash["user"] ? User.new(flash["user"]) : User.new
  end

  def create
    if create_shop_owner?
      create_shop_owner
    else
      create_regular_user
    end
  end

  def activate
    user = User.token_match(params[:user_id], params[:activation_token]).first
    redirect_path = root_path
    activate_user(user, redirect_path)
  end

  def shop_owner_activate
    shop_owner = ShopOwner.token_match(params[:shop_owner_id], params[:activation_token]).first
    redirect_path = shop_new_path(shop_owner)
    activate_user(shop_owner, redirect_path)
  end

  private

  def create_shop_owner?
    params[:user][:create_shop_owner]
  end

  def activate_user(user, redirect_path)
    if user && user.update(active_status: true)
      session[:user_id] = user.id
      redirect_to redirect_path, notice: "Account activated successfully."
    else
      redirect_to redirect_path, notice: "Unable to activate account. "\
      "If you copied the link, make sure you copied it correctly."
    end
  end

  def create_regular_user
    @user = RegularUser.new(users_params)
    if @user.save
      UserMailer.welcome(@user.id, "Welcome To GetMyShop").deliver_now
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome, #{current_user.first_name}"
    else
      flash["errors"] = @user.errors.full_messages
      flash["user"] = @user
      redirect_to :back
    end
  end

  def create_shop_owner
    @shop_owner = ShopOwner.new(users_params)
    if @shop_owner.save
      UserMailer.welcome_shop_owner(@shop_owner.id, "Welcome To GetMyShop")
        .deliver_now
      session[:user_id] = @shop_owner.id
      redirect_to root_path, notice: "Welcome, #{@shop_owner.first_name}"
    else
      flash["errors"] = @shop_owner.errors.full_messages
      flash["user"] = @shop_owner
      redirect_to :back
    end
  end

  

  def account
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def addresses
    @user_addresses = current_user.addresses
  end

  def update
    user = User.find_by(id: params[:id])
    user.update(users_params)
    redirect_to account_users_path, notice: "Account Updated"
  end

  def destroy
    current_user.update(active: false)
    logout
  end

  def logout
    session.delete :user_id
    redirect_to root_path, notice: "Account Deactivated"
  end

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end

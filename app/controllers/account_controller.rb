#
# This file is part of Project Hybrasyl (Ealagad), a Rails interface to
# the Hybrasyl server.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the Affero General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but
# without ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the Affero General Public License
# for more details.
#
# You should have received a copy of the Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#
# (C) 2013 Justin Baugh (baughj@hybrasyl.com)
# (C) 2015 Project Hybrasyl (info@hybrasyl.com)
#
# Authors:   Justin Baugh    <baughj@hybrasyl.com>
#

class AccountController < ApplicationController

  before_action :authenticate_account!

  def manager
    @characters = current_account.players
    render :manager and return
  end

  def reset
    @char_id = params[:id]
    @char = Player.find_by_id @char_id
    if (@char.nil?)
      flash[:alert] = "The character specified is not linked to your account."
      flash.keep(:alert)
      redirect_to account_manager_path and return
    end

    if (@char.account != current_account)
      flash[:alert] = "The character specified is not linked to your account."
      flash.keep(:alert)
      redirect_to account_manager_path and return
    end

    PlayerResetPasswordMailer.reset_password(@char, request.remote_ip).deliver

    flash[:notice] = "A new password for #{@char.name} has been emailed to you."
    flash.keep(:notice)
    redirect_to account_manager_path and return
  end

  def link
    username = params[:player]
    password = params[:password]
    player = Player.find_by_name username
    if (!player.nil?)
      if (player.valid_password? password)
        if (player.account == current_account)
          flash[:notice] = "Character already linked - nothing to do here."
          flash.keep(:alert)
          redirect_to account_manager_path and return
        end
        if (!player.account.nil?)
          flash[:alert] = "Character name or password was incorrect!"
          flash.keep(:alert)
          redirect_to account_manager_path
        else
          player.account = current_account
          player.save
          flash[:notice] = "#{player.name} was linked to your account successfully!"
          flash.keep(:notice)
          redirect_to account_manager_path
        end
      else
          flash[:alert] = "Character name or password was incorrect!"
          flash.keep(:alert)
          redirect_to account_manager_path
      end
    else
      flash[:alert] = "Character name or password was incorrect!"
      flash.keep(:alert)
      redirect_to account_manager_path
    end
  end

end

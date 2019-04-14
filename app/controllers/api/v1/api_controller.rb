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

module Api
  module V1
    class ApiController < ApplicationController
      before_action :restrict_access
      respond_to :json

      def status
        render :json => {'Enabled' => true}
      end

      def player_login
        username = params[:username]
        password = params[:password]
        if !username.blank? and  !password.blank?
          player = Player.find_by_name username
          if !player.nil?
            if player.valid_password? password
              render :json => {'Success' => true,
                'email' => player.account.email,
                'roles' => player.account.roles,
                'flags' => player.flags.map { |f| f.name },
                'Message' => 'Authentication successful'} and return
            end
          end
        end
        render :json => {'Success' => false,
            'Message' => 'Authentication failed'} and return
      end

      def account_login
        email = params[:email]
        password = params[:password]
        if !email.blank? and  !password.blank?
          account = Account.find_by_email email
          if !account.nil?
            if account.valid_password? password
              render :json => {'Success' => true,
                               'Message' => 'Authentication successful'} and return
            end
          end
        end
        render :json => {'Success' => false,
            'Message' => 'Authentication failed'} and return
      end

      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          ApiKey.exists?(access_token: token)
        end
      end

    end
  end
end

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

class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        redirect_to "/", :alert => exception.message
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_account)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Account) 
      # Everyone should always go back to the main site after login
      "/"
    else
      super
    end
  end
end


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
# (C) 2015 Project Hybrasyl (baughj@hybrasyl.com)
#
# Authors:   Justin Baugh    <baughj@hybrasyl.com>
#

ActiveAdmin.register Account do
  menu :if => proc{ can?(:manage, Account) }

  controller do
    def update
      # Magically set up our roles_mask like nothing ever happened and remove :roles
      params[:account][:roles_mask] = (params[:account][:roles].keys & Account::ROLES).map { |r| 2**Account::ROLES.index(r) }.inject(0, :+)
      params[:account].delete :roles
      super
    end
  end

  index :download_links => false do
    column :email
    column :nickname
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form :partial => "details"

#  form do |f|
#    f.inputs "Admin Details" do
#      f.input :email
#      f.input :nickname
#      f.input :password
#      f.input :password_confirmation
#      f.input :roles, :as => :select, :label => "Account Access", :hint => "Set account permissions"
#    end

end

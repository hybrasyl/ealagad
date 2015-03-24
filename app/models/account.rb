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

class Account < ActiveRecord::Base

  # By default, superadmins can edit everything (including other admins)
  # admins can edit everything except other admins
  # builders can edit all in-game objects (maps, items, worldmaps, worldmap points, etc)
  # mapeditors can only edit maps
  # users - can login to "main" interface
  # banned - account is banned (no permissions at all)
  # disabled - account is temporarily locked (can be unlocked via reset)

  ROLES = %w[superadmin admin builder mapeditor user banned disabled forumadmin]

  # These roles should at least be able to acknowledge the existence of /admin

  ADMIN_ROLES = %w[superadmin admin builder mapeditor]

  # Devise settings / etc

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,
  :confirmable, :lockable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :roles, :roles_mask

  has_many :players
  has_many :news_posts

  # Hybrasyl stuff

  attr_accessible :id, :nickname
  validates :nickname, :presence => true

  def password_required?
    # Do not require admins to put in a password to edit an admin record
    if (!new_record? && (password.blank? && password_confirmation.blank?))
      false
    else
      super
    end

  end

  def name
    if nickname
      return "#{nickname} (#{email})"
    else
      return email
    end
  end

  def disable
    self.roles = ["disabled"]
  end

  def enable
    self.roles = ["user"]
  end

  def active_for_authentication?
    (is? :user) && !(is? :banned or is? :disabled)
  end

  def inactive_message
    (is? :disabled or is? :banned) ? "banned" : super
  end

  def confirm!
    super
    setup_basic_user_role
  end

  def setup_basic_user_role
    self.roles = ["user"]
  end

  def roles=(roles)
    var = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
    print var
    self.roles_mask = var
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def can_access_admin?
    self.roles & ADMIN_ROLES != []
  end

end

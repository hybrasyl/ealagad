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

require 'bcrypt'

class Player < ActiveRecord::Base
  include BCrypt

  belongs_to :account
  belongs_to :map
  has_and_belongs_to_many :flags
  has_many :legend_marks
  belongs_to :nation
  accepts_nested_attributes_for :flags, :allow_destroy => true

  validates :map_id, :presence => true

  validates :name, :presence => true,
  :length => { :minimum => 4, :maximum => 12 },
  :format => { :with => /[a-zA-Z]+\z/,
    :message => "Unfortunately, names may only contain letters." }

  validates :sex, :presence => true,
  :numericality => { :greater_than => 0, :less_than_or_equal_to => 2 }

  def password
    @password ||= Password.new(password_hash) if password_hash.present?
  end

  def password=(new_password)
    if !new_password.empty?
      @password = Password.create(new_password)
      self.password_hash = @password
    end
  end

  def valid_password?(password)
    return self.password == password
  end

  def reset_password
    new_password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    self.password = new_password
    self.save
    return new_password
  end

end

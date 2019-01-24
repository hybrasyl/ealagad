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

class Mob < ActiveRecord::Base
  def display_name
    if !description.blank?
      "#{name} (#{description})"
    else
      "#{name} (L: #{level} XP: #{exp})"
    end
  end

  # attr_accessible :id, :name, :sprite, :level, :min_dmg, :max_dmg, :mr, :ac,
  # :force_multiplier, :off_element, :def_element, :exp, :gold, :drops_attributes,
  #   :description

  validates :off_element, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Elements::HASH.count }

  validates :def_element, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Elements::HASH.count }

  validates :min_dmg, :max_dmg,
  :numericality => { :only_integer => true, :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT16 }

  has_and_belongs_to_many :drops
  has_and_belongs_to_many :drop_sets
  has_many :spawns
  validate :max_dmg_is_greater_than_or_equal_to_min_dmg
  accepts_nested_attributes_for :drops, :allow_destroy => true
  validates :description, :length => { :maximum => 32 }
  validates :script_name, :length => { :maximum => 32 }

  def max_dmg_is_greater_than_or_equal_to_min_dmg
    if (!min_dmg.nil? && !max_dmg.nil?) && (min_dmg != 0 && max_dmg != 0)
      errors[:base] << "Maximum damage must be greater or equal to minimum damage" unless
        max_dmg.to_int >= min_dmg.to_int
    end
  end


end

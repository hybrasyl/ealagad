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

class Map < ActiveRecord::Base
  include Bitfields

  has_many :players
  has_many :warps, :foreign_key => :source_id
  has_many :worldwarps, :foreign_key => :source_map_id
  has_many :npcs
  has_many :spawns
  has_many :reactors

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 255 }
  validates :size_x, :numericality => { :greater_than => 0, :less_than => 255 }
  validates :size_y, :numericality => { :greater_than => 0, :less_than => 255 }
  validates :music, :allow_blank => true, :numericality => { :greater_than_or_equal_to => -1, :less_than_or_equal_to => 128}
  bitfield :flags, 1 => :snow, 2 => :rain, 64 => :no_map, 128 => :winter

  accepts_nested_attributes_for :warps, :allow_destroy => true
  accepts_nested_attributes_for :worldwarps, :allow_destroy => true

  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :tags

  def tag_tokens=(ids)
  end

  def flags=(value)

    if value.class == [].class
      write_attribute(:flags, value.map { |x| x.to_i }.inject(:+))
    elsif value.class == 0.class || value.class == ''.class
      write_attribute(:flags, value.to_i)
    else
      write_attribute(:flags, 0)
    end

  end



end

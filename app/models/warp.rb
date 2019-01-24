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

class Warp < ActiveRecord::Base
  belongs_to :source, :class_name => "Map"
  belongs_to :target, :class_name => "Map"

  validates :source_id, :presence => true
  validates :target_id, :presence => true

  validates :target_x, :target_y, :source_x, :source_y, :presence => true,
  :length => { :maximum => 7 }

  validates :max_lev, :min_lev, :min_ab,
  :numericality => { :only_integers => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_LEVEL },
  :allow_blank => true

  validate :max_lev_is_greater_than_min_lev

  # attr_accessible :target_x, :target_y, :target_id, :id, :max_lev,
  :min_ab, :min_lev, :mob_use, :source_id, :source_x, :source_y

  attr_accessor :range

  def max_lev_is_greater_than_min_lev
    errors[:base] << "Maximum level must exceed minimum level" unless
      max_lev.to_int > min_lev.to_int
  end

end

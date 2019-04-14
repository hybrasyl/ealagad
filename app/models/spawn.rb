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

class Spawn < ActiveRecord::Base
  belongs_to :mob
  belongs_to :map

  validates :ticks, :presence => true
  validates :quantity, :presence => true, :numericality => { :greater_than_or_equal_to => 1 }

  validate :dont_overspawn_maps_kthx

  def dont_overspawn_maps_kthx
    # We don't allow any one spawn to occupy more than 10% of a map's tiles
    tilesize = map.size_x * map.size_y
    max_mobs = tilesize / 10
    if (quantity > max_mobs)
      errors.add(:quantity, "can't occupy more than 10% of a map's available tiles (map is #{map.size_x} x #{map.size_y} or #{tilesize} tiles)")
    end
  end

end

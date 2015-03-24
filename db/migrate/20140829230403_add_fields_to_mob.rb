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

class AddFieldsToMob < ActiveRecord::Migration
  def change
    add_column :mobs, :level, :integer, :null => false, :default => 1
    add_column :mobs, :min_dmg, :integer, :null => false, :default => 1
    add_column :mobs, :max_dmg, :integer, :null => false, :default => 1
    add_column :mobs, :mr, :integer, :null => false, :default => 0
    add_column :mobs, :ac, :integer, :null => false, :default => 100
    add_column :mobs, :force_multiplier, :float, :null => false, :default => 1.0
    add_column :mobs, :off_element, :integer, :null => false, :default => 0
    add_column :mobs, :def_element, :integer, :null => false, :default => 0
    add_column :mobs, :exp, :integer, :null => false, :default => 0
    add_column :mobs, :gold, :integer, :null => false, :default => 0
  end
end

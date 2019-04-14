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

class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.belongs_to :account
      t.string :name, :null => false
      t.string :password_hash
      t.integer :sex, :null => false
      t.integer :hairstyle, :null => false
      t.integer :haircolor, :null => false
      t.belongs_to :map
      t.integer :map_x
      t.integer :map_y
      t.integer :direction, :null => false, :default => 0
      t.integer :class_type, :null => false, :default => Hybrasyl::Constants::Classes::PEASANT
      t.integer :level, :null => false, :default => 1
      t.integer :exp, :null => false, :default => 0
      t.integer :ab, :null => false, :default => 0
      t.integer :ab_exp, :null => false, :default => 0
      t.integer :max_hp, :null => false, :default => 50
      t.integer :max_mp, :null => false, :default => 50
      t.integer :cur_hp, :null => false, :default => 50
      t.integer :cur_mp, :null => false, :default => 50
      t.integer :str, :null => false, :default => 3
      t.integer :int, :null => false, :default => 3
      t.integer :wis, :null => false, :default => 3
      t.integer :con, :null => false, :default => 3
      t.integer :dex, :null => false, :default => 3
      t.string :equipment, :null => false, :default => "[]", :limit => 8192
      t.string :inventory, :null => false, :default => "[]", :limit => 8192
      t.timestamps
    end
    add_index :players, :account_id
    add_index :players, :map_id
  end
end

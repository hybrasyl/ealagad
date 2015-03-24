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

class CreateSignposts < ActiveRecord::Migration
  def change
    create_table :signposts do |t|
      t.references :map, :null => false
      t.integer :map_x, :null => false
      t.integer :map_y, :null => false
      t.text :message, :null => false
      t.boolean :is_messageboard, :null => false, :default => false
      t.references :board

      t.timestamps
    end
    add_index :signposts, :map_id
    add_index :signposts, :board_id
  end
end

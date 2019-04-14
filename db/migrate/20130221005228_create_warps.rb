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

class CreateWarps < ActiveRecord::Migration[4.2]
  def change
    create_table :warps do |t|
      t.string :source_x, :null => false
      t.string :source_y, :null => false
      t.string :target_x, :null => false
      t.string :target_y, :null => false
      t.integer :max_lev, :default => 99
      t.integer :min_lev, :default => 1
      t.integer :min_ab, :defaut => 0
      t.boolean :mob_use, :null => false, :default => false
      t.belongs_to :source, :null => false
      t.belongs_to :target, :null => false
      t.timestamps
    end
  end
end

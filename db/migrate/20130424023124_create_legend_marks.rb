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

class CreateLegendMarks < ActiveRecord::Migration[4.2]
  def change
    create_table :legend_marks do |t|
      t.references :player, :null => false
      t.string :prefix, :null => false
      t.integer :color, :null => false, :default => 16
      t.integer :icon, :null => false, :default => 0
      t.string :text, :null => false
      t.boolean :public, :null => false, :default => true
      t.timestamps
    end
  end
end

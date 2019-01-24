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

ActiveAdmin.register Spawn do
  menu :if => proc{ can?(:manage, Spawn) }
  #config.sort_order = "name_asc"

  filter :map, :collection => Map.order('maps.name ASC').all
  filter :mob, :collection => Mob.order('mobs.name ASC').all
  filter :quantity
  filter :ticks

  index :download_links => false do
    column "Map", :map
    column "Mob", :mob
    column "Quantity", :quantity
    column "Ticks", :ticks
    actions
  end

  form do |f|
    f.inputs "Spawn" do
      f.input :map, :collection => Map.order('maps.name ASC').all, :include_blank => false
      f.input :mob, :collection => Mob.order('mobs.name ASC').all, :include_blank => false
      f.input :quantity
      f.input :ticks
    end
    f.actions
  end
end


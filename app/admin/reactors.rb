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

ActiveAdmin.register Reactor do
  permit_params :id, :name, :map_id, :map_x, :map_y, :script_name, :blocking

  menu :if => proc{ can?(:manage, Reactor) }
  #config.sort_order = "name_asc"

  filter :map, :collection => Map.order('maps.name ASC').all
  filter :name
  filter :script_name

  index :download_links => false do
    column "Reactor Name", :name
    column "Script Name (if applicable)", :script_name
    column "Map", :map
    column "Coordinates" do |reactor|
      "#{reactor.map_x}, #{reactor.map_y}"
    end
    column "Blocking", :blocking
    actions
  end

  form do |f|
    f.inputs "Reactor" do
      f.input :map, :collection => Map.order('maps.name ASC').all, :include_blank => false
      f.input :map_x
      f.input :map_y
      f.input :blocking
      f.input :name
      f.input :script_name
    end
    f.actions
  end
end


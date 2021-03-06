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

ActiveAdmin.register Npc do
  permit_params :id, :name, :sprite, :map_id, :map_x, :map_y, :direction, :display_text, :jobs, :portrait

  menu :if => proc{ can?(:manage, Npc) }
  config.sort_order = "name_asc"

  index :download_links => false do
    column "Name", :name
    column "Map", :map
    column "Sprite", :sprite
    column "Portrait", :portrait
    actions
  end

end


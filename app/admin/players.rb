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

ActiveAdmin.register Player do
  permit_params :id, :account_id, :password, :ab, :ab_exp, :class_type, :con, :cur_hp, :cur_mp, :dex,
                :direction, :exp, :haircolor, :hairstyle, :int, :level, :map_x, :map_y,
                :max_hp, :max_mp, :name, :sex, :str, :wis, :attributes, :inventory, :equipment,
                :flag_ids, :map_id

  menu :if => proc{ can?(:manage, Player) }

  config.sort_order = "name_asc"

  filter :name
  filter :account
  filter :class_type, :as => :select, :collection =>
    Hybrasyl::Constants::Classes::HASH

  form :partial => 'update'

  index :download_links => false do
    column :name
    column :account, :sortable => :account_id
    column "Class", :class_type do |player|
      Hybrasyl::Constants::Classes::REVERSEHASH[player.class_type]
    end
    column :level, :sortable => :level 
    actions
  end

end

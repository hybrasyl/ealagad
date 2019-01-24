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

ActiveAdmin.register Mob do
  menu :if => proc{ can?(:manage, Mob) }
  #config.sort_order = "name_asc"

  filter :name
  filter :level
  filter :min_dmg
  filter :max_dmg
  filter :mr
  filter :ac
  filter :force_multiplier
  filter :exp
  filter :gold
  filter :off_element, :as => :select, :collection => Hybrasyl::Constants::Elements::HASH
  filter :def_element, :as => :select, :collection => Hybrasyl::Constants::Elements::HASH

  show do
    attributes_table :name, :level, :sprite, :force_multiplier,
    :exp, :gold

    panel "Spawn List" do
      table_for mob.spawns do
        column :map
        column :quantity
        column :ticks
      end
    end

    panel "Drop List" do
      table_for mob.drops do
        column "Item" do |drops|
          drops.item.name
        end
        column :min_quantity
        column :max_quantity
        column :chance
      end
    end

    panel "Additional Drop Sets" do
      table_for mob.drop_sets do
        column "Sets" do |sets|
          sets.name
        end
      end
    end

  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :level
      f.input :sprite
      f.input :force_multiplier
      f.input :off_element, :as => :select, :collection => Hybrasyl::Constants::Elements::HASH, :include_blank => false
      f.input :def_element, :as => :select, :collection => Hybrasyl::Constants::Elements::HASH, :include_blank => false
    end
    f.inputs "Drops" do
      f.has_many :drops, :allow_destroy => true,
      :heading => "Dongs", :new_record => true do |drop|
        drop.input :item, :collection => Item.order('items.name ASC').all
        drop.input :chance
        drop.input :min_quantity
        drop.input :max_quantity
        if drop.object.id
          drop.input :_destroy, :as => :boolean, :label => "Remove this drop"
        end
        drop.input :item_variants, :label => "Included Item Variants", :as => :check_boxes, :collection => ItemVariant.all,
        :input_html => { :class => 'itemvariantchoice' }
      end
    end
    f.actions
  end

  index :download_links => false do
    column "Name", :name
    column "Level", :level
    column "Sprite", :sprite
    column "Force Multiplier", :force_multiplier
    column "Experience", :exp
    column "Gold", :gold

    actions
  end

end


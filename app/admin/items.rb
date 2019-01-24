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

include Hybrasyl::Constants

ActiveAdmin.register Item do
  permit_params :id, :name, :sprite, :equip_sprite, :display_sprite,
                :item_type, :weapon_type, :equip_slot, :weight, :max_stack, :max_durability,
                :level, :ab, :class_type, :sex, :hp, :mp, :str, :int, :wis, :con, :dex, :hit,
                :ac, :dmg, :mr, :element, :max_s_dmg, :min_s_dmg, :max_l_dmg, :min_l_dmg,
                :regen, :value, :color, :enchantable, :depositable, :bound, :bodystyle,
                :tailorable, :smithable, :consecratable, :perishable, :exchangeable, :vendorable,
                :has_consecratable_variants, :has_tailorable_variants,
                :has_smithable_variants, :has_enchantable_variants, :has_elemental_variants,
                :unique_equipped, :unique, :consumed_on_use, :teleport_destination, :master_only

  menu :if => proc{ can?(:manage, Item) }
  config.sort_order = "name_asc"
  
  action_item :only => :show do
    link_to("New Item", new_admin_item_path) 
  end

  form :partial => "itemform"

  filter :name
  filter :item_type, :as => :select, :collection =>
    Hybrasyl::Constants::ItemTypes::HASH
  filter :weapon_type, :as => :select, :collection =>
    Hybrasyl::Constants::WeaponTypes::HASH
  filter :equip_slot, :as => :select, :collection =>
    Hybrasyl::Constants::EquipmentSlots::HASH
  filter :class_type, :as => :select, :collection =>
    Hybrasyl::Constants::Classes::HASH
  filter :element, :as => :select, :collection =>
    Hybrasyl::Constants::Elements::HASH
  filter :bodystyle, :as => :select, :collection =>
    Hybrasyl::Constants::BodyColors::HASH
  filter :color

  filter :weight
  filter :max_stack
  filter :max_durability

  filter :level
  filter :hp
  filter :mp
  filter :str
  filter :int
  filter :con
  filter :wis
  filter :dex
  filter :mr
  filter :hit
  filter :dmg
  filter :min_s_dmg
  filter :max_s_dmg
  filter :min_l_dmg
  filter :max_l_dmg
  filter :regen

  filter :sex, :as => :select, :collection =>
    Hybrasyl::Constants::Genders::HASH, :label => "Gender"

  index :download_links => false do
    actions
    column :name
    column "Inventory Sprite", :sprite
    column "Equipped Sprite", :equip_sprite
    column "Item Type", :sortable => :item_type do |item|
      Hybrasyl::Constants::ItemTypes::REVERSEHASH[item.item_type]
    end
    column "Weapon Type", :sortable => :weapon_type do |item|
      Hybrasyl::Constants::WeaponTypes::REVERSEHASH[item.weapon_type]
    end
    column "Slot", :sortable => :equip_slot do |item|
      Hybrasyl::Constants::EquipmentSlots::REVERSEHASH[item.equip_slot]
    end
    column "Class", :sortable => :class_type do |item|
        Hybrasyl::Constants::Classes::REVERSEHASH[item.class_type]
    end
    column :max_stack
    column :level
    column "Gender", :sortable => :sex do |item|
      Hybrasyl::Constants::Genders::REVERSEHASH[item.sex]
    end
    column :element, :sortable => :element do |item|
      Hybrasyl::Constants::Elements::REVERSEHASH[item.element]
    end
  end

end

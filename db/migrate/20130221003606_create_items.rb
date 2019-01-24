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

class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|

      t.string  :name, :null => false
      t.integer :sprite, :null => false
      t.integer :equip_sprite, :null => false, :default => -1
      t.integer :display_sprite
      t.integer :bodystyle, :null => false, :default => 0
      t.integer :item_type, :null => false
      t.integer :weapon_type
      t.integer :equip_slot
      t.integer :weight, :null => false, :default => 0
      t.integer :max_stack, :null => false, :default => 1
      t.integer :max_durability, :null => false, :default => 0
      t.integer :level, :null => false, :default => 0
      t.integer :ab, :null => false, :default => 0
      t.integer :class_type, :default => 0
      t.integer :sex, :null => false, :default => 0
      t.integer :hp, :null => false, :default => 0
      t.integer :mp, :null => false, :default => 0
      t.integer :str, :null => false, :default => 0
      t.integer :int, :null => false, :default => 0
      t.integer :wis, :null => false, :default => 0
      t.integer :con, :null => false, :default => 0
      t.integer :dex, :null => false, :default => 0
      t.integer :hit, :null => false, :default => 0
      t.integer :dmg, :null => false, :default => 0
      t.integer :ac, :null => false, :default => 0
      t.integer :mr, :null => false, :default => 0
      t.integer :element, :null => false, :default => 0
      t.integer :max_s_dmg, :null => false, :default => 0
      t.integer :min_s_dmg, :null => false, :default => 0
      t.integer :max_l_dmg, :null => false, :default => 0
      t.integer :min_l_dmg, :null => false, :default => 0
      t.integer :value, :null => false, :default => 0
      t.integer :color, :null => false, :default => 0
      t.integer :regen, :null => false, :default => 0

      t.boolean :bound, :null => false, :default => false
      t.boolean :depositable, :null => false, :default => true

      t.boolean :enchantable, :null => false, :default => false
      t.boolean :consecratable, :null => false, :default => false
      t.boolean :tailorable, :null => false, :default => false
      t.boolean :smithable, :null => false, :default => false
      t.boolean :exchangeable, :null => false, :default => true

      t.boolean :has_enchantable_variants, :null => false, :default => false
      t.boolean :has_consecratable_variants, :null => false, :default => false
      t.boolean :has_tailorable_variants, :null => false, :default => false
      t.boolean :has_smithable_variants, :null => false, :default => false
      t.boolean :has_elemental_variants, :null => false, :default => false

      t.timestamps
    end
  end
end

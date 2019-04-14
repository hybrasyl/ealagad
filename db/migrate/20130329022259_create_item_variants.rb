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

class CreateItemVariants < ActiveRecord::Migration[4.2]
  def change
    create_table :item_variants do |t|
      t.string :name, :null => false
      t.string :modifier, :null => false
      t.string :effect_script_name

      # These variants can be expressed as integer differences, or
      # percentages

      t.string :weight
      t.string :max_stack
      t.string :max_durability
      t.string :hp
      t.string :mp
      t.string :str
      t.string :int
      t.string :wis
      t.string :con
      t.string :dex
      t.string :hit
      t.string :ac
      t.string :dmg
      t.string :mr
      t.string :max_s_dmg
      t.string :min_s_dmg
      t.string :max_l_dmg
      t.string :min_l_dmg
      t.string :value
      t.string :regen

      # These can be different, but cannot be expressed as percentages
      t.integer :level
      t.integer :ab
      t.integer :element

      t.integer :bodystyle, :null => false, :default => 1
      t.integer :color

      t.boolean :enchantable, :default => false
      t.boolean :depositable, :default => true
      t.boolean :bound, :default => false
      t.boolean :vendorable, :default => true
      t.boolean :tailorable, :default => false
      t.boolean :smithable, :default => false
      t.boolean :consecratable, :default => false
      t.boolean :perishable, :default => true
      t.boolean :exchangeable, :default => true

      t.boolean :consecratable_variant, :default => false
      t.boolean :tailorable_variant, :default => false
      t.boolean :smithable_variant, :default => false
      t.boolean :enchantable_variant, :default => false
      t.boolean :elemental_variant, :default => false

      t.timestamps
    end
  end
end

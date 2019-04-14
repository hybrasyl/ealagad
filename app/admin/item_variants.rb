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

ActiveAdmin.register ItemVariant do
  permit_params :id, :name, :modifier, :bodystyle, :weight, :max_stack,
                :max_durability, :level, :ab, :hp, :mp, :str, :int, :wis, :con, :dex,
                :hit, :ac, :dmg, :mr, :element, :max_s_dmg, :min_s_dmg, :max_l_dmg, :min_l_dmg,
                :value, :color, :regen, :enchantable, :depositable, :bound, :vendorable,
                :tailorable, :smithable, :consecratable, :perishable, :exchangeable,
                :consecratable_variant, :tailorable_variant, :smithable_variant, :enchantable_variant,
                :elemental_variant, :effect_script_name

  menu :if => proc{ can?(:manage, Item) }
  config.sort_order = "name_asc"

  form :partial => "itemvariantform"

  filter :name
  filter :effect_script_name

  index :download_links => false do
    actions
    column :name
    column :effect_script_name
  end

end

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

class Item < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true,
  :length => { :minimum => 1, :maximum => 24 }

  validates :sprite, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT16 }

  validates :display_sprite, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT16 }

  validates :item_type, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::ItemTypes::HASH.count }

  validates :shoptab, :allow_blank => true,
  :length => { :minimum => 1, :maximum => 8 }

  validates :shopdesc, :allow_blank => true,
  :length => { :minimum => 1, :maximum => 254 }
  
  validates :weapon_type, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::WeaponTypes::HASH.count }

  validates :equip_slot, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::EquipmentSlots::HASH.count }

  validates :weight, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to  => -255,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT8 }

  validates :max_stack, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT16 }

  validates :max_durability, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT32 }

  validates :level, :presence => {
    :unless => :ab, :message => "You must define level, AB, or both." },
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT8 }

  validates :ab, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT8 }

 validates :class_type, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Classes::HASH.count }

  validates :hp, :mp, :value, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => Hybrasyl::Constants::Integers::MIN_SIGNED32,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_SIGNED32 }

  validates :str, :int, :wis, :con, :dex, :hit, :dmg, :ac, :mr, :color, :regen,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => Hybrasyl::Constants::Integers::MIN_SIGNED8,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_SIGNED8 }

  validates :element, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Elements::HASH.count }

  validates :bodystyle, :presence => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::BodyColors::HASH.count }

  validates :min_s_dmg, :max_s_dmg, :min_l_dmg, :max_l_dmg,
  :numericality => { :only_integer => true, :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Hybrasyl::Constants::Integers::MAX_INT16 }

  validate :max_dmg_is_greater_than_or_equal_to_min_dmg
  validate :weapons_must_have_weapon_types
  validate :equipment_must_have_slot
  validate :renderable_equipment_must_have_display_sprite

  #validate :weapons_cannot_have_tailorable_variants
  #validate :equipment_cannot_have_smithable_variants

  has_and_belongs_to_many :item_variants
  has_and_belongs_to_many :npcs
  has_many :drops

  def equipment_must_have_slot
    if (item_type == 2)
        errors[:base] <<
        "Equippable items must have a slot" unless !equip_slot.nil?
    end
  end

  def renderable_equipment_must_have_display_sprite
    if (item_type == 2 and
        Hybrasyl::Constants::EquipmentSlots::DISPLAY_SPRITE_REQUIRED.include? equip_slot)
      errors[:base] <<
        "This type of equipment must have a display sprite, even if 0" unless !display_sprite.blank?
    end
  end

  def weapons_must_have_weapon_types
    if (item_type == 2 && equip_slot == Hybrasyl::Constants::EquipmentSlots::WEAPON)
      errors[:base] <<
        "A weapon must have a weapon type" unless !weapon_type.nil?
    elsif (item_type == 2 && equip_slot != Hybrasyl::Constants::EquipmentSlots::WEAPON)
      errors[:base] <<
        "Non-weapons can't have weapon types" unless weapon_type.nil?
    end
  end

  def max_dmg_is_greater_than_or_equal_to_min_dmg
    if (!min_s_dmg.nil? && !max_s_dmg.nil?) && (min_s_dmg != 0 && max_s_dmg != 0)
      errors[:base] << "Maximum S damage must be greater or equal to minimum damage" unless
        max_s_dmg.to_int >= min_s_dmg.to_int
    end

    if (!min_l_dmg.nil? && !max_l_dmg.nil?) && (min_l_dmg != 0 && max_l_dmg != 0)
      errors[:base] << "Maximum L damage must be greater or equal to minimum damage" unless
        max_l_dmg.to_int >= min_l_dmg.to_int
    end
  end

  # attr_accessible :id, :name, :sprite, :equip_sprite, :display_sprite,
  # :item_type, :weapon_type, :equip_slot, :weight, :max_stack, :max_durability,
  # :level, :ab, :class_type, :sex, :hp, :mp, :str, :int, :wis, :con, :dex, :hit,
  # :ac, :dmg, :mr, :element, :max_s_dmg, :min_s_dmg, :max_l_dmg, :min_l_dmg,
  # :regen, :value, :color, :enchantable, :depositable, :bound, :bodystyle,
  # :tailorable, :smithable, :consecratable, :perishable, :exchangeable, :vendorable,
  # :has_consecratable_variants, :has_tailorable_variants,
  # :has_smithable_variants, :has_enchantable_variants, :has_elemental_variants,
  # :unique_equipped, :unique, :consumed_on_use, :teleport_destination, :master_only

end


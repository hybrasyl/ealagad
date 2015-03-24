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

class String
  def is_integer?
    true if Integer(self) rescue false
  end
  def is_percentage?
    if /^(\+|\-){0,1}(\d{0,3}%)$/ =~ self
      true
    else
      false
    end
  end
end

class VariantFieldValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Make sure the entry is either a valid percentage or a valid integer
    # within a specified range.
    if !value.nil? && !value.blank?
      if ((value.is_integer?) &&
          (Integer(value) < options[:min_value] ||
           Integer(value) > options[:max_value] ))
        record.errors[attribute] <<
          (options[:message] || "This value is too large or small for this field (must be between #{options[:min_value]} and #{options[:max_value]}")
      elsif ((!value.is_integer?) && (!value.is_percentage?))
        record.errors[attribute] <<
          (options[:message] || "This is not a valid integer or percentage value.")
      end
    end
  end

end


class ItemVariant < ActiveRecord::Base

  include Hybrasyl::Constants

  validates :weight, :max_stack, :max_durability,
  :variant_field => { :min_value => Integers::MIN_SIGNED32,
    :max_value => Integers::MAX_SIGNED32 }

  validates :hp, :mp, :variant_field => { :min_value => Integers::MIN_SIGNED32,
    :max_value => Integers::MAX_SIGNED32 }

  validates :str, :int, :wis, :con, :dex, :hit, :dmg, :ac, :mr,
  :variant_field => { :min_value => Integers::MIN_SIGNED8,
    :max_value => Integers::MAX_SIGNED8 }

  validates :level, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Integers::MAX_INT8 }

  validates :ab, :allow_blank => true, 
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Integers::MAX_INT8 }

  validates :color, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Integers::MAX_INT8 }

  validates :element, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Elements::HASH.count }

  validates :bodystyle, :allow_blank => true,
  :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => BodyColors::HASH.count }

  validates :min_s_dmg, :max_s_dmg, :min_l_dmg, :max_l_dmg,
  :variant_field => { :min_value => Integers::MIN_SIGNED16,
    :max_value => Integers::MAX_SIGNED16 }

  attr_accessible :id, :name, :modifier, :bodystyle, :weight, :max_stack,
  :max_durability, :level, :ab, :hp, :mp, :str, :int, :wis, :con, :dex,
  :hit, :ac, :dmg, :mr, :element, :max_s_dmg, :min_s_dmg, :max_l_dmg, :min_l_dmg,
  :value, :color, :regen, :enchantable, :depositable, :bound, :vendorable,
  :tailorable, :smithable, :consecratable, :perishable, :exchangeable,
  :consecratable_variant, :tailorable_variant, :smithable_variant, :enchantable_variant,
  :elemental_variant, :effect_script_name

end

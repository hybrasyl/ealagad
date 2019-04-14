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

class Drop < ActiveRecord::Base
  # attr_accessible :chance, :min_quantity, :max_quantity, :item_id, :item_variant_ids
  belongs_to :item
  has_and_belongs_to_many :item_variants
  has_and_belongs_to_many :drop_sets

  validates :chance, :presence => true, :numericality => {
    :greater_than_or_equal_to => 0.00000001, :less_than_or_equal_to => 100 }

  validates :min_quantity, :presence => true
  validates :max_quantity, :presence => true

  validate :max_qty_is_greater_than_or_equal_to_min_qty
  #accepts_nested_attributes_for :item_variants

  def max_qty_is_greater_than_or_equal_to_min_qty
    if (!min_quantity.nil? && !max_quantity.nil?) && (min_quantity != 0 && max_quantity != 0)
      errors[:base] << "Maximum quantity must be greater or equal to minimum quantity" unless
        max_quantity.to_int >= min_quantity.to_int
    end
  end

end

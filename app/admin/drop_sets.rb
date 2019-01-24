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

ActiveAdmin.register DropSet do
  permit_params :id, :name, :enabled, :drops_attributes

  menu :if => proc{ can?(:manage, DropSet) }
  config.sort_order = "name_asc"
  index :download_links => false do
    column "Name", :name
    column "Enabled", :enabled
    column "Drops" do |dropset|
      dropset.drops.map { |d| d.item.name }.join(', ')
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :name
      f.input :enabled
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

end


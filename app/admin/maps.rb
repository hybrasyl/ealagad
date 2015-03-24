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

ActiveAdmin.register Map do

  menu :if => proc{ can?(:manage, Map) }

  form :partial => "mapform"

  index :download_links => false do
    column "ID", :id
    column "Width", :size_x
    column "Height", :size_y
    column "Map Name", :name
    column "Tags", :tag_list, :sortable => false
    default_actions
  end
  filter :name

  # This makes meta_search work with AA/acts_as_taggable_on
  filter :tag_taggings_tag_name, :as => :string, :label => "By Tag"

  collection_action :tags, :method => :get do
    ret = {}
    query_tags = ActsAsTaggableOn::Tag.where("name like ?", "%#{params[:q]}%").map { |m| m.name }.map {
      |n| { "id" => n, "name" => n } } 
    respond_to do |format|
      format.json { render json: query_tags }
    end
  end

  collection_action :get_zones, :method => :get do
    @zones = Map.select("id, name")
    respond_to do |format|
      format.html { render :partial => "map_zones" }
      format.json { render json: @zones }
    end
  end

  show do |map|
    attributes_table do
      row :name
      row :width do 
        map.size_x
      end
      row :height do
        map.size_y
      end
      row :tags do
        map.tags.map { |mt| mt.name }.join(', ')
      end
    end
  end



end

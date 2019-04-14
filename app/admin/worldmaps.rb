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

ActiveAdmin.register Worldmap do
  permit_params :id, :client_map, :name

  menu :if => proc{ can?(:manage, Map) }, :label => "World Maps"

  index :download_links => false do
    selectable_column
    column :id
    column :name
    column :client_map
    column :created_at
    column :updated_at
    column "Actions" do |worldmap|
      links = ''.html_safe
      links << link_to("Show", resource_path(worldmap), :class => "member_link view_link")
      links << link_to("Edit", edit_resource_path(worldmap), :class => "member_link view_link")
      links << link_to("Delete", resource_path(worldmap), :method => :delete, 
      :data => {:confirm => I18n.t('active_admin.delete_confirmation')},
      :class => "member_link delete_link")
      # This is pretty hacky, but it's the best we can do right now. I'm not 1337 enough at jQuery to
      # find out why the annotator doesn't work with 1.9.1 and a modern jQuery UI version.
      links << link_to("Edit Points", "#",
                       :onclick => "window.open('/admin/worldmaps/#{worldmap.id}/pointeditor', 'pointeditor', 'width=1100,height=750')",
                       :class => "member_link view_link")
      links
    end

  end

  controller do
    def pointeditor
      respond_to do |format|
        format.html { render "pointeditor", :layout => "pointeditor"  }
      end
    end
  end



  member_action :get_points, :method => :get do
    response = []

    @points = Worldmap.find(params[:id]).worldmap_points
    # again, do some haxx
    @points.each do |p|
      response.push({'top' => p.map_y, 'left' => p.map_x, 'width' => 8, 
        'height' => 8, 'id' => p.id, 'editable' => true, 
        'targetMap' => p.target_map_id, 'pointDestX' => p.target_x,
        'pointDestY' => p.target_y, 'pointName' => p.name,
        'pointConditional' => '', 'worldmapId' => p.worldmap_id})
    end
    respond_to do |format|
      format.json { render json: response }
    end
  end

  collection_action :get_edit_form, :method => :get do
    respond_to do |format|
      format.html { render :partial => "worldmap_point_editform" }
    end
  end


end

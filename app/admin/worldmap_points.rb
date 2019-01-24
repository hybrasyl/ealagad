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

ActiveAdmin.register WorldmapPoint do
  permit_params :id, :map_x, :map_y, :max_lev, :min_ab, :min_lev, :name, :target_x, :target_y

  menu false

  member_action :set, :method => :post do
    false
  end

  member_action :get_json, :method => :get do
    respond_to do |format|
      format.json { render json: Worldmap.find(params[:id]) }
    end
  end

  # This is kinda hacky but it's how the ajax map editor works at the moment
  collection_action :save_point, :method => :post do
    # This is also hacky as all hell but I'd rather change this than a ton of other things
    point = {}

    point[:map_x] = params[:left]
    point[:map_y] = params[:top]
    point[:target_x] = params[:pointDestX]
    point[:target_y] = params[:pointDestY]
    point[:name] = params[:pointName]

    logger.info "Inside your shitty function"

    if params[:id].blank?
      @mappoint = WorldmapPoint.new(point)
    else
      @mappoint = WorldmapPoint.update(params[:id], point)
    end

    @mappoint.target_map = Map.find(params[:targetMap])
    @mappoint.worldmap = Worldmap.find(params[:worldmapId])

    @mappoint.save

    respond_to do |format|
      format.html { render :inline => "<%= @mappoint.id %>" }
      format.json { render :inline => {'annotation_id' => @mappoint.id}.to_json }
    end
  end


  controller do
    def destroy
      WorldmapPoint.destroy(params[:id])
      respond_to do |format|
        # In theory we would never need to redirect to the index/show,
        # since the admin index should never be deleting worldmap points
          format.html { render :inline => "" }
          format.json { render :inline => "{}" }
      end
    end
  end

end

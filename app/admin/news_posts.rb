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

ActiveAdmin.register NewsPost do
  #menu :label => "News Posts"
  menu :if => proc{ can?(:manage, NewsPost) }, :label => "News Posts"

  before_create do |newspost| 
    newspost.account = current_account
    self
  end

  index :download_links => false do
    column :post_date, :sortable => :post_date do |newspost|
      newspost.post_date.to_date
    end
    column :title
    column "Author", :account
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "News Post" do
      f.input :post_date, :as => :datepicker
      f.input :title
      f.input :post, :as => :html_editor
    end
    f.actions
  end

end

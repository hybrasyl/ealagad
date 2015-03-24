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

class MoveAdminNotesToComments < ActiveRecord::Migration
  def self.up
    remove_index  :admin_notes, [:account_type, :account_id]
    rename_table  :admin_notes, :active_admin_comments
    rename_column :active_admin_comments, :account_type, :author_type
    rename_column :active_admin_comments, :account_id, :author_id
    add_column    :active_admin_comments, :namespace, :string
    add_index     :active_admin_comments, [:namespace]
    add_index     :active_admin_comments, [:author_type, :author_id]

    # Update all the existing comments to the default namespace
    say "Updating any existing comments to the #{ActiveAdmin.application.default_namespace} namespace."
    comments_table_name = ActiveRecord::Migrator.proper_table_name("active_admin_comments")
    execute "UPDATE #{comments_table_name} SET namespace='#{ActiveAdmin.application.default_namespace}'"
  end

  def self.down
    remove_index  :active_admin_comments, :column => [:author_type, :author_id]
    remove_index  :active_admin_comments, :column => [:namespace]
    remove_column :active_admin_comments, :namespace
    rename_column :active_admin_comments, :author_id, :account_id
    rename_column :active_admin_comments, :author_type, :account_type
    rename_table  :active_admin_comments, :admin_notes
    add_index     :admin_notes, [:account_type, :account_id]
  end
end

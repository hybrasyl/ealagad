class AddAuthenticationTokenExtraColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :authentication_token_created_at, :datetime
  end
end

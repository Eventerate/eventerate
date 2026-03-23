class MakeOrganizationOptionalForEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_null :events, :organization_id, true
  end
end

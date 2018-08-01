class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]

  #usersテーブルのemailカラムにインデックスを追加。
  # unique: true オプションで他に重複が存在しないようにしている
  def change
    add_index :users, :email, unique: true
  end
end

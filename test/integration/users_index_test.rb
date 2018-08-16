require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    # @adimin, @non_admin 10.62で書き換え。以下のコードも書き換え
    @admin = users(:michael)     # admin: trueを付与されている管理者
    @non_admin = users(:archer)
  end

  # 10.48 ページネーションを含めたUser#indexのテスト + 削除リンクのテスト
  test "index including pagination and delete links" do
    log_in_as(@admin)        # 管理者がログインし
    get users_path          #indexページにアクセスすると
    assert_template 'users/index'    # indexのビューが表示されるはず。
    assert_select 'div.pagination'       # paginationクラスを持ったdivタグもあるはず

    # =====================================================
    # 最初のページにユーザーがいることを確認している
    first_page_of_users = User.paginate(page: 1)

    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name   #user.nameの<a>リンクがあるはずである
      unless user == @admin       #  もしあるuserが管理者でない限りは
        assert_select 'a[href=?]', user_path(user), text: 'delete'    #<a>削除リンクが出ているはずである(管理者のdeleteリンクはあえて表示させていないため)
      end
    end
    assert_difference 'User.count', -1 do    #ユーザー数が１減るはずである
      delete user_path(@non_admin)    # 適切に管理者が他のユーザーを削除した場合は
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end

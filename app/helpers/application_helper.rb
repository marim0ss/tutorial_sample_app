module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  #ページタイトルが定義されていない場合は基本タイトル(base_title)を返す
    def full_title(page_title = '')
      base_title = "Ruby on Rails Tutorial Sample App"
      if page_title.empty?
        base_title           #returnなど不要。暗黙の戻り値
      else
        page_title + " | " + base_title      #文字列を結合
      end
    end
end

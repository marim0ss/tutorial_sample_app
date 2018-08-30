# DBにサンプルユーザーを作成する

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,# adiminカラムはdefault :false設定したが、このユーザーだけデフォで管理者にしておく
             activated: true,
             activated_at: Time.zone.now)   #Time.zone.nowはRailsの組み込みヘルパーであり、サーバーのタイムゾーンに応じたタイムスタンプを返します

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

#13.25サンプルデータに投稿を追加
  # order 最初の(idの小さい順)から指定
  # take(6) 6人だけ使う
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

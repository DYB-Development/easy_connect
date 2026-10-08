Rails.application.routes.draw do
  mount EasyConnect::Engine => "/easy_connect", defaults: { easy_connect_host: "dummy" }
  mount EasyConnect::Engine => "/owned", as: :owned_boards, defaults: { easy_connect_host: "owned" }
end

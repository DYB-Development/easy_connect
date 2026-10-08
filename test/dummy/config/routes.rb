Rails.application.routes.draw do
  mount EasyConnect::Engine => "/easy_connect", defaults: { easy_connect_host: "dummy" }
end

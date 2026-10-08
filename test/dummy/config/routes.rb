Rails.application.routes.draw do
  mount EasyConnect::Engine => "/easy_connect", defaults: { easy_connect_host: "dummy" }
  mount EasyConnect::Engine => "/owned", as: :owned_boards, defaults: { easy_connect_host: "owned" }

  get "billed/:id", to: ->(env) { [ 200, { "content-type" => "text/plain" }, [ "Billed board #{env["action_dispatch.request.path_parameters"][:id]}" ] ] }
end

EasyConnect.base_controller = "ApplicationController"

EasyConnect.host(:dummy)

EasyConnect.host(:owned).owner_method = :current_account

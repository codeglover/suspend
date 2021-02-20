Rails.application.routes.draw do
  root to: "pages#show", page: "solutions-journalism"
  resources :posts do
    resources :comments
  end
  get "/pages/:page" => "pages#show"
end

Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, only: [:show, :edit, :update]
    resources :posts, except: [:new]
  end


  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about', as: 'about'
    get 'users/unsubscribe' => 'users#unsubscribe', as: 'confirm_unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    get 'users/search' => 'searches#search'
    get 'users/tag_search' => 'tag_searches#search'

    scope '/users/:name' do
      # 下記アクション時にUserのnameカラムを取得するようcontrollerに記載する
      get '/followings' => 'relationships#followings', as: 'followings'
      get '/followers' => 'relationships#followers', as: 'followers'
      get '/likes' => 'likes#index', as: 'likes'
    end

    resources :users, param: :name, path: '/', only: [:show, :edit, :update] do
      resource :relationships, param: :user_id.name, path: '/', only: [:create, :destroy]
    end

    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end

    resources :chats, only: [:show, :create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do

  get '/search' => 'searches#search'
  get '/tag_search' => 'tag_searches#search'

  namespace :admin do
    get 'searches/search'
  end
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, param: :name, only: [:show, :edit, :update, :destroy]
    resources :posts, except: [:new, :create] do
      resources :post_comments, only: [:destroy]
    end
  end


  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in' => 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root 'homes#top'
    get '/about' => 'homes#about', as: 'about'

    # scope '/users/:name' do
    #   # 下記アクション時にUserのnameカラムを取得するようcontrollerに記載する
    #   get '/followings' => 'relationships#followings', as: 'followings'
    #   get '/followers' => 'relationships#followers', as: 'followers'
    #   get '/likes' => 'likes#index', as: 'likes'
    # end

    resources :users, param: :name, except: [:new, :create, :index] do
      resource :relationships, param: :user_id.name, only: [:create, :destroy]
    end

    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end

    resources :chats, only: [:show, :create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

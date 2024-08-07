Rails.application.routes.draw do

  namespace :public do
    get 'contacts/new'
    get 'contacts/confirm'
  end
  get '/search' => 'searches#search'

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, param: :name, only: [:show, :edit, :update, :destroy]
    resources :tags, only: [:index, :destroy]
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
    get 'sort_search' => 'posts#search'
    get '/tag_search' => 'posts#search_tag'

    resources :users, param: :name, except: [:new, :create, :index] do
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      member do
        get :likes
      end
      resource :relationships, only: [:create, :destroy]
    end

    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end

    resources :notifications, only: [:update]
    resources :contacts, only: [:new, :create] do
      collection do
        post 'confirm'
        post 'back'
        get 'done'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

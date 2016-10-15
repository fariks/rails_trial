Rails.application.routes.draw do
  resources :loads do
    resources :orders do
      delete 'unassign' => 'orders#unassign'
      post 'assign' => 'orders#assign'
    end
    get 'edit_orders' => 'loads#edit_orders'
    get 'download' => 'loads#download'
    post 'update_delivery_order' => 'orders#update_delivery_order'
  end

  post 'upload_orders' => 'loads#upload_orders'

  devise_for :users, :controllers => {:registrations => "registrations"}

  devise_scope :user do
    authenticated :user do
      root 'loads#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

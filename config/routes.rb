Rails.application.routes.draw do
  root "uploads#new"
  get "uploads/new"
  post "uploads/create"
  get "uploads/download"
end

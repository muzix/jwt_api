ActiveAdmin.register Server do
  batch_action :destroy, false
  
  permit_params :ip

  index do
    selectable_column
    id_column
    column :ip
  end

  filter :ip
end

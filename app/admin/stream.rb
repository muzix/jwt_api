ActiveAdmin.register Stream do
  batch_action :destroy, false

  index do
    selectable_column
    id_column
    column :user
    column :server do |record|
      record.server.ip
    end
    column :name
    column :play_url do |record|
      link_to(record.play_url,record.play_url)
    end
  end

  filter :user
  filter :server
  filter :name
end

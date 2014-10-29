include_recipe 'runit'

user node[:dusk][:user]

directory "#{node[:dusk][:root]}/shared/log" do
  owner node[:dusk][:user]
  recursive true
end

deploy_revision node[:dusk][:root] do
  repo node[:dusk][:repo]
  revision node[:dusk][:revision]
  symlink_before_migrate.clear
  keep_releases 0
  before_restart do
    execute 'bundle install --binstubs' do
      cwd release_path
    end
  end
  notifies :restart, 'runit_service[dusk]'
end

runit_service 'dusk' do
  action [:enable]
  default_logger true
  env(node[:dusk][:env].dup)
  options(node[:dusk].dup)
end

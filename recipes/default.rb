#
# Cookbook Name:: poise-ruby-example
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'

package %{libsqlite3-dev}

my_git_resource = 'railstutorial'

application '/srv/sample_app' do
  ruby '2.0'

  git my_git_resource do
    repository 'https://github.com/railstutorial/sample_app'
    destination '/srv/sample_app'
    revision 'master'
    notifies :run, "ruby_execute[notify-me]"
    notifies :run, "execute[this-works-though]"
    action :sync
  end

  bundle_install do
    deployment true
    without %w{development test}
  end

  ruby_execute 'notify-me' do
    command 'ruby -v'
    action :nothing
  end

  execute 'this-works-though' do
    command 'echo "Hello world!"'
    action :nothing
  end
 
  ruby_execute 'subscribes-also-works' do
    command 'ruby -e \'puts "This was a subscribes"\''
    action :nothing
    subscribes :run, "git[#{my_git_resource}]"
  end
end

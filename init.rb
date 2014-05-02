require 'redmine_rate'

Redmine::Plugin.register :redmine_rate do
  name 'Rate'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-rate'
  author_url 'http://www.littlestreamsoftware.com'
  description "The Rate plugin provides an API that can be used to find the rate for a Member of a Project at a specific date.  It also stores historical rate data so calculations will remain correct in the future."
  version '0.2.1'

  requires_redmine :version_or_higher => '2.0.0'

  # These settings are set automatically when caching
  settings(:default => {
             'last_caching_run' => nil
           })

  permission :view_rate, { }

  menu :admin_menu, :rate_caches, { :controller => 'rate_caches', :action => 'index'}, :caption => :text_rate_caches_panel
end

Rails.configuration.to_prepare do
  ApplicationController.send(:include, RateHelper)
  ApplicationController.send(:helper, :rate)

  TimeEntry.send(:include, RedmineRate::TimeEntryPatch) unless TimeEntry.included_modules.include? RedmineRate::TimeEntryPatch
  UsersHelper.send(:include, RedmineRate::UsersHelperPatch) unless UsersHelper.included_modules.include? RedmineRate::UsersHelperPatch
end



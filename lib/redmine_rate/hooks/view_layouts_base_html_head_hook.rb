module RedmineRate
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        stylesheet_link_tag "rate.css", :plugin => "redmine_rate"
      end
    end
  end
end

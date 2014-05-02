# Hooks to attach to the Redmine Projects.
class RateProjectHook < Redmine::Hook::ViewListener

  def protect_against_forgery?
    false
  end

  # Renders an additional table header to the membership setting
  #
  # Context:
  # * :project => Current project
  #
  def view_projects_settings_members_table_header(context={})
    return '' unless (User.current.allowed_to?(:view_rate, context[:project]) || User.current.admin?)
    return content_tag(:th, "#{l(:rate_label_rate)} #{l(:rate_label_currency)}")
  end

  # Renders an AJAX form to update the member's billing rate
  #
  # Context:
  # * :project => Current project
  # * :member => Current Member record
  #
  # TODO: Move to a view
  def view_projects_settings_members_table_row(context={})
    return '' unless (User.current.allowed_to?(:view_rate, context[:project]) || User.current.admin?)

    # Groups cannot have a rate
    return content_tag(:td,'') if context[:member].principal.is_a? Group
    rate = Rate.for(context[:member].principal, context[:project])

    return context[:controller].send(:render_to_string, {
      partial: "projects/settings_members",
      locals: {
        form_url: {
          :controller => 'rates',
          :action => 'create'
        },
        rate: rate,
        member: context[:member],
        project: context[:project]
      }
    })
  end

  def model_project_copy_before_save(context = {})
    source = context[:source_project]
    destination = context[:destination_project]

    Rate.find(:all, :conditions => {:project_id => source.id}).each do |source_rate|
      destination_rate = Rate.new

      destination_rate.attributes = source_rate.attributes.except("project_id")
      destination_rate.project = destination
      destination_rate.save # Need to save here because there is no relation on project to rate
    end
  end
end


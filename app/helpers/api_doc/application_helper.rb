module ApiDoc::ApplicationHelper
  
  def api_controller_id(string)
    string.gsub(/\W/, '_')
  end
  
  def api_controller_label(string)
    api_controller_id(string).humanize.titleize
  end
end
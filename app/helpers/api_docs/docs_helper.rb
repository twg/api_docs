module ApiDocs
  module DocsHelper

    def display_body(action)
      body = action['body']
      if (action['params']['format'].present? &&
          action['params']['format'] == 'json') ||
         action['params']['format'].blank?
        body = JSON.pretty_generate(action['body'])
      end
      body
    end
  end
end
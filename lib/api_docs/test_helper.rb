module ApiDocs::TestHelper
  
  # Method that allows test creation and will document results in a YAML file
  # Example usage:
  #   api_call(:get, '/users/:id', :id => 12345) do |doc|
  #     doc.description = 'Something for the docs'
  #     ... regular test code
  #   end
  def api_call(method, path, params = { }, &block)
    parsed_params = params.dup
    parsed_path   = path.dup
    
    parsed_params.each do |k, v|
      parsed_params.delete(k) if parsed_path.gsub!(":#{k}", v.to_s)
    end
    
    # Making actual test request. Based on the example above:
    #   get '/users/12345'
    doc = OpenStruct.new
    send(method, parsed_path, parsed_params)
    yield doc
    
    # Assertions inside test block didn't fail. Preparing file
    # content to be written
    c = request.filtered_parameters['controller']
    a = request.filtered_parameters['action']
    
    file_path = File.expand_path("#{c.gsub('/', ':')}.yml", ApiDocs.config.docs_path)
    params    = api_deep_clean_params(params)
    body      = JSON.parse(response.body)
    
    # Marking response as an unique
    key = Digest::SHA1.base64digest("
      #{method}#{path}#{params}#{response.status}#{api_deep_clean_params(body, :as_response)}
    ")
    
    data = if File.exists?(file_path)
      YAML.load_file(file_path) rescue Hash.new
    else
      Hash.new
    end
    
    data[a] ||= { }
    data[a][key] = {
      'description' => doc.description,
      'method'      => request.method,
      'path'        => path,
      'params'      => api_deep_clean_params(params),
      'status'      => response.status,
      'body'        => body
    }
    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, 'w'){|f| f.write(data.to_yaml)}
  end
  
  # Cleans up params. Removes things like File object handlers
  def api_deep_clean_params(params, as_response = false)
    result = { }
    params.each do |key, value|
      result[key.to_s] = case value
      when Hash
        api_deep_clean_params(value, as_response)
      when Rack::Test::UploadedFile
        'BINARY'
      else
        if as_response && ApiDocs.config.ignored_attributes.include?(key.to_s)
          'IGNORED'
        else
          value.to_s
        end
      end
    end
    result
  end
end

ActionDispatch::IntegrationTest.send :include, ApiDocs::TestHelper
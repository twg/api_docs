module ApiDocs::TestHelper
  
  # Method that allows test creation and will document results in a YAML file
  # Example usage:
  #   api_call(:get, '/users/:id', :id => 99) do |doc|
  #     doc.description = 'Something for the docs'
  #     ... regular test code
  #   end
  def api_call(method, path, params = { }, &block)
    data_path   = path.dup
    data_params = params.dup.stringify_keys
    
    params.each do |k, v|
      params.delete(k) if path.gsub!(":#{k}", v)
    end
    send(method, path, params)
    doc = OpenStruct.new
    yield doc
    
    controller  = request.filtered_parameters['controller']
    action      = request.filtered_parameters['action']
    file_path   = File.expand_path("#{controller.gsub('/', ':')}.yml", ApiDocs.config.docs_path)
    params      = api_deep_clean_params(params)
    key = Digest::SHA1.base64digest("#{method}#{path}#{params}#{response.status}#{response.body}")
    
    data = if File.exists?(file_path)
      YAML.load_file(file_path) rescue Hash.new
    else
      Hash.new
    end
    
    data[action] ||= { }
    data[action][key] = {
      'description' => doc.description,
      'method'      => request.method,
      'path'        => data_path,
      'params'      => api_deep_clean_params(data_params),
      'status'      => response.status,
      'body'        => JSON.parse(response.body)
    }
    File.open(file_path, 'w'){|f| f.write(data.to_yaml)}
  end
  
  # Cleans up params. Removes things like File object handlers
  def api_deep_clean_params(params)
    result = { }
    params.each do |key, value|
      result[key.to_s] = case value
      when Hash
        api_deep_clean_params(value)
      when Rack::Test::UploadedFile
        'BINARY'
      else
        value.to_s
      end
    end
    result
  end
end

ActionDispatch::IntegrationTest.send :include, ApiDocs::TestHelper
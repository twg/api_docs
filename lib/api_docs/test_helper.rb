module ApiDocs::TestHelper
  
  # Method that allows test creation and will document results in a YAML file
  # Example usage:
  #   api_call(:get, '/users/:id', :id => 12345) do |doc|
  #     doc.description = 'Something for the docs'
  #     ... regular test code
  #   end
  def api_call(method, path, params = { })
    parsed_params = params.dup
    parsed_path   = path.dup
    
    parsed_params.each do |k, v|
      parsed_params.delete(k) if parsed_path.gsub!(":#{k}", v.to_s)
    end
    
    # Making actual test request. Based on the example above:
    #   get '/users/12345'
    doc = OpenStruct.new
    send(method, parsed_path, parsed_params)

    yield doc if block_given?
    
    # Assertions inside test block didn't fail. Preparing file
    # content to be written
    c = request.filtered_parameters['controller']
    a = request.filtered_parameters['action']
    
    file_path = File.expand_path("#{c.gsub('/', ':')}.yml", ApiDocs.config.docs_path)
    params    = api_deep_clean_params(params)

    body      = JSON.parse(response.body) rescue {}
    
    # Marking response as an unique
    key = 'ID-' + Digest::MD5.hexdigest("
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
  # Sets up ignored values so we don't generate new keys for same data
  def api_deep_clean_params(params, as_response = false)
    case params
    when Hash
      params.each_with_object({}) do |(key, value), res|
        if as_response && ApiDocs.config.ignored_attributes.include?(key.to_s)
          res[key.to_s] = 'IGNORED'
        else
          res[key.to_s] = api_deep_clean_params(value, as_response)
        end
      end
    when Array
      params.collect{|value| api_deep_clean_params(value, as_response)}
    else
      case params 
      when Rack::Test::UploadedFile
        'BINARY'
      else
        params.to_s
      end
    end
  end
end

ActionDispatch::IntegrationTest.send :include, ApiDocs::TestHelper
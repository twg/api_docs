module ApiDocs::TestHelper
  
  module InstanceMethods
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
      
      if credentials = parsed_params.delete('HTTP_AUTHORIZATION')
        auth = {'HTTP_AUTHORIZATION' => credentials}
      end
    
      # Making actual test request. Based on the example above:
      #   get '/users/12345'
      doc = OpenStruct.new
      send(method, parsed_path, parsed_params, auth)

      yield doc if block_given?
    
      # Assertions inside test block didn't fail. Preparing file
      # content to be written
      c = request.filtered_parameters['controller']
      a = request.filtered_parameters['action']
    
      file_path = File.expand_path("#{c.gsub('/', ':')}.yml", ApiDocs.config.docs_path)
      params    = ApiDocs::TestHelper.api_deep_clean_params(params)
    
      # Marking response as an unique
      key = 'ID-' + Digest::MD5.hexdigest("
        #{method}#{path}#{doc.description}#{params}#{response.status}}
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
        'params'      => ApiDocs::TestHelper.api_deep_clean_params(params),
        'status'      => response.status,
        'body'        => response.body
      }
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, 'w'){|f| f.write(data.to_yaml)}
    end
  end
  
  # Cleans up params. Removes things like File object handlers
  # Sets up ignored values so we don't generate new keys for same data
  def self.api_deep_clean_params(params)
    case params
    when Hash
      params.each_with_object({}) do |(key, value), res|
        res[key.to_s] = ApiDocs::TestHelper.api_deep_clean_params(value)
      end
    when Array
      params.collect{|value| ApiDocs::TestHelper.api_deep_clean_params(value)}
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

ActionDispatch::IntegrationTest.send :include, ApiDocs::TestHelper::InstanceMethods
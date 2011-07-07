class Say < Sinatra::Base
  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/views"
  set :public, "#{dir}/public"
  set :static, true

  get '/' do
    erb :index
  end
  
  post '/say' do
    say params[:phrase]
    redirect '/' unless request.xhr?
  end

  def say(phrase)
    `say '#{phrase}'`
  end

  def url_path(*path_parts)
    [ path_prefix, path_parts ].join("/").squeeze('/')
  end
  alias_method :u, :url_path

  def path_prefix
    request.env['SCRIPT_NAME']
  end
end
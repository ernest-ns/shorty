Shooooort::Shorty.controllers :url_mappings do

  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get '/example' do
  #   'Hello world!'
  # end

  get :show, :map => '/:shortcode', :provides => [:json] do
    content_type :json
    @url_mapping = UrlMapping.lookup(params[:shortcode])
    halt 404, {error: 404, description: "The shortcode cannot be found in the system"}.to_json unless @url_mapping
    redirect @url_mapping.url
  end

  get :stats, :map => '/:shortcode/stats', :provides => [:json] do
    content_type :json
    @url_mapping = UrlMapping.where(shortcode: params[:shortcode]).take
    halt 404, {error: 404, description: "The shortcode cannot be found in the system"}.to_json unless @url_mapping
    last_seen_date = {}
    last_seen_date = {"lastSeenDate" => @url_mapping.last_seen_date.iso8601} if @url_mapping.redirect_count > 0
    {"startDate" => @url_mapping.start_date.iso8601, "redirectCount" => @url_mapping.redirect_count}.merge(last_seen_date).to_json
  end

  post :shorten, :map => '/shorten', :provides => [:json] do
    content_type :json
  end

end

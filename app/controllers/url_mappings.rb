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

  get :show, :map => '/:shortcode' do

  end

  get :stats, :map => '/:shortcode/stats' do

  end

  post :shorten, :map => '/shorten' do

  end

end

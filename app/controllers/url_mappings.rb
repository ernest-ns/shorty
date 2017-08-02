Shooooort::Shorty.controllers :url_mappings do

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
    request_body = JSON.parse(request.body.read.to_s).with_indifferent_access

    url_mapping = UrlMapping.create({url: request_body[:url], shortcode: request_body[:shortcode]})

    halt 400, {error: 400, description: UrlMapping.url_is_not_present_error_message}.to_json if url_mapping.url_is_not_present?
    halt 400, {error: 400, description: UrlMapping.url_is_invalid_error_message}.to_json  if url_mapping.invalid_url?
    halt 422, {error: 422, description: url_mapping.shortcode_regex_mismatch_error_message }.to_json unless url_mapping.shortcode_matches_regex?
    halt 409, {error: 409, description: url_mapping.shortcode_already_in_use_error_message }.to_json if url_mapping.shortcode_already_in_use?

    status 201
    {"shortcode" => url_mapping.shortcode}.to_json
  end
end

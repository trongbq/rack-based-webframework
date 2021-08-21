# frozen_string_literal: true

require './config/application'
require 'rack/lobster'

map '/lobster' do
    use Rack::ShowExceptions
    run Rack::Lobster.new
end

app = BestQuotes::Application.new

use Rack::ContentType

app.route do
    match '', 'quotes#index'
    match 'sub-app', proc { [200, {}, ['Hello, sub-app!']] }

    # Default routes
    match ':controller/:action/:id'
    match ':controller/:id', default: { 'action' => 'show' }
    match ':controller', default: { 'action' => 'index' }
end

run app

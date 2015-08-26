require 'rubygems'
require 'pdfkit'
require 'pry'
require 'rack/cors'
require 'sinatra'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/*', :headers => :any, :methods => [:get, :post]
  end
end

get "/" do
  File.read(File.join('public', 'index.html'))
end

post '/render' do
  html = params[:html].gsub(/\r\n/, '') || ""

  response.headers['Content-Type'] = 'application/pdf'
  response.headers['Content-Disposition'] = "attachment; filename=resume.pdf"

  kit = PDFKit.new(html,
    "margin-top" => "20mm", "margin-bottom" => "20mm",
    "margin-left" => "0mm", "margin-right" => "0mm"
  )

  kit.to_pdf
end

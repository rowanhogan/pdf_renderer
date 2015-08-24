require 'rubygems'
require 'json'
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

post '/render/' do
  html = params[:html].gsub(/\r\n/, '')
  response.headers['Content-Type'] = 'application/pdf'
  response.headers['Content-Disposition'] = "attachment; filename=resume.pdf"
  kit = PDFKit.new(html)
  kit.stylesheets << File.open(settings.public_folder.to_s + '/style.css')
  kit.stylesheets << File.open(settings.public_folder.to_s + '/fonts.css')
  kit.to_pdf
end

post '/resume/render/' do
  @resume = params[:resume]
  @extras = params[:extras]
  response.headers['Content-Type'] = 'application/pdf'
  response.headers['Content-Disposition'] = "attachment; filename=resume.pdf"

  kit = PDFKit.new(erb(:resume))
  kit.stylesheets << File.open(settings.public_folder.to_s + '/style.css')
  kit.stylesheets << File.open(settings.public_folder.to_s + '/fonts.css')
  kit.to_pdf
end

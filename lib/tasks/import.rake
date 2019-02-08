namespace :import do
  desc 'Import PDF files from DIR'
  task pdfimport: :environment do
    dir = ENV['dir'] || Rails.root

    Dir.foreach(dir) do |x|
      Order.self_pdf_import(dir + x) if x.to_s != '.' && x.to_s != '..'
    end
  end
end

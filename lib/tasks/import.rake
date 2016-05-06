
namespace :import do

  desc "Import PDF files from DIR"
  task :pdfimport => :environment do
    dir = ENV['dir'] ?  ENV['dir'] : Rails.root

    Dir.foreach(dir) {|x|
      if x.to_s != '.' and x.to_s != '..'
        Order.self_pdf_import(dir+x)
      end
    }
  end



end

class Order < ApplicationRecord
  has_many :items, dependent: :destroy

  DATA_CONDITION = "created_at >= ? AND created_at < ?"

  scope :today, -> { where(DATA_CONDITION, Time.now.beginning_of_day, Time.now.end_of_day) }
  scope :yesterday, -> { where(DATA_CONDITION, Time.now.ago(1.day).beginning_of_day, Time.now.ago(1.day).end_of_day) }
  scope :this_month, -> { where(DATA_CONDITION, Time.now.beginning_of_month, Time.now.end_of_month) }
  scope :previous_month, -> { where(DATA_CONDITION, Time.now.ago(1.month).beginning_of_month, Time.now.ago(1.month).end_of_month) }
  scope :this_year, -> { where(DATA_CONDITION, Time.now.beginning_of_year, Time.now.end_of_year)}
  scope :previous_year, -> { where(DATA_CONDITION, Time.now.ago(1.year).beginning_of_year, Time.now.ago(1.year).end_of_year) }

  require 'csv'

  def import(file)
    CSV.foreach(file.path, headers: true) do |row|
      items = Product.where(name: row['Prekės pavadinimas'], ean: row['EAN Kodas']).all
      if items.count > 0
        #pakesiti !!!!
        item = items.first
      else
        item = Product.create(name: row['Prekės pavadinimas'], ean: row['EAN Kodas'])
      end

      Item.create(order_id: id, product_id: item.id, price: row['Suma su nuolaida'], amount: row['Surinktas Kiekis'], full_price: row['Kaina (vnt/kg)'])
    end
  end

  def self_pdf_import(file)
    Order.self_pdf_import(file.path, self)
  end

  def Order.self_pdf_import(file_path, order = nil)
    t = Time.now.to_i
    files = `pdftohtml -c #{file_path} /tmp/#{t}.html`
    order = order.nil? ? Order.check_file("/tmp/#{t}-1.html") : order
    puts file_path
    if files.to_s.include?('Page-2')
      order.import_nikogiri("/tmp/#{t}-1.html", 1)
      order.import_nikogiri("/tmp/#{t}-2.html", 2)
    else
      order.import_nikogiri("/tmp/#{t}-1.html")
    end

   # `rm -rf /tmp/#{t}*`
  end

  def Order.check_file(file_path)
    html_doc = File.open(file_path) { |f| Nokogiri::HTML(f) }
    ps = html_doc.css('p')
    ino=''
    ps.each_with_index { |p, index|

      if p.text.to_s.include?('UŽSAKYMO Nr.')
        ino=index
      end
    }
    Order.find_or_create_by(no: ps[ino].text.to_s.split('Nr.').last.to_s.strip)
  end

  def import_nikogiri(file_path, version=1)
    html_doc = File.open(file_path) { |f| Nokogiri::HTML(f) }
    ps = html_doc.css('p')

    if version == 1
      iean = 44
      iname = 45
      iqt = 47
      ifprice = 48
      iprice = 49
    end
    if version == 2
      iean = 3
      iname = 4
      iqt = 6
      ifprice = 7
      iprice = 8
    end

    ean = ''
    name = ''
    qt = ''
    fprice = ''
    price = ''

    nexti = 0
    depoz = 0
    stop = 0

    l = 0
    ps.each_with_index { |p, index|
      if version == 1

        if p.text.to_s.include?('UŽSAKYMO Nr.')
          self.no = p.text.to_s.split('Nr.').last.to_s.strip
          self.save
        end
        if l == 1
          self.created_at = p.text.to_s.split('/').first.to_s.delete('DATA')
          self.save
          l=0
        end
        if p.text.to_s.include?('Prekių pristatymo data ir laikas')
          l =1
        end
      end
      if version == 2
        if p.text.to_s.include?('Jums priklauso')

          iean =index+2
          iname=index+3
          iqt =index+5
          ifprice = index+6
          iprice =index+7

        end

      end

      if depoz == 1
        if p.text.to_s.include?('Lt')
          self.depozit=p.text.to_s.delete('Lt').gsub(',', '.').to_d * 0.289620019
        else
          self.depozit = p.text.to_s.delete(' €').gsub(',', '.')
        end
        self.save
        depoz=0
      end

      if nexti == 1
        if p.text.to_s.include?('Lt')
          self.price=p.text.to_s.delete('Lt').gsub(',', '.').to_d * 0.289620019
        else
          self.price = p.text.to_s.delete(' €').gsub(',', '.')
        end

        self.save
        nexti=0
      end

      if p.text.to_s.include?('EAN Kodas')

        iean =index+11
        iname=index+12
        iqt =index+14
        ifprice = index+15
        iprice =index+16

      end
      #table +-18
      if p.text.to_s.include?('Apmokestinama') or p.text.to_s.include?('Pristatymo mokestis') or p.text.to_s.include?('Suma be PVM') or p.text.to_s.include?('SumabePVM') or p.text.to_s.include?('Prekes pristačiau:')
        stop =1
      end

      if stop == 0
        if iean == index
          i=0
          #numeris

          ean=p.text.to_s
          if ean.to_s[-1, 1].include?(',')
            iean+=1
            iname+=1
            iqt+=1
            ifprice+=1
            iprice+=1
            ean+=p.text.to_s
          else
            iean +=7
          end
          name= ''
          qt=''
          fprice=''
          price=''
          # logger.debug "ean: #{ean}--- index:#{index}--- iean:#{iean}"
        end
        if iname == index
          #numeris
          iname +=7
          name = p.text.to_s
        end
        if iqt == index
          #numeris
          iqt +=7
          qt = p.text.to_s.delete(' €')
        end
        if ifprice == index
          #numeris
          ifprice +=7
          fprice = p.text.to_s.delete(' €')
        end
        if iprice == index
          #numeris
          iprice +=7
          price = p.text.to_s.delete(' €')

          i=1
        end


        if i == 1
          items = Product.where(name: name, ean: ean).all
          if items.count > 0
            #pakesiti !!!!
            item = items.first
          else
            item = Product.create(name: name, ean: ean)
          end
          if price.include?('Lt') or fprice.include?('Lt')
            price = price.delete('Lt').gsub(',', '.').to_d * 0.289620019
            fprice = fprice.delete('Lt').gsub(',', '.').to_d * 0.289620019
          else
            price = price.gsub(',', '.')
            fprice = fprice.gsub(',', '.')
          end
         # puts price
          #puts fprice
          #puts index
          #puts '-------------------'
          it = Item.where(order_id: self.id, product_id: item.id, price: price, amount: qt.delete('vnt.').delete('kg').gsub(',', '.').to_d, full_price: fprice, created_at: self.created_at).first
          if !it
            Item.create(order_id: self.id, product_id: item.id, price: price, amount: qt.delete('vnt.').delete('kg').gsub(',', '.'), full_price: fprice, created_at: self.created_at)
          end
        end


      end


      if p.text.to_s.include?('Depozitas')
        depoz=1
        stop =1
      end
      if p.text.to_s.include?('Bendra suma') or p.text.to_s.include?('SUMA su PVM')
        nexti=1
        stop =1
      end

      if p.text.to_s.include?('Su AČIŪ kortele suteikta nuolaida') and index > 0
        self.discount = p.text.to_s.delete('Su AČIŪ kortele suteikta nuolaida').delete(' €').gsub(',', '.')
        self.save
        stop =1
      end

      if p.text.to_s.include?('Prekespristačiau:') and index > 0
        self.save
        stop =1
      end

      if p.text.to_s.include?('Gauta MAXIMA pinigų už šį pirkinį') and index > 0
        self.maxima = p.text.to_s.delete('Gauta MAXIMA pinigų už šį pirkinį').delete(' €').gsub(',', '.')
        self.save
        stop =1
      end
    }
  end
end

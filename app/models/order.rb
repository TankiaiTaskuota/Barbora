class Order < ApplicationRecord

  has_many :items, dependent: :destroy
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

      Item.create(order_id: self.id, product_id: item.id, price: row['Suma su nuolaida'], amount: row['Surinktas Kiekis'], full_price: row['Kaina (vnt/kg)'])
    end
  end

  def import_nikogiri(file)
    html_doc = File.open(file.path) { |f| Nokogiri::HTML(f) }
    ps = html_doc.css('p')


    iean =44
    iname=45
    iqt =44
    ifprice = 45
    iprice =46
    ean=''
    name= ''
    qt=''
    fprice=''
    price=''

    nexti=0

    ps.each_with_index { |p, index|
      if index == 9
        self.no = p.text.to_s.split('Nr.').last.to_s

      end
      if index == 10
        self.created_at = p.text.to_s.split('/').first.to_s
        self.save
      end

      if nexti == 1
        self.price = p.text.to_s.delete(' €').gsub(',', '.')
        self.save
        nexti=0
      end

      if p.text.to_s.include?('Kitos prekės:')

        iean =index+13
        iname=index+14
        iqt =index+16
        ifprice = index+17
        iprice =index+18

      end
      #table +-18

      if nexti == 0
        if iean == index
          i=0
          #numeris

          ean=p.text.to_s
          if ean.to_s.include?(',')
            iean+=1
            iname+=1
            iqt+=1
            ifprice+=1
            iprice+=1
          else
            iean +=7
            ean+=p.text.to_s
          end
          name= ''
          qt=''
          fprice=''
          price=''
          logger.debug "ean: #{ean}, index:#{index}, iean:#{iean}"
        end
        if iname == index
          #numeris
          iname +=7
          name = p.text.to_s
          logger.debug "name: #{name}, index:#{index}, ianme:#{iname}"
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
          logger.debug "index:#{index}, name: #{name}, price:#{price}, price:#{price.to_d}"
          Item.create(order_id: self.id, product_id: item.id, price: price.gsub(',', '.'), amount: qt.gsub(',', '.'), full_price: fprice.gsub(',', '.'), created_at: self.created_at)
        end


      end
      if p.text.to_s.include?('Bendra suma')
        nexti=1
      end


    }


  end
end

# frozen_string_literal: true

module Orders
  # Order Import service
  class NikogiriImport
    MAXIMA_MONEY = 'Gauta MAXIMA pinigų už šį pirkinį'
    DISCOUNT = 'Su AČIŪ kortele suteikta nuolaida'

    def initialize(order, file_path, version)
      @order = order
      @file_path = file_path
      @version = version
      set_columns
    end

    def call
      html_doc = File.open(@file_path) { |f| Nokogiri::HTML(f) }
      ps = html_doc.css('p')

      ean = ''
      name = ''
      qt = ''
      fprice = ''
      price = ''

      ps.each_with_index { |p, index|
        order_number(p.text.to_s)
        order_date(p.text.to_s)
        prepare_version_2_collumns(p.text.to_s, index)
        deposit_count(p.text.to_s)
        price_count(p.text.to_s)
        reculcalate_columns(p.text.to_s, index)
        stop_quard_marker(p.text.to_s, index)

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
        mark_deposit(p.text.to_s)
        mark_price(p.text.to_s)
        discount_count(p.text.to_s)
        stop_quard_marker(p.text.to_s, index)
        maxima_count(p.text.to_s)
      }
    end

    private

    def stop_quard_marker(string, index)
      if string.include?('Apmokestinama') ||
         string.include?('Pristatymo mokestis') ||
         string.include?('Suma be PVM') || string.include?('SumabePVM') ||
         string.include?('Prekes pristačiau:')
        @stop = 1
      end
      if string.include?('Prekespristačiau:') && index.posityve?
        @order.save
        @stop = 1
      end
    end

    def reculcalate_columns(string, index)
      return unless string.include?('EAN Kodas')

      @item_number = index + 11
      @item_name = index + 12
      @item_quantinty = index + 14
      @item_full_price = index + 15
      @item_price = index + 16
    end

    def prepare_version_2_collumns(string, index)
      return unless @version == 2 && string.include?('Jums priklauso')

      @item_number = index + 2
      @item_name = index + 3
      @item_quantinty = index + 5
      @item_full_price = index + 6
      @item_price = index + 7
    end

    def order_number(string)
      return unless @version == 1 || p.text.to_s.include?('UŽSAKYMO Nr.')

      @order.no = string.split('Nr.').last.to_s.strip
      @order.save
    end

    def order_date(string)
      return unless @version == 1

      if @order_date
        @order.created_at = string.split('/').first.to_s.delete('DATA')
        @order.save
        @order_date = false
      end
      @order_date = true if string.include?('Prekių pristatymo data ir laikas')
    end

    def set_columns
      @item_number = @version == 1 ? 44 : 3
      @item_name = @version == 1 ? 45 : 4
      @item_quantinty = @version == 1 ? 47 : 6
      @item_full_price = @version == 1 ? 48 : 7
      @item_price = @version == 1 ? 49 : 8
      @nexti = false
      @deposit = false
      @stop = false
      @order_date = false
    end

    def mark_deposit(string)
      return unless string.include?('Depozitas')

      @deposit = true
      @stop = true
    end

    def mark_price(string)
      return unless string.include?('Bendra suma') && string.include?('SUMA su PVM')

      @nexti = true
      @stop = true
    end

    def price_count(string)
      return unless @nexti

      @order.price = converted_number(string)
      @order.save
      @nexti = false
    end

    def deposit_count(string)
      return unless @deposit

      @order.depozit = converted_number(string)
      @order.save
      @deposit = false
    end

    def discount_count(string)
      return if !string.include?(DISCOUNT) || !index.positive?

      @order.discount = number(string.delete(DISCOUNT))
      @order.save
      @stop = true
    end

    def maxima_count(string)
      return if !string.include?(MAXIMA_MONEY) || !index.positive?

      @order.maxima = number(string.delete(MAXIMA_MONEY))
      @oder.save
      @stop = true
    end

    def number(string)
      string.delete(' €').gsub(',', '.')
    end

    def converted_number(string)
      return number(string) unless string.include?('Lt')

      string.delete('Lt').gsub(',', '.').to_d * 0.289620019
    end
  end
end

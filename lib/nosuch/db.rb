require 'nokogiri'
require 'open-uri'
require 'json'
require 'mongo'
require 'mongo/driver'
require 'rspec'
require "#{File.dirname(__FILE__)}/../searchs"

module Client

  module Nosuch

    module Database

      def make_json(key)
        json = make_histogram(key)
        puts json
        name = "nosuch_languages_#{key}.json"
        p = "#{File.dirname(__FILE__)}/../../public/stats/#{name}"
        p = File.expand_path p
        File.open(p, "w+") do |f|
          p "=> Generating #{p}"
          f.write json.to_json
          f.close()
        end
        "/stats/#{name}"
      end

      def get_db
        connection = Mongo::Connection.new
        db = connection.nosuch
        db
      end

      def get_nosuch_languages
        Nokogiri::HTML(open(SRC))   
      end

      def histogram(h, v)
        unless h[v]
          h[v] = 1
        else
          h[v] += 1
        end
      end
        
      def make_histogram(key)
        children =  Hash.new
        db = get_db()
        
        db.languages.all do |doc|
          #puts doc
          doc.each_pair{|k, v|
            if(k == "year" )
              puts "=> found by #{k}:"
              puts doc
              r = v.gsub(/[0-9]+/)
              r.each{|s|
                histogram(children, s)
              }
            elsif(k == "implementation")
              Client::NosuchSearch::LANGUAGES.each{|e| 
                 if(v.scan(e).length>0)
                   puts "=> found by #{k}:"
                   puts doc
                   histogram(children, v.scan(e)[0])
                 end
              }
            end
          } #doc
        end #all
        puts children
        children = children.map{|k, v|
          {:name =>k, :value => v}
        }
        {"name" => key, "children" => children}
      end

      def go_table(doc)

        doc.css("table[width=\"100%\"]").each{|table| 
          subtables = table.at_css("table[width=\"100%\"]")
          if(subtables)
            tds = subtables.css("td")
            if(tds)
              yield tds
            end
          end
        }
      end

      def build(doc)
        hash = Hash.new
        go_table(doc){|tds|
          k = tds[0].text === "" ? "unknown" : tds[0].text
          unless(hash[k])
            if(k != "unknown")
              hash[k] = Hash.new
              (2..16).step(2).each{|i|
                kk = tds[i-1].text.split(":")[0].downcase
                hash[k][kk] = tds[i].text === "" ? "unknown" : tds[i].text
              }
            end
          end
          
        }
        c = hash.to_a.map{|e|
          h = Hash.new
          h["name"] = e[0]
          e[1].each{|k, v| h[k] = v}
          h
        }
        c
      end
      
      def save_all(doc) 
        p "=> building languages"
        builded = build(doc)
        puts builded
        puts "=> Acessing mongodb"
        db = get_db
        p "=> dropping"
        db.drop
        builded.each{|elem| 
          db.languages.save elem do |_doc|
            "=> saving #{doc["Name"]}"
          end
        }
        p "=> added #{db.count()} documents"
      end
      
    end
  end
  
end



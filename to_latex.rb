require "#{File.dirname(__FILE__)}/searchs"

def figure(&block)
  """\\begin{figure}
\\begin{center}
#{yield}
\\end{center}
\\end{figure}

"""
end


def create_total(hash, &block)
  Dir.glob("./main/total_*.yml").each do |file|
    name = File.basename(file).split(".yml")[0]
    name = name.split("total")[1]
    name = name[1..name.length-1]
    hash[name] = Hash.new
    
    abs_path = File.absolute_path file
    splits = name.split("_")
    client = splits[0].capitalize
    tags = splits[1..splits.length-1]

    _absdir = File.absolute_path "#{File.dirname(file)}"
    yield _absdir, client, tags, name, hash[name]
    
  end
end

def graphics(imgdir, name, e, client, tags, scale)
  ee= e.gsub(/\_/, " ") if(/\_/ =~ e)
  s_tags = tags.map{|e| e}.join(" ")
  """\\includegraphics[scale=#{scale}]{#{imgdir}/#{name}_#{e}.png}
\\caption{Representa\\c{c}\\~{a}o gr\\'{a}fica do par\\^{a}metro \\textbf{#{ee}} das produ\\c{c}\\~{o}es realizadas no \\textbf{#{client}} a partir da tag \\emph{#{s_tags}}}"""
end

def section(name)
  "\\subsection{#{name}}\n"
end

def create
  hash = Hash.new
  s = ""
  
  create_total hash do |absdir, client, tags, name, _hash|
    imgdir = absdir.gsub(/main/, "public/images")
    s_tags = tags.map{|e| e}.join(" ")
    _hash[:raw] = figure do 
      """\\lstinputlisting[firstline=0,lastline=20]{#{absdir}/#{name}.yml}
\\caption{Dados parciais de informa\\c{c}\\~{o}es brutas obtidas na rede social \\textbf{#{client}} a partir da tag \\emph{#{s_tags}}.}"""
    end

    if(client == "Soundcloud")
      Client::SoundcloudSearch::STATS.each{|e|
        _hash[:raw] << figure do 
          graphics imgdir, name, e, client, tags, 0.6
        end
      }

      _hash[:raw] << "\\clearpage" << "\n"

    elsif(client == "Github")
      Client::GithubSearch::STATS.each{|e|
        _hash[:raw] << figure do 
          graphics imgdir, name, e, client, tags, 0.6
        end
      }

      _hash[:raw] << "\\clearpage" << "\n"
    end
  end

  hash.each{|k, v|

    s << v[:raw] << "\n"
  }
  s
end

s = create()

File.open("./latex/dados.tex", "w+") do |f|
  f.write s
  f.close()
end


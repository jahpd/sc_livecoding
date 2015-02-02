require 'octokit'
require 'yaml'
require "#{File.dirname(__FILE__)}/githubclient_base"
require 'ruby-progressbar'


module Client

  module GithubSearch

    class Builder

      include Methods

      public
      
      STRING = "---"
      
      def initialize(q)
        
        init_client
        
        puts """***************
searching for #{q}
*****************"""
        
        _q = @client.legacy_search_repositories(q)
        @total_repo = 0
        puts "Found #{_q.length}"
        
        s = ""

        pb = ProgressBar.create(:title => "Downloading", :starting_at => 0, :total => _q.length)
        # Every term found in q
        _q.each do |resource|
          string = ""
        
          # get basic information
          process_basic_info string, resource

          #get information about contribuitors
          process_contributions string, "#{resource.owner}/#{resource.name}"
          
          # Total of works
          @total_repo = @total_repo + 1

          #concatenate
          s << string
          
          pb.increment
        end
        
        # this is needed, do not modify
        if(/\ / =~ q)
          q.gsub!(/\ /, "_") 
        end
        
        p = "main/github_#{q}.yml"
        puts "creating #{p}"
        
        File.open(p, "w+") do |f|
          f.write s
          f.close()
        end
      
        pp = "main/total_github_#{q}.yml"
        puts "creating #{pp}"
        File.open(pp, "w+") do |f|
          f.write "total: #{@total_repo}"
          f.close()
        end
        
        @total_repo = 0
    end
      
    end
    
  end
  
end

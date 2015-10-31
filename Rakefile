require 'rake'
require 'spec/rake/spectask'

task "get:soundcloud:fonts" do 
  sh "ruby get_soundcloud.rb"
end

task "get:github:fonts" do 
  sh "ruby get_github.rb"
end

task "app:1" do
  sh "ruby app.rb"
end

task "app:2" do
  sh "ruby app2.rb"
end

Spec::Rake::SpecTask.new(:languages) do |t|
  t.spec_files = FileList['lib/test*.rb']
  t.options = '-v'
end

task "test:languages"  => :languages

# SC_Livecoding

Esse pequeno programa baseado no [Sinatra](http://www.sinatrarb.com/)
e nas APIs do [Soundcloud](https://developers.soundcloud.com/docs/api/reference#tracks) e [Github-Octokit](https://github.com/octokit/octokit.rb) para buscar informacoes pertinentes à prática de [livecoding](http://www.toplap.org)

# Instalando

É necessário ter o Ruby instalado (e um computador de sistema UNIX, linux ou macosx). Sugiro buscar em [RVM](https://rvm.io/) para maiores informações. Após isso clone o projeto:

    $ git clone https://www.github.com/jahpd/sc_livecoding.git
    $ cd sc_livecoding
    $ bundle install

# Crie uma base de dados

Antes de tudo, eh necessario criar uma base de dados. A base de dados é baseada em MongoDB e deve estar na pasta raiz do projeto:

    $ cd sc_livecoding
    $ mkdir data/
    $ mkdir data/db

Para iniciar a base de dados:

    $ sudo mongod --dbpath=./data/db &

## Atualizando a base de dados

Anstes de tudo serão necessárias credenciais. Crie uma conta [aqui](https://soundcloud.com/login?return_to=%2Fyou%2Fapps%2Fnew) para registrar um novo aplicativo soundcloud (sua versão). 

Crie um arquivo `soundcloud.yml`:

~~~{.yaml}
client_id: YOUR_KEY
client_secret: YOUR_SECRET
~~~

Para baixar os dados:

    $ ruby get_soundcloud.rb

Pode levar um tempo baixar varios dados, portanto paciencia...

Se voce queiser mudar os parametros de busca: precisamos modificar o
arquivo `searchs.rb`:

~~~{.ruby}
module Client

  module SoundcloudSearch

    SEARCHS = ["webaudio", "algorithmic music", "livecoding", 
               "live-coding", "livecoding music", 
               "livecoding sound", "livecoding noise",
               "wavepot", "bytebeat", "algorave", "algopop"]

    STATS = ["created_at", "country", "city", "genre", "license"]

  end
end
~~~

# Correndo o servidor

Apenas execute

    $ ruby app.rb

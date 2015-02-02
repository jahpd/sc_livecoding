# SC_Livecoding

Esse pequeno programa baseado no [Sinatra](http://www.sinatrarb.com/)
utiliza APIs do
[Soundcloud](https://developers.soundcloud.com/docs/api/reference#tracks)
e [Github-Octokit](https://github.com/octokit/octokit.rb) para buscar
informacoes pertinentes a pratica de
[livecoding](http://www.toplap.org)

# Instalando

Suponho que tu usas Ruby (e um computador de sistema UNIX, linux ou
macosx), se n tive instale atraves do
[RVM](https://rvm.io/); depois de instalado, baixe a fonte deste
projeto

    $ git clone https://www.github.com/jahpd/sc_livecoding.git
    $ cd sc_livecoding
    $ bundle install

# Usando

Antes de tudo, eh necessario criar dois arquivos: `soundcloud.yml` e
`github.yml`; eles serao responsaveis pela autenticacao das APIs no
seu programa clonado. Primeiro tens de ir
[aqui](https://soundcloud.com/login?return_to=%2Fyou%2Fapps%2Fnew)
para registrar um novo aplicativo soundcloud; com seu aplicativo
criado, copie e cole as credenciais:


    $ emacs soundcloud.yml

~~~{.yaml}
client_id: YOUR_KEY
client_secret: YOUR_SECRET
~~~

    $ emacs github.yml

~~~{.yaml}
login: YOUR_ID
password: YOUR_PASS
~~~

Dai eh necessario baixar os dados
pertinentes, para isso, vc pode correr:

    $ ruby get_soundcloud.rb

ou

    $ ruby get_github.rb

Pode levar um tempo baixar varios dados, portanto paciencia...

Se voce queiser mudar os parametros de busca: precisamos modificar o
arquivo `searchs.rb`:

~~~{.ruby}
module Client

  module GithubSearch

    SEARCHS = ["webaudio", "audio javascript", 
               "JIT audio javascript", "wavepot", 
               "gibber audio", "bytebeat", 
               "audio livecoding", "music livecoding"]
               "web audio", "webaudioapi"]
               
    STATS = ["created_at", "language", "contributors"]

  end

  module SoundcloudSearch

    SEARCHS = ["webaudio", "algorithmic music", "livecoding", 
               "live-coding", "livecoding music", 
               "livecoding sound", "livecoding noise",
               "wavepot", "bytebeat", "algorave", "algopop"]

    STATS = ["created_at", "country", "city", "genre", "license"]

  end
end
~~~

## correndo o servidor

Apenas execute

    $ ruby app.rb

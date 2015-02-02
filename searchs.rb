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


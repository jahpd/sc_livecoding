
require "rubypython"

module Client
  module Wordcloud

    # Result Must be
    #def results
      #object = [['work', 'will', 'also', 'performer', 'instrument', 'musical', 'use', 'coder', 'process', 'state', 'example', 'way', 'software', 'research', 'using', 'many', 'problem', 'experience', 'design', 'used', 'improvisation', 'different', 'machine', 'pattern', 'audio', 'may', 'network', 'based', 'first', 'interface', 'environment', 'data', 'writing'], '0': ['text', 'form', 'context', 'musician', 'two', 'University', 'real', 'However', 'space', 'paper', 'program', 'audience', 'function', 'change', 'might', 'within', 'control', 'human', 'laptop', 'interaction', 'structure', 'part', 'make', 'session', 'tool', 'result', 'create', 'object', 'case', 'electronic', 'visual', 'Davies', 'ensemble', 'algorithm', 'value', 'development', 'material', 'set', 'technique', 'parameter', 'Proceedings', 'output', 'idea', 'screen', 'video', 'application', 'support', 'al', 'Blackwell', 'composition', 'well', 'piece', 'Conference', 'world', 'et', 'rather', 'solving', 'Figure', 'McLean', 'SuperCollider', 'knowledge', 'feature', 'cell', 'become', 'activity', 'Gibber', 'art', 'possible', 'free', 'action', 'Sonic', 'without', 'even', 'information', 'method', 'web', 'rule', 'provide', 'livecoding', 'group', 'need', 'particular', 'often', 'aspect', 'project', 'allow', 'Collins', 'collaboration', 'making', 'programmer', 'member', 'play', 'another', 'developed', 'shared', 'browser', 'made', 'open', 'potential', 'point', 'approach', 'take', 'order', 'node', 'collaborative', 'number', 'processes', 'source', 'similar', 'present', 'community', 'server', 'see', 'framework', 'orchestra', 'digital', 'level', 'term', 'kind', 'important', 'ACM', 'Grossi', 'type', 'International', 'Pi', 'memory', 'analysis', 'line', 'body', 'people', 'less', 'concept', 'cognitive', 'virtual', 'technology', 'Although', 'explore', 'working', 'org', 'current', 'networked', 'show', 'mean', 'end', 'future'],, '2': ['programming', 'system', 'computer', 'user', 'language', 'time', 'practice', 'sound', 'new', 'one'], '5': ['music'], '4': ['performance', 'code'], '6': ['coding'], '9': ['live']}
    #end

    def getList(&block)
      RubyPython.start_from_virtualenv("/usr/bin/python") # start the Python interpreter
      #RubyPython.activate
      #wc = RubyPython.import("wc_livecoding")
      #list = method(:getLists)   
      RubyPython.stop # stop the Python interpreter
      #yield list
    end
  
  end

  module GithubSearch

    

    SEARCHS = ["webaudio", "audio javascript", 
               "JIT audio javascript", "wavepot", 
               "gibber audio", "bytebeat", 
               "audio livecoding", "music livecoding",
               "web audio", "webaudioapi"]

    STATS = ["created_at", "language", "contributors"]

  end

  module SoundcloudSearch

    SEARCHS = ["webaudio", "algorithmic music", "livecoding", "live-coding","livecoding music", "livecoding sound", "livecoding noise","wavepot", "bytebeat", "algorave", "algopop", "glitch", "gltch", "tamborzao","pancadao"]

    STATS = [ "year", "month", "country", "city", "genre", "license"]

  end

  module NosuchSearch

    LANGUAGES = ["Macro", "C", "unknown", "Lisp", "Algol", "C++", "Assembler", "SAIL", "Fortran IV", "Java", "LISP", "Forth", "Objective C", "Scheme", "XLisp", "assembler", "Haskell", "Common Lisp", "VBScript", "JavaScript", "Nasal", "Smalltalk", "basic", "Visual Basic", "Adaggio", "XPL", "APL", "PL/I", "TCL/TK", "python", "MAX", "implementation-independant", "Ada", "Tcl"]

    PAPERS = ["Computer Music Journal", "International Computer Music Conference", "ICMC"]

    SEARCHS = ["year", "implementation"]
  end
end


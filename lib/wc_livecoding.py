from os import path
from wordcloud import WordCloud
import math
import nltk

def wc(f):
    d = path.dirname(__file__)

    # Read the whole text.
    text = open(path.join(d, f)).read()
    # Generate a word cloud image
    return WordCloud().generate(text)

def getLists(wc):

    # Generate semi-quantitivite regions
    d = {}
    for i in range(0,10):
        x = []
        for el in wc.words_:
            if el[1] > i/10.0 and el[1] <= (i+1)/10.0:
                if len(el[0]) > 1:
                    x.append(el[0])
          
        d[str(i)] = y = {}

        #tagged = nltk.FreqDist(tag for (word, tag) in nltk.pos_tag(x))
        tagged = nltk.pos_tag(x)
        freq = nltk.FreqDist(tag for (word, tag) in tagged)
        z = freq.most_common()
        for (tag, n) in freq.most_common():
            y[tag] = [word for (word, _tag) in tagged if tag == _tag]
 
    return d

d =  getLists(wc('iclc2015_proceedings.txt'))

def test():
    #http://arxiv.org/pdf/1104.2086v1.pdf
    for k in d:
        print "# %s:\n" % k
        for v in d[k]:
            tagp = ""
            if v == "NN":
                tagp = "Substantivo"
            elif v == "NNS":
                tagp = "substantivo, comum, plural"
            elif v == "NNP":
                tagp = "substantivo, apropriado, singular"
            elif v == "VB":
                tagp = "verbo"
            elif v == "VBD":
                tagp = "verbo, preterito"
            elif v == "VBN":
                tagp = "verbo, participio passado"
            elif v == "VBG":
                tagp = "verbo, participio presente ou gerundio"
            elif v == "VBZ":
                tagp = "verbo, presente, 3a pessoa do singular"
            elif v == "CD":
                tagp = "numeral/cardinal"
            elif v == "RB":
                tagp = "Adverbio"
            elif v == "IN":
                tagp = "numeral/cardinal"
            elif v == "DT":
                tagp = "Determinador"
            elif v == "JJ":
                tagp = "adjetivo ou numeral, ordinal"
            elif v == "JJR":
                tagp = "adjetivo, comparativo"
            elif v == "MD":
                tagp = "modal auxiliar"
                
            print " - %s: %s\n" % (tagp, d[k][v])

print test()

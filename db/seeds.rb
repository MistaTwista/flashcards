# ruby encoding: utf-8
require 'open-uri'
voc = Nokogiri::HTML(open("http://russian.languagedaily.com/wordsandphrases/russian-cognates"))

def clear(str)
  str.squish.mb_chars.downcase.to_s
end
voc.css("div.jsn-article-content ul li").each do |li|
  default_user = User.first
  li = clear(li.content)
  words = li.delete("-").split(" ")
  Card.create(original_text: words[0], translated_text: words[1], user: default_user)
end

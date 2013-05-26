# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'

Plugin.create(:most_dig) do

  command(:most_dig,
          name: 'most掘り返し',
          description: 'mostを掘り返しちゃいます',
          condition: lambda{|x| true},
          visible: true,
          role: :timeline) do |opt|
    opt.messages.each do |msg|
      screen_name = msg.user.idname
      doc = Nokogiri::HTML(open("http://ja.favstar.fm/users/#{screen_name}"))
      i = 0
      doc.css('a.fs-date').each do |elm|
        tweet_id = elm['href'].split('/')[-1]
        (Service.primary.twitter/'favorites/create').json(:id => tweet_id)
        (Service.primary.twitter/"statuses/retweet/#{tweet_id}").json( :trim_user => true )
        i += 1
        sleep 2    #掘り起こす間隔。連投したら申し訳ないじゃないですかー #うまく動かないけどね(白目
        break if i == 10  #20RTもしたら厄介でしかないから10RTに制限。限界突破したかったらこの行消してね
      end
    end
  end

end

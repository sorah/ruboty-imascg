require "ruboty-imascg/version"
require 'ruboty/handlers/base'
require 'net/http'
require 'json'
require 'uri'

module Ruboty
  module Handlers
    class Imascg < Base
      VERSION = RubotyImascg::VERSION
      PPDB_API = URI("http://ppdb.sekai.in/api/2/idol.json")
      IMG_URL = "http://125.6.169.35/idolmaster/image_sp/card/%s/%s.jpg"

      on(/imascg(?:\s+?(?<mode>.+?))?(?:\s+?me)?\s+(?<query>.+)$/, name: 'imascg', description: 'find imascg cards')
      on(/imascg flush cache/, name: 'imascg_flush', description: 'flush imascg query cache')

      def imascg(message)
        mode = message[:mode]
        mode = 'l' if !mode || mode.empty?
        mode = 'l_noframe' if mode == 'noframe'

        return if mode == 'flush' && message[:query] == 'cache'

        response = ppdb_query(message[:query])


        if response['message']
          message.reply response['message']
          return
        end

        unless response['data'].kind_of?(Array)
          message.reply response.inspect
          return
        end

        if mode == 'list'
          message.reply response['data'].map{ |_| _['Name'] }.join("\n")
        else
          card =  response['data'].find { |card| card['Name'] == message[:query] } \
               || response['data'].sample
          message.reply card['Name']
          message.reply IMG_URL % [mode, card['ID']]
        end
      end

      def imascg_flush(message)
        ppdb_cache.clear
        message.reply "Flushed"
      end

      private

      def ppdb_query(query)
        return ppdb_cache[query] if ppdb_cache[query]

        response = Net::HTTP.post_form(PPDB_API, "name" => query)

        json = ppdb_cache[query] = JSON.parse(response.body)
        return json

      rescue JSON::ParserError
        if response.body
          return {'message' => response.body}
        end

        return {'message' => 'JSON::ParserError'}
      end

      def ppdb_cache
        @cache ||= {}
      end
    end
  end
end

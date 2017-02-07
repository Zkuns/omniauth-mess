module OmniAuth
  module Strategies
    class GitHub < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://api.github.com',
        authorize_url: 'https://github.com/login/oauth/authorize',
        token_url: 'https://github.com/login/oauth/access_token'
      }

      option :scope, 'user:email'

      uid { 
        raw_info['id'].to_s
      }

      info do
        {
          name: raw_info['name'],
          email: primary_email,
          avatar: raw_info['avatar_url']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('user').parsed
      end

      def primary_email
        access_token.options[:mode] = :query
        @emails ||= access_token.get('user/emails', :headers => { 'Accept' => 'application/vnd.github.v3' }).parsed
        primary = @emails.find{ |i| i['primary'] && i['verified'] }
        primary && primary['email'] || nil
      end

    end
  end
end
OmniAuth.config.add_camelization 'github', 'GitHub'
